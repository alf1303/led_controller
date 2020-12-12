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
import 'package:ledcontroller/model/esp_model.dart';
import 'package:ledcontroller/model/palette.dart';

abstract class Controller {
  static Random random = new Random();
  static final providerModel = ProviderModel();
  static final providerModelAttribute = ProviderModelAttribute();
  static final paletteProvider = PaletteProvider();
  static bool highlite = false;
  static File f;
  static bool firstTime = true;
  static bool help = false;


  static fakeInit() {
    for (int i = 21; i <= 22; i++) {
      Settings fsSet = Settings(random.nextInt(4), random.nextInt(3), i, i+10, Color.fromRGBO(random.nextInt(255), random.nextInt(255), 0, 1), random.nextInt(255));
      Settings ramSet = Settings(random.nextInt(4), random.nextInt(3), i, i+10, Color.fromRGBO(random.nextInt(255), random.nextInt(255), 0, 1), random.nextInt(255));
      ramSet.fxParts = ramSet.fxWidth = ramSet.fxSpread = ramSet.fxSize = ramSet.fxFade = 1;
      ramSet.address = 223;
      ramSet.universe = i;
      ramSet.strobe = 1;
      ramSet.reverse = false;
      ramSet.segment = 1;
      ramSet.startPixel = 0;
      ramSet.endPixel = 112;
      ramSet.pixelCount = 120;
      ramSet.fxColor = Colors.cyanAccent;
      ramSet.fxParams = 0;
      ramSet.numEffect = 0;
      ramSet.fxReverse = false;
      ramSet.fxAttack = false;
      ramSet.fxSymm = false;
      ramSet.fxRnd = false;
      ramSet.fxRndColor = false;
      ramSet.playlistMode = false;
      EspModel esp = new EspModel(i, "192.168.0.$i", "v_0.5.9", fsSet, ramSet);
      esp.name = "virtual$i";
      providerModel.list.add(esp);
    }
    providerModel.notify();
  }

  static Future<void> initWiFi() async{
    await UDPCotroller.setLocalIp();
  }

  static initPalettes() async{
    paletteProvider.createEmptyPalettes();
    String dir = (await getApplicationDocumentsDirectory()).path;
    f = new File("$dir/palettes2.txt");
    //f.delete();
    if(!await f.exists()) {
      File prevFile = new File("$dir/palettes.txt");
      if(await prevFile.exists()) {
        await prevFile.delete();
      }
      print("palette2 file notExists");
      //List<Palette> palettes = List();
      Settings black = new Settings.full(2, 0, 0, 40, Color.fromRGBO(0, 0, 0, 1), 255, 0, 0, false, 120, 0, 120, 8, 0, false, Colors.blue, 0, 100, 1, 0, 0, 1, 1, false, false, false, false, false);
      Palette pBlack = new Palette.withParams(PaletteType.PALETTE, black);
      pBlack.name = "black";
      Settings white = new Settings.full(2, 0, 0, 40, Color.fromRGBO(255, 255, 255, 1), 255, 0, 0, false, 120, 0, 120, 8, 0, false, Colors.blue, 0, 100, 1, 0, 0, 1, 1, false, false, false, false, false);
      Palette pWhite = new Palette.withParams(PaletteType.PALETTE, white);
      pWhite.name = "white";
      Settings red = new Settings.full(2, 0, 0, 40, Color.fromRGBO(255, 0, 0, 1), 255, 0, 0, false, 120, 0, 120, 8, 0, false, Colors.blue, 0, 100, 1, 0, 0, 1, 1, false, false, false, false, false);
      Palette pRed = new Palette.withParams(PaletteType.PALETTE, red);
      pRed.name = "red";
      Settings green = new Settings.full(2, 0, 0, 40, Color.fromRGBO(0, 255, 0, 1), 255, 0, 0, false, 120, 0, 120, 8, 0, false, Colors.blue, 0, 100, 1, 0, 0, 1, 1, false, false, false, false, false);
      Palette pGreen = new Palette.withParams(PaletteType.PALETTE, green);
      pGreen.name = "green";
      Settings blue = new Settings.full(2, 0, 0, 40, Color.fromRGBO(0, 0, 255, 1), 255, 0, 0, false, 120, 0, 120, 8, 0, false, Colors.blue, 0, 100, 1, 0, 0, 1, 1, false, false, false, false, false);
      Palette pBlue = new Palette.withParams(PaletteType.PALETTE, blue);
      pBlue.name = "blue";
      Settings cyan = new Settings.full(2, 0, 0, 40, Color.fromRGBO(0, 255, 255, 1), 255, 0, 0, false, 120, 0, 120, 8, 0, false, Colors.blue, 0, 100, 1, 0, 0, 1, 1, false, false, false, false, false);
      Palette pCyan = new Palette.withParams(PaletteType.PALETTE, cyan);
      pCyan.name = "Cyan";
      Settings magenta = new Settings.full(2, 0, 0, 40, Color.fromRGBO(255, 0, 255, 1), 255, 0, 0, false, 120, 0, 120, 8, 0, false, Colors.blue, 0, 100, 1, 0, 0, 1, 1, false, false, false, false, false);
      Palette pMagenta = new Palette.withParams(PaletteType.PALETTE, magenta);
      pMagenta.name = "Magenta";
      Settings yellow = new Settings.full(2, 0, 0, 40, Color.fromRGBO(255, 255, 0, 1), 255, 0, 0, false, 120, 0, 120, 8, 0, false, Colors.blue, 0, 100, 1, 0, 0, 1, 1, false, false, false, false, false);
      Palette pYellow = new Palette.withParams(PaletteType.PALETTE, yellow);
      pYellow.name = "Yellow";

      Settings fx1 = new Settings.full(2, 0, 3, 96, Color.fromRGBO(0, 0, 10, 1), 30, 0, 0, false, 120, 0, 120, 8, 0, false, Colors.white, 0, 100, 6, 0, 8, 8, 3, false, false, false, true, false);
      Palette pFx1 = new Palette.withParams(PaletteType.PALETTE, fx1);
      pFx1.name = "Stars";

      Settings fx2 = new Settings.full(2, 0, 3, 78, Color.fromRGBO(0, 0, 0, 1), 30, 0, 0, false, 120, 0, 120, 8, 0, false, Colors.amber, 0, 100, 1, 0, 4, 1, 3, false, false, true, false, false);
      Palette pFx2 = new Palette.withParams(PaletteType.PALETTE, fx2);
      pFx2.name = "Symm";

      Settings fx3 = new Settings.full(2, 0, 3, 99, Color.fromRGBO(0, 0, 0, 1), 30, 0, 0, false, 120, 0, 120, 8, 0, false, Colors.amber, 0, 100, 6, 0, 136, 16, 4, false, false, false, true, true);
      Palette pFx3 = new Palette.withParams(PaletteType.PALETTE, fx3);
      pFx3.name = "RndCol";

      Settings fx4 = new Settings.full(2, 0, 4, 31, Color.fromRGBO(0, 0, 0, 1), 30, 0, 0, false, 120, 0, 120, 8, 0, false, Colors.amber, 0, 100, 42, 0, 0, 1, 1, false, false, false, false, false);
      Palette pFx4 = new Palette.withParams(PaletteType.PALETTE, fx4);
      pFx4.name = "RGB";

      Settings fx5 = new Settings.full(2, 0, 3, 80, Color.fromRGBO(170, 0, 0, 1), 30, 0, 0, false, 120, 0, 120, 8, 0, false, Colors.cyan, 0, 100, 22, 0, 0, 1, 3, false, false, false, false, false);
      Palette pFx5 = new Palette.withParams(PaletteType.PALETTE, fx5);
      pFx5.name = "Snake";

      List<Palette> palettes = [pBlack, pWhite, pRed, pGreen, pBlue, pCyan, pMagenta, pYellow, pFx1, pFx2, pFx3, pFx4, pFx5];
      var sink = f.openWrite();
      palettes.forEach((element) async{
        //print(element.name);
        await sink.write('${jsonEncode(element)}\n');
      });
      await sink.close();
      //print(f.length());
    }
    await loadPalettesFromFS(f);
  }

  static Future<void> scan() async{
    providerModel.list.clear();
    providerModel.selected = false;
    providerModel.notify();
    //providerModel.list.forEach((element) { element.isAlive = false;});
    await UDPCotroller.scanRequest();
    //await UDPCotroller.scanRequest();
    //setSend(255);
    providerModel.notify();
    return await Future.delayed(Duration(seconds: 1), () {return false;});
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

  static setSendWithoutUpdate(int save, [int grandmaster]) {
    UDPCotroller.setSend(save, true, grandmaster);
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
      //print("d2: ${d[2]}, ipAddr: ${datagr.address.rawAddress[3]}");
      int uni = datagr.address.rawAddress[3];
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
    //print("setFaders: ${set.fxRnd}");
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
      if(line != "v1") {
        //print(line);
        Palette pal = Palette.fromJson(jsonDecode(line));
        if (pal.settings.isNotEmpty) {
          //print("name: ${pal.name}, rnd: ${pal.settings[0].settings.fxRnd}");
        }
        paletteProvider.list[ii] = null;
        paletteProvider.list[ii++] = (Palette.fromJson(jsonDecode(line)));
        if(ii == paletteProvider.PALETTES_COUNT) {
          paletteProvider.notify();
          //providerModel.notify();
        }
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
    if(palette.paletteType == PaletteType.PALETTE) {
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
          //print("rnd: ${palette.settings[0].settings.fxRnd}");
          //print("params: ${palette.settings[0].settings.fxParams}");
        }
      });
    }
    else {
      if(palette.isNotEmpty() && providerModel.list.isNotEmpty) {
        palette.settings.forEach((el) {
          EspModel model = providerModel.list.firstWhere((element) => element.uni == el.uni, orElse: ()=>null);
          if(model != null) {
            model.ramSet.copyForPalette(el.settings);
          }
          //providerModel.list.firstWhere((element) => element.uni == el.uni).ramSet.copyForPalette(el.settings);
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