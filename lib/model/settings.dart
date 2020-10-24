import 'dart:ui';

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
}