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
      Settings white = new Settings.full(2, 0, 0, 128, Color.fromRGBO(255, 255, 255, 1), 255, 0, 0, false, 120, 0, 120, 8);
      Palette pWhite = new Palette.withParams(PaletteType.PALETTE, white);
      Settings red = new Settings.full(2, 0, 0, 128, Color.fromRGBO(255, 0, 0, 1), 255, 0, 0, false, 120, 0, 120, 8);
      Palette pRed = new Palette.withParams(PaletteType.PALETTE, red);
      Settings green = new Settings.full(2, 0, 0, 128, Color.fromRGBO(0, 255, 0, 1), 255, 0, 0, false, 120, 0, 120, 8);
      Palette pGreen = new Palette.withParams(PaletteType.PALETTE, green);
      Settings blue = new Settings.full(2, 0, 0, 128, Color.fromRGBO(0, 0, 255, 1), 255, 0, 0, false, 120, 0, 120, 8);
      Palette pBlue = new Palette.withParams(PaletteType.PALETTE, blue);
      Settings black = new Settings.full(2, 0, 0, 128, Color.fromRGBO(0, 0, 0, 1), 255, 0, 0, false, 120, 0, 120, 8);
      Palette pBlack = new Palette.withParams(PaletteType.PALETTE, black);
      List<Palette> palettes = [pWhite, pRed, pGreen, pBlue, pBlack];
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

  static Future<bool> scan() async{
    providerModel.list.clear();
    await UDPCotroller.scanRequest();
    providerModel.list.forEach((element) {
      element.ramSet.mode = 2;
      element.ramSet.automode = 0;
    });
    setSend(255);
    return await Future.delayed(Duration(seconds: 1), () {return false;});
  }

  static void setHighlite() {
    UDPCotroller.setHighlite();
    providerModel.notify();
  }

  static void unsetHL(int uni) {
    List<int> list = List.from([uni]);
    UDPCotroller.unsetHighlite(list);
    providerModel.notify();
  }

  static void unsetHLAll() {
    List<int> list = List<int>();
    providerModel.list.forEach((element) {
      list.add(element.uni);
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

  static bool areNotSelected() {
    List<EspModel> subList = List();
    subList = providerModel.list.where((element) => element.selected).toList();
    return subList.length == 0;
  }

  static selectAll() {
    providerModel.list.forEach((element) {
      element.selected = true;
    });
    providerModel.notify();
  }

  static deselectAll() {
    providerModel.list.forEach((element) {
      element.selected = false;
    });
    providerModel.notify();
  }

  static void fillEspView(Datagram datagr) {
    if(datagr != null) {
      String version = String.fromCharCodes(datagr.data, 3, 10);
      String ipaddr = datagr.address.address;
      Uint8List d = datagr.data;
      //print(datagr.data[33]);
      int uni = d[2];
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
      EspModel espModel = EspModel(uni, ipaddr, version, fsSet, ramSet);
//      print("datagr.length: ${datagr.data.length}");
//      print("d[26] ${d[26]}");
//      print("d[27] ${d[27]}");
//      print("d[28] ${d[28]}");
//      print("addr: ${d[27] + d[28] + 1}");
      providerModel.list.add(espModel);
      providerModel.notify();
//      print(version);
//      print(ipaddr);
//      print(uni);
    }
  }

  static void updateEspView(Datagram datagr) {
    if(datagr != null) {
      Uint8List d = datagr.data;
      int uni = d[2];
      providerModel.list.forEach((element) {
        if(element.uni == uni) {
          Color colorFs = Color.fromRGBO(d[18], d[19], d[20], 1);
          Color colorRam = Color.fromRGBO(d[21], d[22], d[23], 1);
          Settings fsSet = Settings(d[10], d[12], d[14], d[16], colorFs, d[24]);
          Settings ramSet = Settings(d[11], d[13], d[15], d[17], colorRam, d[25]);
          fsSet.universe = d[26];
          fsSet.address = d[27] == 0 ? d[28] : d[27] + d[28] + 1;
          ramSet.universe = d[26];
          ramSet.address = d[27] == 0 ? d[28] : d[27] + d[28] + 1;
          //print("d[29]: ${d[29]}");
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
          element.fsSet = fsSet;
          element.ramSet = ramSet;
        }
      });
      providerModel.notify();
     // print("red: ${d[21]}, green: ${d[22]}, blue: ${d[23]}");
//      print(ipaddr);
//      print(uni);
    }
  }

  static void setFaders(Settings set) {
    providerModelAttribute.dim = set.dimmer*1.0;
    providerModelAttribute.red = set.color.red*1.0;
    providerModelAttribute.green = set.color.green*1.0;
    providerModelAttribute.blue = set.color.blue*1.0;
    providerModelAttribute.speed = set.speed*1.0;
    providerModelAttribute.mode = set.mode;
    providerModelAttribute.automode = set.automode;
    providerModelAttribute.numEff = set.numEffect;
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
    });
    paletteProvider.notify();
    providerModel.notify();
    print("Controller.LoadPAletteFromFs: notified");
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
      set.copy(providerModel.getFirstChecked().ramSet);
      palette.settings.add(new PaletteEntry(21, set));
      palette.paletteType = PaletteType.PALETTE;
    }
    else {
      palette.settings.clear();
      providerModel.list.forEach((element) {
        Settings set = Settings.empty();
        set.copy(element.ramSet);
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
          element.ramSet.copy(palette.settings[0].settings);}
      });
    }
    else {
      if(palette.isNotEmpty() && providerModel.list.isNotEmpty) {
        palette.settings.forEach((el) {
          providerModel.list.firstWhere((element) => element.uni == el.uni).ramSet.copy(el.settings);
        });
      }
    }
    //providerModel.notify();
  }

  static clearPalette(Palette palette) async{
    palette.settings.clear();
    paletteProvider.notify();
    await savePalettesToFS();
  }
}