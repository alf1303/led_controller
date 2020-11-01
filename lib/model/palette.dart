import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ledcontroller/model/palette_entry.dart';
import 'package:ledcontroller/model/palette_types.dart';
import 'package:ledcontroller/model/settings.dart';
import 'dart:convert';

import 'package:ledcontroller/styles.dart';

class Palette {
  List<PaletteEntry> settings =  List();
  PaletteType paletteType;


  Palette() {
    paletteType = PaletteType.PALETTE;
  }

  Palette.withParams(PaletteType paletteType, Settings settings) {
    this.paletteType = paletteType;
    this.settings.add(new PaletteEntry(21, settings));
  }
      

  Color getColor() {
    if(settings.isEmpty)
      return emptyPaletteColor;
    else{
      if(paletteType == PaletteType.PALETTE) {
        return settings[0].settings.color;
      }
      else
        return null;
    }
  }

  bool isEmpty() {
    return settings.isEmpty;
  }

  bool isNotEmpty() {
    return settings.isNotEmpty;
  }

  Palette.fromJson(Map<String, dynamic> json){
    var tempSettings = jsonDecode(json['settings']) as List;
    settings = tempSettings.map((e) => PaletteEntry.fromJson(e)).toList();
    //settings = new List<PaletteEntry>.from(json['settings']);
    paletteType = PaletteType.values.firstWhere((element) => element.toString() == json['paletteType']);
  }

  Map<String, dynamic> toJson() => {
    'settings' : jsonEncode(settings),
    'paletteType' : paletteType.toString(),
  };

}