import 'package:flutter/cupertino.dart';

import 'model/palette.dart';

class PaletteProvider extends ChangeNotifier{
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
    list = List.generate(15, (index) => new Palette());
  }
}