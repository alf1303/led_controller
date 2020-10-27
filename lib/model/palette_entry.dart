import 'package:ledcontroller/model/settings.dart';
import 'dart:convert';

class PaletteEntry {
  int uni;
  Settings settings;


  PaletteEntry(this.uni, this.settings);

  PaletteEntry.fromJson(Map<String, dynamic> json) :
      uni = json['uni'],
      settings = Settings.fromJson(jsonDecode(json['settings']));

  Map<String, dynamic> toJson() => {
    'uni' : uni,
    'settings' : jsonEncode(settings),
  };

}
