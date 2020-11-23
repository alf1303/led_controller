import 'package:flutter/cupertino.dart';

import 'model/palette.dart';
class PaletteProvider extends ChangeNotifier{
  final int PALETTES_COUNT = 15;
  static final _instance = PaletteProvider._internal();
  factory PaletteProvider() {
    return _instance;
  }
  PaletteProvider._internal();
  List<Palette> list = List();
  List<Palette> playlist = List();
  int playlistPeriod = 1;

  void notify() {
    notifyListeners();
  }

  void createEmptyPalettes() {
    list = List.generate(PALETTES_COUNT, (index) => new Palette());
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