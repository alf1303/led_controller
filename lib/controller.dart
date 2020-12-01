import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ledcontroller/model/palette_entry.dart';
import 'package:ledcontroller/model/palette_types.dart';
import 'package:ledcontroller/model/settings.dart';
import 'package:ledcontroller/palettes_provider.dart';
import 'package:ledcontroller/provider_model_attribute.dart';
import 'package:ledcontroller/udp_controller.dart';
import 'package:ledcontroller/provider_model.dart';
import 'package:path_provider/path_provider.dart';
import 'model/esp_model.dart';
import 'model/palette.dart';

abstract class Controller {
  static Random random = new Random();
  static final providerModel = ProviderModel();
  static final providerModelAttribute = ProviderModelAttribute();
  static final paletteProvider = PaletteProvider();
  static bool highlite = false;
  static File f;


  static fakeInit() {
    for (int i = 21; i <= 40; i++) {
      Settings fsSet = Settings(random.nextInt(4), random.nextInt(3), i, i+100, Color.fromRGBO(random.nextInt(255), random.nextInt(255), 0, 1), random.nextInt(255));
      Settings ramSet = Settings(random.nextInt(4), random.nextInt(3), i, i+100, Color.fromRGBO(random.nextInt(255), random.nextInt(255), 0, 1), random.nextInt(255));
      ramSet.address = 223;
      ramSet.reverse = false;
      ramSet.startPixel = 0;
      ramSet.endPixel = 112;
      ramSet.pixelCount = 120;
      EspModel esp = new EspModel(i, "192.168.0.$i", "v_0.5.9", fsSet, ramSet);
      providerModel.list.add(esp);
    }
    providerModel.notify();
  }

  static initWiFi() {
    UDPCotroller.setLocalIp();
  }

  static initPalettes() async{
    paletteProvider.createEmptyPalettes();
    String dir = (await getApplicationDocumentsDirectory()).path;
    f = new File("$dir/palettes.txt");
    //f.delete();
    if(!await f.exists()) {
      print("palette file notExists");
      //List<Palette> palettes = List();
      Settings white = new Settings.full(2, 0, 0, 128, Color.fromRGBO(255, 255, 255, 1), 255, 0, 0, false, 120, 0, 120, 8, 0, false, Colors.blue, 0, 100, 1, 0, 0, 1, 1, false, false, false, false, false);
      Palette pWhite = new Palette.withParams(PaletteType.PALETTE, white);
//      Settings red = new Settings.full(2, 0, 0, 128, Color.fromRGBO(255, 0, 0, 1), 255, 0, 0, false, 120, 0, 120, 8);
//      Palette pRed = new Palette.withParams(PaletteType.PALETTE, red);
//      Settings green = new Settings.full(2, 0, 0, 128, Color.fromRGBO(0, 255, 0, 1), 255, 0, 0, false, 120, 0, 120, 8);
//      Palette pGreen = new Palette.withParams(PaletteType.PALETTE, green);
//      Settings blue = new Settings.full(2, 0, 0, 128, Color.fromRGBO(0, 0, 255, 1), 255, 0, 0, false, 120, 0, 120, 8);
//      Palette pBlue = new Palette.withParams(PaletteType.PALETTE, blue);
//      Settings black = new Settings.full(2, 0, 0, 128, Color.fromRGBO(0, 0, 0, 1), 255, 0, 0, false, 120, 0, 120, 8);
//      Palette pBlack = new Palette.withParams(PaletteType.PALETTE, black);
      List<Palette> palettes = [pWhite];
      for(int i = 0; i < paletteProvider.PALETTES_COUNT - 5; i++) {
        palettes.add(new Palette());
      }
      var sink = f.openWrite();
      palettes.forEach((element) {
        sink.write('${jsonEncode(element)}\n');
      });
      sink.close();
    }
    await loadPalettesFromFS(f);
  }

  static Future<void> scan() async{
    providerModel.list.clear();
    providerModel.selected = false;
    providerModel.notify();
    //providerModel.list.forEach((element) { element.isAlive = false;});
    await UDPCotroller.scanRequest();
    //setSend(255);
    return await Future.delayed(Duration(seconds: 2), () {return false;});
  }

  static void setHighlite() {
    UDPCotroller.setHighlite();
    providerModel.notify();
  }

  static void unsetHL(EspModel model) {
    List<EspModel> list = List.from([model]);
    UDPCotroller.unsetHighlite(list);
    providerModel.notify();
  }

  static void unsetHLAll() {
    List<EspModel> list = List();
    providerModel.list.forEach((element) {
      list.add(element);
    });
    UDPCotroller.unsetHighlite(list);
    providerModel.notify();
  }

  static setReset() {
    UDPCotroller.setReset();
  }

  static formatFS() {
    UDPCotroller.formatFS();
  }

  static setDefault() {
    UDPCotroller.setDefault();
  }

  static setSend(int save) {
    UDPCotroller.setSend(save);
    providerModel.notify();
  }

  static setSendWithoutUpdate(int save) {
    UDPCotroller.setSend(save);
    //providerModel.notify();
  }

  static void setArea(int pixelCount, RangeValues curRange) async{
    providerModel.list.forEach((element) {
      if(element.selected) {
        element.ramSet.pixelCount = pixelCount;
        element.ramSet.startPixel = curRange.start.round();
        element.ramSet.endPixel = curRange.end.round();
      }
    });
    setSend(64);
  }

  static void setName(String text) {
    UDPCotroller.setName(text);
  }

  static Future<void> setPixelCount(int count) async{
    await UDPCotroller.setPixelCount(count);
  }

  static Future<void> setNetworkSettings(String ssid, String password, bool netmode) async{
    await UDPCotroller.setNetworkSettings(ssid, password, netmode);
  }

  static bool areNotSelected() {
    List<EspModel> subList = List();
    subList = providerModel.list.where((element) => element.selected).toList();
    return subList.length == 0;
  }

  static selectAll() {
    providerModel.list.forEach((element) {
      element.selected = true;
    });
    providerModel.checkSelected();
    providerModel.notify();
  }

  static deselectAll() {
    providerModel.list.forEach((element) {
      element.selected = false;
    });
    providerModel.checkSelected();
    providerModel.notify();
  }

  static void fillEspView(Datagram datagr) {
    if(datagr != null) {
      String version = String.fromCharCodes(datagr.data, 3, 10);
      String ipaddr = datagr.address.address;
      Uint8List d = datagr.data;
      //print(datagr.data[33]);
      int uni = d[2];
      print("***fillEspView*** $uni");
      //int uni = int.parse(ipaddr.split('.')[3]);
      EspModel espModel = createEspFromData(d);
      espModel.ipAddress = ipaddr;
      espModel.version = version;
      espModel.uni = uni;
      EspModel findModel;
      if(providerModel.list.isNotEmpty) {
        findModel = providerModel.list.firstWhere((element) => element.uni == uni, orElse: ()=>null);
      }
      if(findModel == null) {
        providerModel.list.add(espModel);
        print("**fillEspView** added");
      }
      providerModel.notify();
    }
  }

  static void updateEspView2(Datagram datagr) {
    if(datagr != null)
    {
      //print("updateEspView2, uni: ${datagr.data[2]}");
    //print("${providerModel.list.length}");
       }
    else {
      //print("updateEspView2, null");
    }
    if(datagr != null) {
      Uint8List d = datagr.data;
      int uni = d[2];
      String version = String.fromCharCodes(datagr.data, 3, 10);
      String ipaddr = datagr.address.address;
      EspModel espModel = createEspFromData(d);
      espModel.uni = uni;
      espModel.ipAddress = ipaddr;
      espModel.version = version;
      EspModel findModel = null;
      if(providerModel.list.isNotEmpty) {
        findModel = providerModel.list.firstWhere((element) => element.uni == uni, orElse: (){return null;});
      }
      if(findModel == null) {
        providerModel.list.add(espModel);
        //print("**upddateEspView2** added");
      }
      else {
        findModel.copyFrom(espModel);
      }
      providerModel.notify();
    }
  }

  static void updateEspView(Datagram datagr) {
    print("AAAAAAAAAAALAAARM updateEspView");
    if(datagr != null) {
      Uint8List d = datagr.data;
      int uni = d[2];
     // print("uni: $uni");
      providerModel.list.forEach((element) {
        //print("element.uni: ${element.uni}");
        if(element.uni == uni) {
          EspModel model = createEspFromData(d);
          element.fsSet.copy(model.fsSet);
          element.ramSet.copy(model.ramSet);
        }
      });
      providerModel.notify();
     // print("red: ${d[21]}, green: ${d[22]}, blue: ${d[23]}");
//      print(ipaddr);
//      print(uni);
    }
  }

  static EspModel createEspFromData(Uint8List d) {
    String name = "", ssid = "", password = "";
    bool playlistMode = false;
    int netMode;
    Color colorFs = Color.fromRGBO(d[18], d[19], d[20], 1);
    Color colorRam = Color.fromRGBO(d[21], d[22], d[23], 1);
    Settings fsSet = Settings(d[10], d[12], d[14], d[16], colorFs, d[24]);
    Settings ramSet = Settings(d[11], d[13], d[15], d[17], colorRam, d[25]);
    fsSet.universe = d[26];
    fsSet.address = d[27] == 0 ? d[28] : d[27] + d[28] + 1;
    ramSet.universe = d[26];
    ramSet.address = d[27] == 0 ? d[28] : d[27] + d[28] + 1;
    d[29] == 1 ? fsSet.reverse = true : fsSet.reverse = false;
    d[29] == 1 ? ramSet.reverse = true : ramSet.reverse = false;
    fsSet.pixelCount = d[30];
    fsSet.startPixel = d[31];
    fsSet.endPixel = d[32];
    fsSet.segment = d[33];
    ramSet.pixelCount = d[30];
    ramSet.startPixel = d[31];
    ramSet.endPixel = d[32];
    ramSet.segment = d[33];
    //туц
    if(d.length > 34) {
      ramSet.pixelCount = d[30] + (d[34]<<8);
      ramSet.startPixel = d[31] + (d[35]<<8);
      ramSet.endPixel = d[32] + (d[36]<<8);
      ramSet.fxColor = Color.fromRGBO(d[37], d[38], d[39], 1);
      ramSet.strobe = d[40];
      ramSet.fxSize = d[41];
      ramSet.fxParts = d[42];
      ramSet.fxFade = d[43];
      ramSet.fxParams = d[44];
      ramSet.fxSpread = d[45];
      ramSet.fxWidth = d[46];
      ramSet.fxReverse = ramSet.fxParams&1 == 1 ? true : false;
      ramSet.fxAttack = (ramSet.fxParams>>1)&1 == 1 ? true : false;
      ramSet.fxSymm = (ramSet.fxParams>>2)&1 == 1 ? true : false;
      ramSet.fxRnd = (ramSet.fxParams>>3)&1 == 1 ? true : false;
      ramSet.fxRndColor = (ramSet.fxParams>>7)&1 == 1 ? true : false;
      ramSet.playlistMode = (ramSet.fxParams>>6)&1 == 1 ? true : false;
      netMode = d[47];
      int nameSize = d[48];
      int ssidSize = d[49];
      int passSize = d[50];
      int playListSize = d[51];
      ramSet.playlistSize = playListSize;
      //print("***createEspFromData*** data.length: ${d.length}");
      name = String.fromCharCodes(d, 51, 51+nameSize);
      ssid = String.fromCharCodes(d, 51+nameSize, 51+nameSize+ssidSize);
      password = String.fromCharCodes(d, 51+nameSize+ssidSize, 51+nameSize+ssidSize+passSize);
    }
    EspModel espModel = EspModel(0, "", "", fsSet, ramSet);
    espModel.name = name;
    espModel.netMode = netMode;
    espModel.ssid = ssid;
    espModel.password = password;
    return espModel;
  }

  static void setFaders(Settings set) {
    providerModelAttribute.dim = set.dimmer*1.0;
    providerModelAttribute.red = set.color.red*1.0;
    providerModelAttribute.green = set.color.green*1.0;
    providerModelAttribute.blue = set.color.blue*1.0;
    providerModelAttribute.fxSpeed = set.speed*1.0;
    providerModelAttribute.mode = set.mode;
    providerModelAttribute.automode = set.automode;
    providerModelAttribute.fxNum = set.numEffect;
    providerModelAttribute.fxColor = set.fxColor;
    providerModelAttribute.fxParts = set.fxParts*1.0;
    providerModelAttribute.fxSpread = set.fxSpread*1.0;
    providerModelAttribute.fxSize = set.fxSize*1.0;
    providerModelAttribute.fxWidth = set.fxWidth*1.0;
    providerModelAttribute.fxAttack = set.fxAttack;
    providerModelAttribute.fxReverse = set.fxReverse;
    providerModelAttribute.fxSymm = set.fxSymm;
    providerModelAttribute.fxRnd = set.fxRnd;
    providerModelAttribute.fxRndColor = set.fxRndColor;
    providerModelAttribute.playlistMode = set.playlistMode;
    providerModelAttribute.notify();
  }

  static resetAttributeProviderFlag() {
    providerModelAttribute.flag = false;
  }

  static loadPalettesFromFS(File f) async{
    Stream<List<int>> inputStream = f.openRead();
    int ii = 0;
    inputStream.transform(utf8.decoder).
    transform(new LineSplitter()).
    listen((String line) {
      paletteProvider.list[ii++] = (Palette.fromJson(jsonDecode(line)));
      if(ii == 14) {
        paletteProvider.notify();
        //providerModel.notify();
      }
    });

    //print("Controller.LoadPAletteFromFs: notified");
  }

  static savePalettesToFS() async{
    var sink = f.openWrite();
    paletteProvider.list.forEach((element) {
      sink.write('${jsonEncode(element)}\n');
    });
    sink.close();
  }

  static savePalette(Palette palette) async{
    if(providerModel.countSelected() == 1) {
      palette.settings.clear();
      Settings set = Settings.empty();
      set.copyForPalette(providerModel.getFirstChecked().ramSet);
      palette.settings.add(new PaletteEntry(21, set));
      palette.paletteType = PaletteType.PALETTE;
    }
    else {
      palette.settings.clear();
      providerModel.list.forEach((element) {
        Settings set = Settings.empty();
        set.copyForPalette(element.ramSet);
          palette.settings.add(new PaletteEntry(element.uni, set));
      });
      palette.paletteType = PaletteType.PROGRAM;
    }
    paletteProvider.notify();
    await savePalettesToFS();
  }

  static loadPalette(Palette palette) {
    if(palette.paletteType == PaletteType.PALETTE) {
      providerModel.list.forEach((element) {
        if(element.selected && palette.isNotEmpty()) {
          element.ramSet.copyForPalette(palette.settings[0].settings);
        print("num: ${element.ramSet.numEffect}");
        }
      });
    }
    else {
      if(palette.isNotEmpty() && providerModel.list.isNotEmpty) {
        palette.settings.forEach((el) {
          providerModel.list.firstWhere((element) => element.uni == el.uni).ramSet.copyForPalette(el.settings);
        });
      }
    }
    setFaders(palette.settings[0].settings);
    //providerModel.notify();
  }

  static clearPalette(Palette palette) async{
    palette.settings.clear();
    paletteProvider.notify();
    await savePalettesToFS();
  }

  static addPaletteToPlaylist(Palette palette) {
    paletteProvider.addToPlaylist(palette);
    paletteProvider.notify();
  }

  static removePaletteFromPlaylist(Palette palette) {
    paletteProvider.removeFromPlaylist(palette);
    paletteProvider.notify();
  }

  static sendPlaylist() {
    UDPCotroller.sendPlayList();
  }

  static setMode() async{
    providerModel.list.forEach((element) {
      element.ramSet.mode = 2;
      element.ramSet.automode = 0;
      element.selected = true;
    });
    //providerModel.list.removeWhere((element) => !element.isAlive);
    await setSend(8);
    providerModel.list.forEach((element) {
      if(element.selected) {
        element.selected = false;
      }
    });
  }


}