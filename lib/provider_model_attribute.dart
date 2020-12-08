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

  processFxColor() {
      Controller.providerModel.list.forEach((element) {
        if(element.selected) {
          element.ramSet.fxColor = fxColor;
          element.ramSet.fxSize = fxSize.round();
        }
      });
  }

  processFxNum() {
    Controller.providerModel.list.forEach((element) {
      if(element.selected) {
        element.ramSet.numEffect = fxNum;
      }
    });
  }

  void processFxAttributes() {
    Controller.providerModel.list.forEach((element) {
      if(element.selected) {
        element.ramSet.speed = fxSpeed.round();
        element.ramSet.fxParts = fxParts.round();
        element.ramSet.fxSpread = fxSpread.round();
        element.ramSet.fxWidth = fxWidth.round();
        element.ramSet.fxFade = fxFade.round();
        element.ramSet.fxSize = fxSize.round();
        element.ramSet.setReverse(fxReverse);
        element.ramSet.setFxAttack(fxAttack);
        element.ramSet.setFxSymm(fxSymm);
        element.ramSet.setFxRnd(fxRnd);
        element.ramSet.setFxRndColor(fxRndColor);
        element.ramSet.setPlayListMode(playlistMode);
      }
    });
  }

  void processPlaylist() {
    Controller.providerModel.list.forEach((element) {
      if(element.selected) {
        element.ramSet.setPlayListMode(playlistMode);
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
