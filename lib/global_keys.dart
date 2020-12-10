import 'package:flutter/material.dart';

final scanKey = GlobalKey();
final saveKey = GlobalKey();
final playbackKey = GlobalKey();
final palButKey = GlobalKey();
final fxButKey = GlobalKey();
final colButKey = GlobalKey();
final palettesKey = GlobalKey();
final programsKey = GlobalKey();
final fxColorKey = GlobalKey();
final fxNumKey = GlobalKey();
final playlistKey = GlobalKey();
final colorSetterKey = GlobalKey();
final fixtureViewKey = GlobalKey();
final resetKey = GlobalKey();
final areaKey = GlobalKey();
final settingsKey = GlobalKey();
final highliteKey = GlobalKey();
final selectKey = GlobalKey();
final deselectKey = GlobalKey();

final String scanText = "Scan. \nPress to search Esp8266 with correct firmware, available on your current connected WiFi network.";
final String saveText = "Save. \nPress to save current state of selected Esp8266 to memory, so after reset or power off/on Esp8266 boots with saved color and/or effect";
final String playbackText = "PlaybackMode. \nOpens new window, where it is possible to play recorded programs and adjust their brightness with grandmaster slider";
final String palButText = "PalettesView. \n Show/hide section with available palettes and programs";
final String fxButText = "EffectsView. \n Show/hide section with effect selection and settings";
final String colButText = "ColorView. \n Show/hide section with sliders for setting color of whole led strip";
final String palettesText = "Palettes. \n Select fixture(Esp8266) and tap palette to load it. Long press for showing menu. \n Palette is a storage for color and effect settings. Select one fixture, set desired look, save it to palette. Later it is possible to load this pallete to another fixture.\n"
    "   You can add palettes to playlist (Playlist + entry in menu) and save them into memory of fixture, so it can play them one after one";
final String programsText = "Programs. \n Program stores color and effect settings for all present fixtures. It is not necessary to select fixtures for saving or loading programm(unlike with palettes).";
final String fxColorText = "EffectColor. \n Press for selecting effect color and its brightness. This color will be used while playing effects and is added over main color";
final String fxNumText = "EffectNumber. \n Choose one of predefined effect generators. Window for changing effect settings will open after selecting.\n   Width - defines length of fading tail. Lower value - longer fading tail. \n"
    "   Parts - set number to split effect to. \n   Spread - in RND mode defines count of simultaneously lightened pixels. \n"
    " ";
final String playlistText = "PlaylistSettings. \n It is possible to set duration for playlist items, save them into memory and start/stop playing playlist items.";
final String colorSetterText = "ColorSetter. \n Section for setting color and brightness for entire led strip. ";
final String fixtureViewText = "Fixtures. \n In this area are shown fixtures, discovered on current connected WiFi network. Select them to set their settings.";
final String resetText = "ResetFixture. \n Sends command to reset selected fixture/fixtures.";
final String areaText = "AreaSetting. \n Cutting leds for setting desired amount of working pixels. ";
final String settingsText = "FixtureSettings\n Opens setting window, where it is possible to set real count of pixels for connected led strip. \n"
    "Also you can set names, to identify fixtures\n"
    "Network modes: \n"
    "  - Standalone. Esp8266 will create its own WiFi network with name MaxLedNetxx:xx and password 11223344. For controlling it, you should connect your phone/pad to this network. \n"
    "  - Client. Enter name and password for your existing WiFi network and Esp8266 will connect to it. If connection is impossible, Esp8266 will start in Standalone mode.";
final String highliteText = "HighliteMode. \n Highlites selected fixture for identifying.";
final String selectText = "SelectAll. \n Select all found fixtures";
final String deselectText = "DeselectAll. \n Deselect all found fixtures";

OverlayState OVERLAYSTATE;
List<OverlayEntry> entries = List();
final Map<GlobalKey, String> globalKeysMap = {
  scanKey : scanText,
  saveKey : saveText,
  playbackKey : playbackText,
  palButKey : palButText,
  fxButKey : fxButText,
  colButKey : colButText,
  palettesKey : palettesText,
  programsKey : programsText,
  fxColorKey : fxColorText,
  fxNumKey : fxNumText,
  playlistKey : playlistText,
  colorSetterKey : colorSetterText,
  fixtureViewKey : fixtureViewText,
  resetKey : resetText,
  areaKey : areaText,
  settingsKey : settingsText,
  highliteKey : highliteText,
  selectKey : selectText,
  deselectKey : deselectText
};