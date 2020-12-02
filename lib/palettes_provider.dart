import 'package:flutter/cupertino.dart';
import 'package:ledcontroller/model/palette_types.dart';

import 'model/palette.dart';
class PaletteProvider extends ChangeNotifier{
  final int PALETTES_COUNT = 28;
  static final _instance = PaletteProvider._internal();
  factory PaletteProvider() {
    return _instance;
  }
  PaletteProvider._internal();
  List<Palette> list = List();
  List<Palette> playlist = List();
  int playlistPeriod = 1;

  List<Palette> getPalettes() {
    if(list.isNotEmpty) {
      return list.where((element) => element.paletteType == PaletteType.PALETTE).toList();
    }
  }

  List<Palette> getProgramms() {
    if(list.isNotEmpty) {
      return list.where((element) => element.paletteType == PaletteType.PROGRAM).toList();
    }
  }

  void notify() {
    notifyListeners();
  }

  void createEmptyPalettes() {
    int numPal = 1;
    int numProg = 1;
    for(int i = 0; i < PALETTES_COUNT; i++) {
      Palette palette;
      if(i%2 == 0) {
        palette = Palette.palette();
        palette.name = "Palette$numPal";
        numPal++;
      }
      else {
        palette = Palette.program();
        palette.name = "Program$numProg";
        numProg++;
      }
      list.add(palette);
    }
  }

  void addToPlaylist(Palette palette) {
    playlist.add(palette);
    palette.playlistItem = true;
  }

  void removeFromPlaylist(Palette palette) {
    if(playlist.isNotEmpty) {
      playlist.remove(palette);
      palette.playlistItem = false;
    }
  }
}