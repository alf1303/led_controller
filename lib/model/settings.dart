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
  int fxParams;
  int fxSpread;
  int fxWidth;
  bool fxReverse;
  bool fxAttack;
  bool fxSymm;
  bool fxRnd;
  bool fxRndColor;

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
      this.segment,
      this.playlistSize,
      this.fxColor,
      this.strobe,
      this.fxSize,
      this.fxParts,
      this.fxFade,
      this.fxParams,
      this.fxSpread,
      this.fxWidth,
      this.fxReverse,
      this.fxAttack,
      this.fxSymm,
      this.fxRnd,
      this.fxRndColor
      );

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
    fxParams = settings.fxParams;
    fxSpread = settings.fxSpread;
    fxWidth = settings.fxWidth;
    fxReverse = settings.fxReverse;
    fxAttack = settings.fxAttack;
    fxSymm = settings.fxSymm;
    fxRnd = settings.fxRnd;
    fxRndColor = settings.fxRndColor;
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
      fxParams = json['fxParams'],
      fxSpread = json['fxSpread'],
      fxWidth = json['fxWidth'],
      fxReverse = json['fxReverse'] == 1 ? true : false,
      fxAttack = json['fxAttack'] == 1 ? true : false,
      fxSymm = json['fxSymm'] == 1 ? true : false,
      fxRnd = json['fxRnd'] == 1 ? true : false,
        fxRndColor = json['fxRndColor'] == 1 ? true : false;

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
    'fxParams' : fxParams,
    'fxSpread' : fxSpread,
    'fxWidth' : fxWidth,
    'fxReverse' : fxReverse,
    'fxAttack' : fxAttack,
    'fxSymm' : fxSymm,
    'fxRnd' : fxRnd,
    'fxRndColor' : fxRndColor,
  };

  setReverse(bool reverse) {
    this.fxReverse = reverse;
    if(reverse) {
      this.fxParams = this.fxParams | (1);
    }
    else {
      this.fxParams = this.fxParams & ~(1);
    }
  }

  setFxAttack(bool attack) {
    this.fxAttack = attack;
    if(attack) {
      this.fxParams = this.fxParams | (1<<1);
    }
    else {
      this.fxParams = this.fxParams & ~(1<<1);
    }
  }

  setFxSymm(bool symm) {
    this.fxSymm = symm;
    if(symm) {
      this.fxParams = this.fxParams | (1<<2);
    }
    else {
      this.fxParams = this.fxParams & ~(1<<2);
    }
  }

  setFxRnd(bool rnd) {
    this.fxRnd = rnd;
    if(rnd) {
      this.fxParams = this.fxParams | (1<<3);
    }
    else {
      this.fxParams = this.fxParams & ~(1<<3);
    }
  }

  setFxRndColor(bool rndColor) {
    this.fxRndColor = rndColor;
    if(rndColor) {
      this.fxParams = this.fxParams | (1<<7);
    }
    else {
      this.fxParams = this.fxParams & ~(1<<7);
    }
  }
}