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
  double speed = 0.0;
  int mode = 2;
  int automode = 0;
  int numEff = 0;
  bool flag = false;

  notify() {
    flag = true;
    notifyListeners();
  }
}
