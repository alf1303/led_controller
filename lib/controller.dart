import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ledcontroller/model/settings.dart';
import 'package:ledcontroller/palettes_provider.dart';
import 'package:ledcontroller/provider_model_attribute.dart';
import 'package:ledcontroller/udp_controller.dart';
import 'package:ledcontroller/provider_model.dart';
//import 'package:flutter/src/material/slider_theme.dart';
import 'model/esp_model.dart';
import 'model/palette.dart';

abstract class Controller {
  static Random random = new Random();
  static final providerModel = ProviderModel();
  static final providerModelAttribute = ProviderModelAttribute();
  static final paletteProvider = PaletteProvider();
  static bool highlite = false;

  static init() {
    for (int i = 21; i <= 40; i++) {
      Settings fs_set = Settings(random.nextInt(4), random.nextInt(3), i, i+100, Color.fromRGBO(random.nextInt(255), random.nextInt(255), 0, 1), random.nextInt(255));
      Settings ram_set = Settings(random.nextInt(4), random.nextInt(3), i, i+100, Color.fromRGBO(random.nextInt(255), random.nextInt(255), 0, 1), random.nextInt(255));
      EspModel esp = new EspModel(i, "192.168.0.$i", "v_0.5.9", fs_set, ram_set);
      providerModel.list.add(esp);
    }
    providerModel.notify();
  }

  static initWiFi() {
    UDPCotroller.setLocalIp();
  }

  static Future<bool> scan() async{
    providerModel.list.clear();
    await UDPCotroller.scanRequest();
    await Future.delayed(Duration(seconds: 1), () {return false;});
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
  }

  static void setArea(int pixelCount, RangeValues curRange) async{
    providerModel.list.forEach((element) {
      if(element.selected) {
        element.ram_set.pixelCount = pixelCount;
        element.ram_set.startPixel = curRange.start.round();
        element.ram_set.endPixel = curRange.end.round();
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
      Color color_fs = Color.fromRGBO(d[18], d[19], d[20], 1);
      Color color_ram = Color.fromRGBO(d[21], d[22], d[23], 1);
      Settings fs_set = Settings(d[10], d[12], d[14], d[16], color_fs, d[24]);
      Settings ram_set = Settings(d[11], d[13], d[15], d[17], color_ram, d[25]);
      fs_set.universe = d[26];
      fs_set.address = d[27] == 0 ? d[28] : d[27] + d[28] + 1;
      ram_set.universe = d[26];
      ram_set.address = d[27] == 0 ? d[28] : d[27] + d[28] + 1;
      d[29] == 1 ? fs_set.reverse = true : fs_set.reverse = false;
      d[29] == 1 ? ram_set.reverse = true : ram_set.reverse = false;
      fs_set.pixelCount = d[30];
      fs_set.startPixel = d[31];
      fs_set.endPixel = d[32];
      fs_set.segment = d[33];
      ram_set.pixelCount = d[30];
      ram_set.startPixel = d[31];
      ram_set.endPixel = d[32];
      ram_set.segment = d[33];
      EspModel espModel = EspModel(uni, ipaddr, version, fs_set, ram_set);
      String ad = String.fromCharCodes(datagr.data, 27);
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
          Color color_fs = Color.fromRGBO(d[18], d[19], d[20], 1);
          Color color_ram = Color.fromRGBO(d[21], d[22], d[23], 1);
          Settings fs_set = Settings(d[10], d[12], d[14], d[16], color_fs, d[24]);
          Settings ram_set = Settings(d[11], d[13], d[15], d[17], color_ram, d[25]);
          fs_set.universe = d[26];
          fs_set.address = d[27] == 0 ? d[28] : d[27] + d[28] + 1;
          ram_set.universe = d[26];
          ram_set.address = d[27] == 0 ? d[28] : d[27] + d[28] + 1;
          //print("d[29]: ${d[29]}");
          d[29] == 1 ? fs_set.reverse = true : fs_set.reverse = false;
          d[29] == 1 ? ram_set.reverse = true : ram_set.reverse = false;
          fs_set.pixelCount = d[30];
          fs_set.startPixel = d[31];
          fs_set.endPixel = d[32];
          fs_set.segment = d[33];
          ram_set.pixelCount = d[30];
          ram_set.startPixel = d[31];
          ram_set.endPixel = d[32];
          ram_set.segment = d[33];
          element.fs_set = fs_set;
          element.ram_set = ram_set;
        }
      });
      providerModel.notify();
//      print(version);
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

  static initPalettes() async{
    paletteProvider.createEmptyPalettes();
  }

  static loadPalettesFromFS() async{

  }

  static savePalettesToFS() async{

  }

  static savePalette(Palette palette) {

  }

  static loadPalette(Palette palette) {

  }
}