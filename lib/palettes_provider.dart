import 'package:flutter/cupertino.dart';
import 'package:ledcontroller/model/palette_types.dart';

import 'model/palette.dart';
class PaletteProvider extends ChangeNotifier{
  final int PALETTES_COUNT = 15;
  static final _instance = PaletteProvider._internal();
  factory PaletteProvider() {
    return _instance;
  }
  PaletteProvider._internal();
  List<Palette> list = List();

  void notify() {
    notifyListeners();
  }

  void createEmptyPalettes() {
    list = List.generate(PALETTES_COUNT, (index) => new Palette());
  }
}