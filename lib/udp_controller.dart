import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:ledcontroller/model/esp_model.dart';
import 'package:wifi_ip/wifi_ip.dart';
import 'package:udp/udp.dart';

import 'controller.dart';
import 'model/palette.dart';

abstract class UDPCotroller {
  static final int _PORT_OUT = 6454;
  static final int _PORT_IN = 6455;
  static final int _PORT_IN_UPD = 6457;
  static InternetAddress _local_ip;
  static InternetAddress _prevIP;
  static UDP sender, receiver, receiverUpdate;
  static bool senderBinded = false, receiverBinded = false, receiverUpdateBinded = false;
  static bool ipChanged = false;

  static setLocalIp() async {
    WifiIpInfo info;
    try {
      info = await WifiIp.getWifiIp;
    } on PlatformException {
      print('Failed to get local IP');
    }
    if(_prevIP == null) _prevIP = InternetAddress(info.ip);
    else _prevIP = _local_ip;
    _local_ip = InternetAddress(info.ip);
    if(_local_ip != _prevIP) {
      Controller.providerModel.list.clear();
      Controller.providerModel.notify();
      print("**setLocalIP** ip Changed: localIP: $_local_ip, prevIP: $_prevIP}");
      unBindAll();
    }
    //print("**setLocalIP** localIP: $_local_ip}");
    //print("**setLoclaIP** prevIP: $_prevIP");
  }

  static void unBindAll() {
    print("Start unbinding");
    sender.close();
    receiver.close();
    receiverUpdate.close();
    resetBindFlags();
    print("Unbunded");
  }

  static void resetBindFlags() {
    senderBinded = false;
    receiverBinded = false;
    receiverUpdateBinded = false;
  }

  static Future<void> senderBind() async{
    if (!senderBinded) {
      sender = await UDP.bind(Endpoint.unicast(_local_ip, port: Port(_PORT_OUT)));
      senderBinded = true;
      print("senderBinded");
    } else{
      print("sender already binded");
    }
  }

  static Future<UDP> receiverBind() async{
    UDP udpreceiver;
    if (!receiverBinded) {
      udpreceiver = await UDP.bind(Endpoint.unicast(_local_ip, port: Port(_PORT_IN)));
      receiverBinded = true;
      print("receiverBinded");
    } else{
      print("receiver already binded");
    }
    return udpreceiver;
  }

  static Future<void> receiverUpdateBind() async{
    if (!receiverUpdateBinded) {
      receiverUpdate = await UDP.bind(Endpoint.unicast(_local_ip, port: Port(_PORT_IN_UPD)));
      receiverUpdateBinded = true;
      print("receiverUpdateBinded");
    } else{
      print("receiverUpdate already binded");
    }
  }



  static Future<void> scanRequest() async{
    // if(_local_ip == null) {
    setLocalIp();
    //}
    Map<int, InternetAddress> toScanList = new Map<int, InternetAddress>();
//List<int> scanned = new List<int>();
    for(int i = 1; i <= 254; i++) {
      toScanList.putIfAbsent(i, () => _getDestinationIp(i));
    }

    await senderBind();
    UDP udpreceiver = await receiverBind();
    await toScanList.forEach((key, value) async{
      Uint8List data = formHeader(key, "G", "S");
      var dataLength = await sender.send(data, Endpoint.unicast(value, port: Port(_PORT_OUT)));
      //print("datalength: $dataLength");
      await udpreceiver.listen((datagram) {
        print("recDatagrLength: ${datagram.address.address}");
        Controller.fillEspView(datagram);
        print("**ScanRequest** ${datagram.address}");
      }, timeout: Duration(milliseconds: 1000));
    });
    udpreceiver.close();
    receiverBinded = false;
    udpServerUpdate();
  }

  static Future<void> udpServerUpdate() async{
    //print("udpUpdate");
    setLocalIp();

    await receiverUpdateBind();

    receiverUpdate.listen((datagram) {
      Controller.updateEspView2(datagram);
    });
  }

  static Stream<int> countStream() async* {
    for (int i = 21; i <= 40; i++) {
      yield i;
    }
  }

  static void setHighlite() async{
    ////if(_local_ip == null) {
    setLocalIp();
    //}
    await senderBind();
    if (Controller.providerModel.list != null) {
      Controller.providerModel.list.forEach((element) async{
        if (element.selected) {
          Uint8List data = formHeader(element.uni, "S", "H");
          await sender.send(data, Endpoint.unicast(InternetAddress(element.ipAddress), port: Port(_PORT_OUT)));
        }
      });
    }
  }

  static void unsetHighlite(List<EspModel> list) async{
    //if(_local_ip == null) {
    setLocalIp();
    //}
    await senderBind();
    if (list != null) {
      list.forEach((element) async{
        Uint8List data = formHeader(element.uni, "S", "h");
        var dataLength = await sender.send(data, Endpoint.unicast(InternetAddress(element.ipAddress), port: Port(_PORT_OUT)));
      });
    }
  }

  static void setReset() async{
    //if(_local_ip == null) {
    setLocalIp();
    //}
    await senderBind();
    if (Controller.providerModel.list != null) {
      Controller.providerModel.list.forEach((element) async{
        if (element.selected) {
          Uint8List data = formHeader(element.uni, "S", "R");
          var dataLength = await sender.send(data, Endpoint.unicast(InternetAddress(element.ipAddress), port: Port(_PORT_OUT)));
        }
      });
    }
  }

  static void formatFS() async{
    //if(_local_ip == null) {
    setLocalIp();
    //}
    await senderBind();
    if (Controller.providerModel.list != null) {
      Controller.providerModel.list.forEach((element) async{
        if (element.selected) {
          Uint8List data = formHeader(element.uni, "S", "F");
          var dataLength = await sender.send(data, Endpoint.unicast(InternetAddress(element.ipAddress), port: Port(_PORT_OUT)));
        }
      });
    }
  }

  static void setDefault() async{

}

  static void setName(String text) async{
    setLocalIp();
    await senderBind();
    Controller.providerModel.list.forEach((element) {
      if(element.selected) {
        Uint8List header = formHeader(element.uni, "S", "N");
        Uint8List data = Uint8List(1);
        data[0] = text.length;
        List<int> temp = header + data + text.codeUnits;
        sender.send(temp, Endpoint.unicast(InternetAddress(element.ipAddress), port: Port(_PORT_OUT)));
      }
    });
  }

  static Future<void> setPixelCount(int count) async{
    setLocalIp();
    await senderBind();
    Controller.providerModel.list.forEach((element) {
      if(element.selected) {
        Uint8List header = formHeader(element.uni, "S", "P");
        Uint8List data = Uint8List(2);
        data[0] = count;
        data[1] = count >> 8;
        List<int> temp = header + data;
        sender.send(temp, Endpoint.unicast(InternetAddress(element.ipAddress), port: Port(_PORT_OUT)));
      }
    });
  }

  static setNetworkSettings(String ssid, String password, bool netmode) async{
    setLocalIp();
    await senderBind();
    Controller.providerModel.list.forEach((element) {
      if(element.selected) {
        Uint8List header = formHeader(element.uni, "S", "W");
        Uint8List data = Uint8List(3);
        data[0] = netmode ? 1 : 0;
        data[1] = ssid.length;
        data[2] = password.length;
        List<int> temp = header + data + ssid.codeUnits + password.codeUnits;
        sender.send(temp, Endpoint.unicast(InternetAddress(element.ipAddress), port: Port(_PORT_OUT)));
      }
    });
  }

  static void setSend(int save) async{
    setLocalIp();
    await senderBind();
    if(Controller.providerModel.list != null) {
      Controller.providerModel.list.forEach((element) async{
        if(element.selected) {
          Uint8List header = formHeader(element.uni, "S", "S");
          Uint8List data = Uint8List(30);
          //print(save);
          int addrLow = 0;
          int addrHigh = 0;
          int reverse = 0;
//          print("UdpController.setSend: ramse addr: ${element.ram_set.address}");
          if(element.ramSet.address > 255) {
            addrLow = 255;
            addrHigh = element.ramSet.address%255;
          }
          else {
            addrLow = element.ramSet.address;
            addrHigh = 0;
          }
          if(element.ramSet.reverse) reverse = 1;
          //print("width: ${element.ramSet.fxWidth}");
          //print("mode: ${element.ramSet.mode}");
          data.setRange(0, 30, List.from([
            element.ramSet.mode,
            element.ramSet.automode,
            element.ramSet.numEffect,
            element.ramSet.speed,
            element.ramSet.color.red,
            element.ramSet.color.green,
            element.ramSet.color.blue,
            element.ramSet.dimmer,
            save,
            element.ramSet.universe,
            addrLow,
            addrHigh,
            reverse,
            element.ramSet.pixelCount,
            element.ramSet.startPixel,
            element.ramSet.endPixel,
            element.ramSet.segment,
            element.ramSet.pixelCount>>8,
            element.ramSet.startPixel>>8,
            element.ramSet.endPixel>>8,
            element.ramSet.fxColor.red,
            element.ramSet.fxColor.green,
            element.ramSet.fxColor.blue,
            element.ramSet.strobe,
            element.ramSet.fxSize,
            element.ramSet.fxParts,
            element.ramSet.fxFade,
            element.ramSet.fxParams,
            element.ramSet.fxSpread,
            element.ramSet.fxWidth,
          ]));
          List<int> temp = header + data;
          //print(temp);
          int datalength = await sender.send(temp, Endpoint.unicast(InternetAddress(element.ipAddress), port: Port(_PORT_OUT)));
        }
      });
    }
  }

  static void sendPlayList() async{
    setLocalIp();
    await senderBind();
    List<Palette> list = Controller.paletteProvider.playlist;
    int packetLength = list.length*16 + 3;
    Uint8List data = Uint8List(packetLength);
    print("length: ${list.length} period: ${Controller.paletteProvider.playlistPeriod}");
    data[0] = list.length;
    data[1] = Controller.paletteProvider.playlistPeriod;
    data[2] = Controller.paletteProvider.playlistPeriod>>8;
    int i = 3;
    list.forEach((el) {
      data[i++] = el.settings[0].settings.dimmer;
      data[i++] = el.settings[0].settings.color.red;
      data[i++] = el.settings[0].settings.color.green;
      data[i++] = el.settings[0].settings.color.blue;
      data[i++] = el.settings[0].settings.fxColor.red;
      data[i++] = el.settings[0].settings.fxColor.green;
      data[i++] = el.settings[0].settings.fxColor.blue;
      data[i++] = el.settings[0].settings.strobe;
      data[i++] = el.settings[0].settings.numEffect;
      data[i++] = el.settings[0].settings.speed;
      data[i++] = el.settings[0].settings.fxSize;
      data[i++] = el.settings[0].settings.fxParts;
      data[i++] = el.settings[0].settings.fxFade;
      data[i++] = el.settings[0].settings.fxParams;
      data[i++] = el.settings[0].settings.fxSpread;
      data[i++] = el.settings[0].settings.fxWidth;
    });
    if(Controller.providerModel.list != null) {
      Controller.providerModel.list.forEach((element) async {
        if (element.selected) {
          Uint8List header = formHeader(element.uni, "S", "L");
          List<int> temp = header + data;
          int datalength = await sender.send(temp, Endpoint.unicast(InternetAddress(element.ipAddress), port: Port(_PORT_OUT)));
        }
      });
    }
  }

  static void testSend() async{
    setLocalIp();
    await senderBind();
    Uint8List header = formHeader(31, "S", "S");
    Uint8List data = Uint8List(17);
    Uint8List data2 = Uint8List(12);
    data.setRange(0, 17, List.from([
      5, 6, 7,  8,  9, 10, 11, 12, 13, 14, 15, 16, 17, 0, 1, 2, 3
    ]));
    String name = "Elka";
    String ssid = "NetworkName0";
    String pass = "1234567";
    print("${pass.codeUnits.length}");
    data2.setRange(0, 12, List.from([4, 5, 6, 7, 8, 9, 10, 11 , name.length, ssid.length, pass.length, 3]));
    List<int> temp = header + data + data2 + name.codeUnits + ssid.codeUnits + pass.codeUnits;
          //print(temp);
    int datalength = await sender.send(temp, Endpoint.unicast(_getDestinationIp(31), port: Port(_PORT_OUT)));
        
  }

  static Uint8List formHeader(int uni, String command, String option) {
    Uint8List data = new Uint8List(5);
    data.setRange(0, 5, List.from([67, 80, uni, command.codeUnitAt(0), option.codeUnitAt(0)])); //71 83
    //print(data);
    return data;
  }

  static InternetAddress _getDestinationIp(int uni) {
    String ipStart = _local_ip.address.substring(0, _local_ip.address.lastIndexOf('.') + 1);
    String resIp = ipStart + uni.toString();
    return InternetAddress(resIp);
  }





}