import 'package:ledcontroller/model/settings.dart';

class EspModel {
  int uni;
  String ipAddress;
  String version;
  Settings fsSet;
  Settings ramSet;
  bool selected = false;
  bool recording = false;
  String filename;
  int filesize;

  EspModel(this.uni, this.ipAddress, this.version, this.fsSet, this.ramSet);

}