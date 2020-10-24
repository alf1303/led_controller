import 'package:flutter/material.dart';
import 'model/esp_model.dart';

class ProviderModel extends ChangeNotifier {
  static final _instance = ProviderModel._internal();
  factory ProviderModel() {
    return _instance;
  }
  ProviderModel._internal();
  List<EspModel> list = List();
  bool selected = false;
  void notify() {
    list.sort((a, b) => a.uni - b.uni);
    notifyListeners();
  }

  void checkSelected() {
    bool _flag = false;
    list.forEach((element) {
      if(element.selected) _flag = true;
    });
    selected = _flag;
    notifyListeners();
  }

  bool areSelectedEsp() {
    bool _flag = false;
    list.forEach((element) {
      if(element.selected) _flag = true;
    });
    return _flag;
  }

  int countSelected() {
    int count = 0;
    if(list.isNotEmpty) {
      count = list.where((element) => element.selected).toList().length;
    }
    return count;
  }

  EspModel getFirstChecked() {
    if(list.isNotEmpty)
      return list.firstWhere((element) => element.selected);
  }


}