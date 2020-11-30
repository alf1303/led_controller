import 'package:flutter/material.dart';

class ProviderModelAttribute extends ChangeNotifier{
  static final _instance = ProviderModelAttribute._internal();
  factory ProviderModelAttribute() {
    return _instance;
  }
  ProviderModelAttribute._internal();
  double dim = 1;
  double red = 0.0;
  double green = 0.0;
  double blue = 0.0;
  int mode = 2;
  int automode = 0;
  int fxNum = 0;
  Color fxColor = Colors.grey;
  double fxSpeed = 1.0;
  double fxParts = 1;
  double fxSpread = 1;
  double fxWidth = 1;
  double fxFade = 0;
  double fxSize = 100;
  bool fxReverse = false;
  bool fxAttack = false;
  bool fxSymm = false;
  bool fxRnd = false;
  bool fxRndColor = false;
  bool playlistMode = false;
  //int fxReverse = false;
  bool flag = false;

  notify() {
    flag = true;
    notifyListeners();
  }
}
