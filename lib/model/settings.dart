import 'dart:ui';
import 'dart:convert';

class Settings {
  int mode;
  int automode;
  int numEffect;
  int speed;
  Color color;
  int dimmer;
  int address;
  int universe;
  bool reverse;
  int pixelCount;
  int startPixel;
  int endPixel;
  int segment;

  Settings(this.mode, this.automode, this.numEffect, this.speed, this.color, this.dimmer);


  Settings.full(
      this.mode,
      this.automode,
      this.numEffect,
      this.speed,
      this.color,
      this.dimmer,
      this.address,
      this.universe,
      this.reverse,
      this.pixelCount,
      this.startPixel,
      this.endPixel,
      this.segment);

  Settings.empty();

  copy(Settings settings) {
    mode = settings.mode;
    automode = settings.automode;
    numEffect = settings.numEffect;
    speed = settings.speed;
    color = Color.fromRGBO(settings.color.red, settings.color.green, settings.color.blue, 1);
    dimmer = settings.dimmer;
    address = settings.address;
    universe = settings.universe;
    reverse = settings.reverse;
    pixelCount = settings.pixelCount;
    startPixel = settings.startPixel;
    endPixel = settings.endPixel;
    segment = settings.segment;
  }

  Settings.fromJson(Map<String, dynamic> json) :
      mode = json['mode'],
      automode = json['automode'],
      numEffect = json['numEffect'],
      speed = json['speed'],
      color = Color.fromRGBO(json['red'], json['green'], json['blue'], json['opacity']),
      dimmer = json['dimmer'],
      address = json['address'],
      universe = json['universe'],
      reverse = json['reverse'],
      pixelCount = json['pixelCount'],
      startPixel = json['startPixel'],
      endPixel = json['endPixel'],
      segment = json['segment'];

  Map<String, dynamic> toJson() => {
    'mode' : mode,
    'automode' : automode,
    'numEffect' : numEffect,
    'speed' : speed,
    'red' : color.red,
    'green' : color.green,
    'blue' : color.blue,
    'opacity' : color.opacity,
    'dimmer' : dimmer,
    'address' : address,
    'universe' : universe,
    'reverse' : reverse,
    'pixelCount' : pixelCount,
    'startPixel' : startPixel,
    'endPixel' : endPixel,
    'segment' : segment
  };
}