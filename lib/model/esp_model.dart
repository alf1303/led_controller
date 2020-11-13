import 'package:ledcontroller/model/settings.dart';

class EspModel {
  int uni;
  String ipAddress;
  String name;
  String ssid;
  String password;
  int netMode;
  String version;
  Settings fsSet;
  Settings ramSet;
  bool selected = false;
  bool recording = false;
  bool isAlive = true;
  String filename;
  int filesize;

  EspModel(this.uni, this.ipAddress, this.version, this.fsSet, this.ramSet);

  void copyFrom(EspModel model) {
    this.uni = model.uni;
    this.ipAddress = model.ipAddress;
    this.version = model.version;
    this.name = model.name;
    this.netMode = model.netMode;
    this.ssid = model.ssid;
    this.password = model.password;
    this.fsSet.copy(model.fsSet);
    this.ramSet.copy(model.ramSet);
    //this.selected = model.selected;
    this.recording = model.recording;
    //this.filename = model.filename;
    //this.filesize = model.filesize;
  }
}