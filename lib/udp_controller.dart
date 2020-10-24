import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:wifi_ip/wifi_ip.dart';
import 'package:udp/udp.dart';

import 'controller.dart';

abstract class UDPCotroller {
  static final int _PORT_OUT = 6454;
  static final int _PORT_IN = 6455;
  static final int _PORT_IN_UPD = 6457;
  static InternetAddress _local_ip;

  static setLocalIp() async {
    WifiIpInfo info;
    try {
      info = await WifiIp.getWifiIp;
    } on PlatformException {
      print('Failed to get local IP');
    }
    _local_ip = InternetAddress(info.ip);
    //print(_local_ip);
  }

  static Future<void> scanRequest() async{
    // if(_local_ip == null) {
    setLocalIp();
    //}
    Map<int, InternetAddress> toScanList = new Map<int, InternetAddress>();
//List<int> scanned = new List<int>();
    for(int i = 21; i <= 40; i++) {
      toScanList.putIfAbsent(i, () => _getDestinationIp(i));
    }
    var sender = await UDP.bind(Endpoint.unicast(_local_ip, port: Port(_PORT_OUT)));
    var receiver = await UDP.bind(Endpoint.unicast(_local_ip, port: Port(_PORT_IN)));

    await toScanList.forEach((key, value) async{
      Uint8List data = formHeader(key, "G", "S");
      var dataLength = await sender.send(data, Endpoint.unicast(value, port: Port(_PORT_OUT)));
      await receiver.listen((datagram) {
        Controller.fillEspView(datagram);
        //print(datagram);
      }, timeout: Duration(milliseconds: 1000));
    });

    udpServerUpdate();
  }

  static Future<void> udpServerUpdate() async{
    setLocalIp();
    var receiver = await UDP.bind(Endpoint.unicast(_local_ip, port: Port(_PORT_IN_UPD)));
    receiver.listen((datagram) {
      Controller.updateEspView(datagram);
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
    var sender = await UDP.bind(Endpoint.unicast(_local_ip, port: Port(_PORT_OUT)));
    if (Controller.providerModel.list != null) {
      Controller.providerModel.list.forEach((element) async{
        if (element.selected) {
          Uint8List data = formHeader(element.uni, "S", "H");
          var dataLength = await sender.send(data, Endpoint.unicast(InternetAddress(element.ipAddr), port: Port(_PORT_OUT)));
        }
      });
    }
  }

  static void unsetHighlite(List<int> list) async{
    //if(_local_ip == null) {
    setLocalIp();
    //}
    var sender = await UDP.bind(Endpoint.unicast(_local_ip, port: Port(_PORT_OUT)));
    if (list != null) {
      list.forEach((element) async{
        Uint8List data = formHeader(element, "S", "h");
        var dataLength = await sender.send(data, Endpoint.unicast(_getDestinationIp(element), port: Port(_PORT_OUT)));
      });
    }
  }

  static void setReset() async{
    //if(_local_ip == null) {
    setLocalIp();
    //}
    var sender = await UDP.bind(Endpoint.unicast(_local_ip, port: Port(_PORT_OUT)));
    if (Controller.providerModel.list != null) {
      Controller.providerModel.list.forEach((element) async{
        if (element.selected) {
          Uint8List data = formHeader(element.uni, "S", "R");
          var dataLength = await sender.send(data, Endpoint.unicast(InternetAddress(element.ipAddr), port: Port(_PORT_OUT)));
        }
      });
    }
  }

  static void formatFS() async{
    //if(_local_ip == null) {
    setLocalIp();
    //}
    var sender = await UDP.bind(Endpoint.unicast(_local_ip, port: Port(_PORT_OUT)));
    if (Controller.providerModel.list != null) {
      Controller.providerModel.list.forEach((element) async{
        if (element.selected) {
          Uint8List data = formHeader(element.uni, "S", "F");
          var dataLength = await sender.send(data, Endpoint.unicast(InternetAddress(element.ipAddr), port: Port(_PORT_OUT)));
        }
      });
    }
  }

  static void setDefault() async{

}

  static void setSend(int save) async{
    setLocalIp();
    var sender = await UDP.bind(Endpoint.unicast(_local_ip, port: Port(_PORT_OUT)));
    if(Controller.providerModel.list != null) {
      Controller.providerModel.list.forEach((element) async{
        if(element.selected) {
          Uint8List header = formHeader(element.uni, "S", "S");
          Uint8List data = Uint8List(17);
          //print(save);
          int addr_low = 0;
          int addr_high = 0;
          int reverse = 0;
          if(element.ram_set.address > 255) {
            addr_low = 255;
            addr_high = element.ram_set.address%255;
          }
          else {
            addr_low = element.ram_set.address;
            addr_high = 0;
          }
          if(element.ram_set.reverse) reverse = 1;
          data.setRange(0, 17, List.from([
            element.ram_set.mode,
            element.ram_set.automode,
            element.ram_set.numEffect,
            element.ram_set.speed,
            element.ram_set.color.red,
            element.ram_set.color.green,
            element.ram_set.color.blue,
            element.ram_set.dimmer,
            save,
            element.ram_set.universe,
            addr_low,
            addr_high,
            reverse,
            element.ram_set.pixelCount,
            element.ram_set.startPixel,
            element.ram_set.endPixel,
            element.ram_set.segment
          ]));
          List<int> temp = header + data;
          //print(temp);
          int datalength = await sender.send(temp, Endpoint.unicast(InternetAddress(element.ipAddr), port: Port(_PORT_OUT)));
        }
      });
    }
  }

  static Uint8List formHeader(int uni, String command, String option) {
    Uint8List data = new Uint8List(5);
    data.setRange(0, 5, List.from([67, 80, uni, command.codeUnitAt(0), option.codeUnitAt(0)])); //71 83
    //print(data);
    return data;
  }

  static InternetAddress _getDestinationIp(int uni) {
    String ip_start = _local_ip.address.substring(0, _local_ip.address.lastIndexOf('.') + 1);
    String res_ip = ip_start + uni.toString();
    return InternetAddress(res_ip);
  }

}