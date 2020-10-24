import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ledcontroller/model/palette_types.dart';
import 'package:ledcontroller/model/settings.dart';

class Palette {
  Map<int, Settings> settings =  Map<int, Settings>();
  PaletteType paletteType;

  Color getColor() {
    if(settings.isEmpty)
      return Colors.transparent;
    else{
      if(paletteType == PaletteType.PALETTE) {
        return settings[0].color;
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
}