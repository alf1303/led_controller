import 'dart:ui';

class Settings {
  int mode;
  int automode;
  int numEffect; //fxNumber
  int speed; //fxSpeed
  Color color;
  int dimmer;
  int address;
  int universe;
  bool reverse;
  int pixelCount;
  int startPixel;
  int endPixel;
  int segment;
  int playlistSize;
  Color fxColor; //*
  int strobe;
  int fxSize;
  int fxParts;
  int fxFade;
  int fxReverse;



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
    playlistSize = settings.playlistSize;
    fxColor = settings.fxColor;
    strobe = settings.strobe;
    fxSize = settings.fxSize;
    fxParts = settings.fxParts;
    fxFade = settings.fxFade;
    fxReverse = settings.fxReverse;
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
      segment = json['segment'],
      playlistSize = json['playlistSize'],
      fxColor = Color.fromRGBO(json['fxRed'], json['fxGreen'], json['fxBlue'], json['fxOpacity']),
      strobe = json['strobe'],
      fxSize = json['fxSize'],
      fxParts = json['fxParts'],
      fxFade = json['fxFade'],
      fxReverse = json['fxReverse'];

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
    'segment' : segment,
    'playlistSize' : playlistSize,
    'fxRed' : fxColor.red,
    'fxGreen' : fxColor.green,
    'fxBlue' : fxColor.blue,
    'fxOpacity' : fxColor.opacity,
    'strobe' : strobe,
    'fxSize' : fxSize,
    'fxParts' : fxParts,
    'fxFade' : fxFade,
    'fxReverse' : fxReverse
  };
}