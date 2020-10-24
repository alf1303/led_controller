import 'package:ledcontroller/model/settings.dart';

class EspModel {
  int uni;
  String ipAddr;
  String version;
  Settings fs_set;
  Settings ram_set;
  bool selected = false;
  bool recording = false;
  String filename;
  int filesize;

  EspModel(this.uni, this.ipAddr, this.version, this.fs_set, this.ram_set);

}