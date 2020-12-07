import 'package:flutter/material.dart';

import 'controller.dart';

class ProviderModelAttribute extends ChangeNotifier{
  static final _instance = ProviderModelAttribute._internal();
  factory ProviderModelAttribute() {
    return _instance;
  }
  ProviderModelAttribute._internal();
  double dim = 255;
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
  double fxSize = 100;
  double fxFade = 0;
  bool fxReverse = false;
  bool fxAttack = false;
  bool fxSymm = false;
  bool fxRnd = false;
  bool fxRndColor = false;
  bool playlistMode = false;
  //int fxReverse = false;
  bool flag = false;

  processColors() {
    Controller.providerModel.list.forEach((element) {
      if(element.selected) {
        element.ramSet.color = Color.fromRGBO((red).round(), (green).round(), (blue).round(), 1);
        element.ramSet.dimmer = dim.round();
      }
    });
  }

  zeroColors() {
    dim = 255;
    red = 0;
    green = 0;
    blue = 0;
    processColors();
  }

  notify() {
    flag = true;
    notifyListeners();
  }
}
