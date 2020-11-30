import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:invert_colors/invert_colors.dart';
import 'package:ledcontroller/elements/custom/custom_group_radio.dart';
import 'package:ledcontroller/elements/pallete_viewer.dart';
import 'package:ledcontroller/fx_names.dart';
import 'package:ledcontroller/model/esp_model.dart';
import 'package:ledcontroller/provider_model_attribute.dart';
import 'package:ledcontroller/styles.dart';
import 'package:ledcontroller/udp_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

import '../controller.dart';
import '../provider_model.dart';
import 'custom/custom_radio.dart';

class MyValueSetter extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final providerModel = Provider.of<ProviderModel>(context, listen: true);
    return Container(
     padding: EdgeInsets.symmetric(horizontal: 8),
     //color: valueSetterMainColor,
     decoration: secondaryDecoration,
     child: Column(
       children: <Widget>[
         ExpandablePanel(
           key: new Key("sad"),
                          //HEADER
           header: Container(
               child: Center(child: Text("Led Settings", style: headerTextSmall,))),
                        //VALUE SETTER
           expanded: ValueSetterView(),
         ),
       ],
     ),
   );
  }
}

class SettingsWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final providerModel = Provider.of<ProviderModel>(context, listen: true);
    return RaisedButton(
        child: Icon(Icons.settings),
        elevation: 10,
        onPressed: !Controller.providerModel.selected ? null : () {
          showDialog(
              context: context,
              builder: (context) {
                final _formKey = GlobalKey<FormState>();
                bool _nameChanged = false, _pixelChanged = false, _networkChanged = false;
                TextEditingController _nameController = TextEditingController();
                TextEditingController _pixelController = TextEditingController();
                TextEditingController _networkController = TextEditingController();
                TextEditingController _passwordController = TextEditingController();
                EspModel model = Controller.providerModel.getFirstChecked();
                _nameController.text = model.name;
                _pixelController.text = model.ramSet.pixelCount.toString();
                _networkController.text = model.ssid;
                _passwordController.text = model.password;
                bool netMode = providerModel.getFirstChecked().netMode == 1 ? true : false;
                bool _inputNetMode = netMode;
                String _inptName = _nameController.text;
                String _inputSsid = _networkController.text;
                String _inputPassword = _passwordController.text;
                String _inputPixel = _pixelController.text;
                return AlertDialog(
                  backgroundColor: thirdBackgroundColor.withOpacity(0.5),
                  title: Text("Settings", style: mainWhiteText,),
                  shape: alertShape,
                  content: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text("Name:", style: mainWhiteText,),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      color: Colors.white.withOpacity(0.5),
                                      child: TextFormField(
                                        onChanged: (value) {
                                          if(value != _inptName) {
                                            _nameChanged = true;
                                          }
                                        },
                                        decoration: inputDecoration,
                                        controller: _nameController,
                                        validator: (value) {
                                          if(value.length > 10 || value.contains(new RegExp(r'[а-я]'))) {
                                            return "1-10 symbols, not cyrilllic";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(height: 2, child: Container(color: Colors.white),),
                          ),
                          Column(
                            children: <Widget>[
                              Text("PixelCount:", style: mainWhiteText,),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      color: Colors.white.withOpacity(0.5),
                                      child: TextFormField(
                                        onChanged: (value) {
                                          if(value != _inputPixel) {
                                            _pixelChanged = true;
                                          }
                                        },
                                        decoration: inputDecoration,
                                        controller: _pixelController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if(value.isEmpty) return "Empty";
                                          else
                                          if(int.parse(value) > 500) return "< 1025";
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(height: 2, child: Container(color: Colors.white),),
                          ),
                          StatefulBuilder(
                              builder: (context, setState) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text("Network Settings:", style: mainWhiteText,),
                                    Row(
                                      children: <Widget>[
                                        Text("Standalone", style: mainWhiteText,),
                                        Switch(
                                            value: netMode,
                                            onChanged: (value) {
                                              setState(() {
                                                netMode = value;
                                                if(value != _inputNetMode) {
                                                  _networkChanged = true;
                                                }
                                              });
                                            }
                                        ),
                                        Text("Client", style: mainWhiteText,),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text("SSID:", style: mainWhiteText,),
                                        Expanded(
                                          child: Container(
                                            color: Colors.white.withOpacity(0.5),
                                            child: TextFormField(
                                              onChanged: (value) {
                                                if(value != _inputSsid) _networkChanged = true;
                                              },
                                              enabled: netMode,
                                              decoration: inputDecoration,
                                              controller: _networkController,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text("PASSWORD:", style: mainWhiteText,),
                                        Expanded(
                                          child: Container(
                                            color: Colors.white.withOpacity(0.5),
                                            child: TextFormField(
                                              onChanged: (value) {
                                                if(value != _inputPassword) _networkChanged = true;
                                              },
                                              enabled: netMode,
                                              decoration: inputDecoration,
                                              controller: _passwordController,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    RaisedButton(
                        child: Text("Send", style: mainText,),
                        onPressed: () async{
                          if(_formKey.currentState.validate()) {
                            if (_nameChanged) {
                              Controller.setName(_nameController.text);
                            }

                            if (_pixelChanged) {
                              await Controller.setPixelCount(int.parse(_pixelController.text));
                            }

                            if (_networkChanged) {
                              await Controller.setNetworkSettings(_networkController.text, _passwordController.text, netMode);
                              await Controller.setReset();
                            }
                            if (_networkChanged || _pixelChanged) {
                              //await Controller.setReset();
                              Future.delayed(Duration(seconds: 1));
                              await Controller.scan();
                            }
                            Navigator.of(context).pop();
                          }
                        }),
                    RaisedButton(
                        child: Text("Close", style: mainText,),
                        onPressed: () async{
                          Navigator.of(context).pop();
                        }),
                  ],
                );
              }
          );
        });
  }
}

class ValueSetterView extends StatefulWidget{
  @override
  _ValueSetterViewState createState() => _ValueSetterViewState();
}

class _ValueSetterViewState extends State<ValueSetterView> {
  double _dim = 0;
  double _red = 0;
  double _green = 0;
  double _blue = 0;
  double _fxSpeed = 0;
  double _fxParts = 1;
  double _fxSpread = 1;
  double _fxWidth = 1;
  double _fxSize = 100;
  double _fxFade = 0;
  bool _fxReverse = false;
  bool _fxAttack = false;
  bool _fxSymm = false;
  bool _fxRnd = false;
  bool _fxRndColor = false;
  bool _playlistMode = false;
  Color _fxColor = Colors.grey;
  int _fxNum = 0;
  double _temp = 0;

  void processAttributes() {
    Controller.providerModel.list.forEach((element) {
      if(element.selected) {
        element.ramSet.speed = _fxSpeed.round();
        element.ramSet.numEffect = _fxNum;
        element.ramSet.fxParts = _fxParts.round();
        element.ramSet.fxColor = _fxColor;
        element.ramSet.fxSpread = _fxSpread.round();
        element.ramSet.fxWidth = _fxWidth.round();
        element.ramSet.fxFade = _fxFade.round();
        element.ramSet.fxSize = _fxSize.round();
        element.ramSet.setReverse(_fxReverse);
        element.ramSet.setFxAttack(_fxAttack);
        element.ramSet.setFxSymm(_fxSymm);
        element.ramSet.setFxRnd(_fxRnd);
        element.ramSet.setFxRndColor(_fxRndColor);
        element.ramSet.color = Color.fromRGBO((_red).round(), (_green).round(), (_blue).round(), 1);
        element.ramSet.dimmer = _dim.round();
        element.ramSet.setPlayListMode(_playlistMode);
      }
    });
  }

  void onSavePressed() {
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(255);
    }
  }

  onDimmerChanged(double value) {
    setState(() {
      _dim = value;
    });
  }
  onDimmerChangeEnd(double value) {
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(1);
    }
  }

  onRedChanged(double value) {
    setState(() {
      _red = value;
    });
  }
  onRedChangeEnd(double value) {
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(2);
    }
  }

  onGreenChanged(double value) {
    setState(() {
      _green = value;
    });
  }
  onGreenChangeEnd(double value) {
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(2);
    }
  }

  onBlueChanged(double value) {
    setState(() {
      _blue = value;
    });
  }
  onBlueChangeEnd(double value) {
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(2);
    }
  }

  onFxColorChanged(value) {
    print("***FXColor changed");
    setState(() {
      _fxColor = value;
    });
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(129);
    }
  }

  onFxSpeedChangeEnd(value) {
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(130);
    }
  }

  onFxPartsChangeEnd(value) {
    _fxParts = value;
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(130);
    }
  }

  onFxNumChanged(value) {
    setState(() {
      _fxNum = value;
    });
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(130);
    }
  }

  onFxSpreadChangeEnd(value) {
    _fxSpread = value;
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(130);
    }
  }

  onFxSizeChanged(value) {
    _fxSize = value;
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(130);
    }
  }

  onFxWidthChangeEnd(value) {
    _fxWidth = value;
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(130);
    }
  }

  onFxAttackChange(value) {
    setState(() {
      _fxAttack = value;
    });
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(130);
    }
  }

  onFxReverseChange(value) {
    setState(() {
      _fxReverse = value;
    });
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(130);
    }
  }

  onFxSymmChange(value) {
    setState(() {
      _fxSymm = value;
    });
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(130);
    }
  }

  onFxRndChange(value) {
    setState(() {
      _fxRnd = value;
    });
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(130);
    }
  }

  onFxRndColorChange(value) {
    setState(() {
      _fxRndColor = value;
    });
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(130);
    }
  }

  onPlaylistModeChange(value) {
    setState(() {
      _playlistMode = value;
    });
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(131);
    }
  }

  void _zeroVals() {
    _dim = 255;
    _red = 0;
    _green = 0;
    _blue = 0;
    processAttributes();
    Controller.setSend(2);
    setState(() {  });
  }

  @override
  Widget build(BuildContext context) {
    final double colPickerScale = 1.4;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double fontSize = height > width ? (width/25)/1.6 : (height/25)/1.6;
    final _attrModel = Provider.of<ProviderModelAttribute>(context, listen: true);
    if(_attrModel.flag) {
      _dim = _attrModel.dim;
      _red = _attrModel.red;
      _green = _attrModel.green;
      _blue = _attrModel.blue;
      _fxNum = _attrModel.fxNum;
      _fxSpeed = _attrModel.fxSpeed;
      _fxParts = _attrModel.fxParts;
      _fxSpread = _attrModel.fxSpread;
      _fxWidth = _attrModel.fxWidth;
      _fxColor = _attrModel.fxColor;
      _fxSize = _attrModel.fxSize;
      _fxReverse = _attrModel.fxReverse;
      _fxAttack = _attrModel.fxAttack;
      _fxSymm = _attrModel.fxSymm;
      _fxRnd = _attrModel.fxRnd;
      _fxRndColor = _attrModel.fxRndColor;
      Controller.resetAttributeProviderFlag();
    }
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              flex: 6,
              child: Column(
                children: <Widget>[
                  MyCustomSlider("", _dim, 0, 255, secondaryBackgroundColor, linesColor, linesColor, 5, onDimmerChanged, onDimmerChangeEnd),
                  MyCustomSlider("", _red, 0, 255, secondaryBackgroundColor, linesColor, Colors.red, 5, onRedChanged, onRedChangeEnd),
                  MyCustomSlider("", _green, 0, 255, secondaryBackgroundColor, linesColor, Colors.green, 5, onGreenChanged, onGreenChangeEnd),
                  MyCustomSlider("", _blue, 0, 255, secondaryBackgroundColor, linesColor, Colors.blue, 5, onBlueChanged, onBlueChangeEnd),
                ],
              ),
            ),
                                  //COLOR VIEWER
            Expanded(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8.0),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(_red.round(), _green.round(), _blue.round(), 1),
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: [
                            boxShadow1
                          ]
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Icon(Icons.clear, size: 24,),
                    shape: roundedButtonShape,
                    onPressed: _zeroVals
                  ),
                  RaisedButton(
                      child: Icon(Icons.save, size: 24,),
                      shape: roundedButtonShape,
                      onPressed: onSavePressed
                  )
                ],
              ),
            )
          ],
        ),
                                  //PALLETES VIEWER
        Text("Palettes:", style: headerTextSmall,),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 5, right: 5),
          child: Container(
            child: PaletteViewer(),
            decoration: BoxDecoration(
              border: Border.all(color: mainBackgroundColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(3)),
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: mainBackgroundColor.withOpacity(0.3),
                  spreadRadius: -3,
                  blurRadius: 5,
                  //offset: Offset(1, 2)
                )
              ]
            ),
            height: height > width ? height/11 : width/11,
            width: width,
          ),
        ),
        Container(height: 2, color: Colors.white),

                      /////////FX SETTER
        Center(child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CustomRadio(label: _playlistMode ? "Stop Playlist" : "Start Playlist", value: _playlistMode, onChanged: onPlaylistModeChange, color: mainBackgroundColor, fontSize: fontSize,),
              Text("FX Settings", style: headerTextSmall,),
              RaisedButton(
                  child: Text("Playlist", style: smallText.copyWith(fontSize: fontSize),),
                  shape: roundedButtonShape,
                  onPressed: () {
                    showDialog(context: context,
                    builder: (context) {
                      final _formKey = GlobalKey<FormState>();
                      TextEditingController _periodController = TextEditingController();
                      _periodController.text = Controller.paletteProvider.playlistPeriod.toString();
                      return AlertDialog(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        shape: alertShape,
                        backgroundColor: thirdBackgroundColor.withOpacity(0.8),
                        content: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text("Playlist items: ${Controller.paletteProvider.playlist.length}"),
                              Row(
                                children: <Widget>[
                                  Text("Period (seconds):"),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: inputDecoration,
                                      controller: _periodController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if(value.isEmpty || int.parse(value) < 1 || int.parse(value) > 3600) return "1-3600 seconds";
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          RaisedButton(
                            shape: roundedButtonShape,
                              child: Text("Save"),
                              onPressed: () {
                                if(_formKey.currentState.validate()) {
                                  Controller.paletteProvider.playlistPeriod = int.parse(_periodController.text);
                                  Controller.sendPlaylist();
                                  Navigator.of(context).pop();
                                }
                              })
                        ],
                      );
                    }
                    );
                  }
              ),
            ],
          ),
        )),
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                /////////////////////////////////////////////////    FX COLOR
                Column(
                  children: <Widget>[
                    GestureDetector(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            height: height > width ? width/6 : height/6,
                            width: height > width ? width/6 : height/6,
                            decoration: BoxDecoration(
                              boxShadow: [boxShadow1],
                                color: _fxColor, border: Border.all(color: linesColor), borderRadius: BorderRadius.circular(12)),
                          ),
                          
                          InvertColors(child: Text("   FX\ncolor", style: smallText.copyWith(fontSize: fontSize, color: _fxColor),))
                        ],
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return MyColorPicker(width*0.8, _fxColor, _fxSize, onFxColorChanged, onFxSizeChanged);
                            });
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: GridView.count(crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  childAspectRatio: 1.5,
                  children: <Widget>[
                    CustomGroupRadio(label: "OFF", value: 0, groupValue: _fxNum, onChanged: onFxNumChanged, enabled: true, color: mainBackgroundColor, fontSize: fontSize,),
                    CustomGroupRadio(label: "Sinus", value: 1, groupValue: _fxNum, onChanged: onFxNumChanged, enabled: true, color: mainBackgroundColor, padding: 0, fontSize: fontSize,),
                    CustomGroupRadio(label: "Cyclon", value: 2, groupValue: _fxNum, onChanged: onFxNumChanged, enabled: true, color: mainBackgroundColor, padding: 0, fontSize: fontSize),
                    CustomGroupRadio(label: "Fade", value: 3, groupValue: _fxNum, onChanged: onFxNumChanged, enabled: true, color: mainBackgroundColor, fontSize: fontSize,),
                    CustomGroupRadio(label: "RGB", value: 4, groupValue: _fxNum, onChanged: onFxNumChanged, enabled: true, color: mainBackgroundColor, fontSize: fontSize),
                  ],),
                ),

                //////////////////////////////////////////   FX SETTINGS
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                    builder: (context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                            shape: alertShape,
                            backgroundColor: thirdBackgroundColor.withOpacity(0.8),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                StatefulBuilder(builder: (context, setStat) {
                                  return MyCustomSliderNoCard("Speed", _fxSpeed, 0, 100, secondaryBackgroundColor, linesColor, linesColor, 5, (value) {setStat(() {_fxSpeed = value;}); }, onFxSpeedChangeEnd);
                                }),
                                FxSliderWidget("Width", _fxWidth, onFxWidthChangeEnd, (_fxNum == FxNames.Cyclon.index || _fxNum == FxNames.Fade.index)),
                                FxSliderWidget("Parts", _fxParts, onFxPartsChangeEnd, (_fxNum != FxNames.OFF.index && _fxNum != FxNames.Cyclon.index)),
                                FxSliderWidget("Spread", _fxSpread, onFxSpreadChangeEnd, (_fxNum == FxNames.Sinus.index)),
                                StatefulBuilder(builder: (context, setStat) {
                                  onAttack(value) {onFxAttackChange(value); setStat(() {});}
                                  onSymm(value) {onFxSymmChange(value); setStat(() {});}
                                  onReverse(value) {onFxReverseChange(value); setStat(() {});}
                                  onRandom(value) {onFxRndChange(value); setStat(() {});}
                                  onRandomCol(value) {onFxRndColorChange(value); setStat(() {});}
                                  return Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          CustomRadio(label: "Attack", value: _fxAttack, onChanged: onAttack, color: mainBackgroundColor, margin: 0, visible: (_fxNum == FxNames.Sinus.index), fontSize: fontSize,),
                                          CustomRadio(label: "Symm", value: _fxSymm, onChanged: onSymm, color: mainBackgroundColor,margin: 0, visible: (_fxNum == FxNames.Sinus.index || _fxNum == FxNames.Fade.index), fontSize: fontSize,),
                                          CustomRadio(label: "Reverse", value: _fxReverse, onChanged: onReverse, color: mainBackgroundColor, margin: 0, visible: (_fxNum != FxNames.OFF.index && _fxNum != FxNames.Cyclon.index), fontSize: fontSize,),
                                          CustomRadio(label: "Random", value: _fxRnd, onChanged: onRandom, color: mainBackgroundColor, margin: 0, visible: (_fxNum == FxNames.Fade.index), fontSize: fontSize,),
                                        ],
                                      ),
                                      CustomRadio(label: "Random Color", value: _fxRndColor, onChanged: onRandomCol, color: mainBackgroundColor, visible: (_fxNum == FxNames.Fade.index), fontSize: fontSize,),
                                    ],
                                  );
                                })
                                //MyColorPicker(width*0.8)
                              ],
                            ),
                          );
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        height: height > width ? width/6 : height/6,
                        width: height > width ? width/6 : height/6,
                        decoration: BoxDecoration(
                            boxShadow: [boxShadow1],
                            color: Colors.grey, border: Border.all(color: linesColor), borderRadius: BorderRadius.circular(12)),
                      ),
                      Text("    FX \nSettings", style: smallText.copyWith(fontSize: fontSize),),

                    ],
                  ),
                )
              ],
            ),
          ],
        ),
        SizedBox(height: 8,)
      ],
    );
  }
}

class MyColorPicker extends StatefulWidget{
  final double width;
  final Color color;
  final double fxSize;
  final ValueChanged<Color> changedColor;
  final ValueChanged<double> changedFxSize;

  MyColorPicker(this.width, this.color, this.fxSize, this.changedColor, this.changedFxSize);
  @override
  _MyColorPickerState createState() => _MyColorPickerState();
}
class _MyColorPickerState extends State<MyColorPicker> {
  final List<Color> _colors = [
    Color.fromARGB(255, 0, 0, 0),
    Color.fromARGB(255, 255, 0, 0),
    Color.fromARGB(255, 255, 128, 0),
    Color.fromARGB(255, 255, 255, 0),
    Color.fromARGB(255, 128, 255, 0),
    Color.fromARGB(255, 0, 255, 0),
    Color.fromARGB(255, 0, 255, 128),
    Color.fromARGB(255, 0, 255, 255),
    Color.fromARGB(255, 0, 128, 255),
    Color.fromARGB(255, 0, 0, 255),
    Color.fromARGB(255, 128, 0, 255),
    Color.fromARGB(255, 255, 0, 255),
    Color.fromARGB(255, 255, 0, 128),
    Color.fromARGB(255, 255, 255, 255),
  ];

  @override
  void initState() {
    super.initState();
    _currentColor = widget.color;
    _currentFxSize = widget.fxSize;
    _colorSliderPosition = _calculatePositionFromColor(_currentColor);
  }

  double _colorSliderPosition = 0;
  Color _currentColor;
  double _currentFxSize;

  _colorChangeHandler(double position) {
    if(position > widget.width) {
      position = widget.width;
    }
    if(position < 0) {
      position = 0;
    }
    setState(() {
      _colorSliderPosition = position;
      _currentColor = _calculateSelectedColor(position);
    });
  }

  _colorChangeSend() {
    widget.changedColor(_currentColor);
  }

  _onFxSizeChangeEnd(value) {
    setState(() {
      _currentFxSize = value;
    });
    widget.changedFxSize(_currentFxSize);
  }

  double _calculatePositionFromColor(Color col) {
    double dist = widget.width/(_colors.length-1);
    if(col.red == 255 && col.green == 255 && col.blue == 255) return widget.width;
    if(col.red == 0 && col.green == 0 && col.blue == 0) return 0;
    List<int> diff = List.filled(3, 255);
    Color closest;
    _colors.forEach((e) {
      if((col.red - e.red).abs() <= diff[0] && (col.green - e.green).abs() <= diff[1] && (col.blue - e.blue).abs() <= diff[2]) {
        diff[0] = (col.red - e.red).abs();
        diff[1] = (col.green - e.green).abs();
        diff[2] = (col.blue - e.blue).abs();
        closest = e;
      }
    });
    return _colors.indexOf(closest)*dist;
  }

  Color _calculateSelectedColor(double position) {
    double positionInArray = (position/widget.width * (_colors.length - 1));
    int index = positionInArray.truncate();
    double reminder = positionInArray - index;
    if(reminder == 0) {
      _currentColor = _colors[index];
    }
    else {
      int redValue = _colors[index].red == _colors[index+1].red ? _colors[index].red :
        (_colors[index].red + (_colors[index+1].red - _colors[index].red)*reminder).round();
      int greenValue = _colors[index].green == _colors[index+1].green ? _colors[index].green :
        (_colors[index].green + (_colors[index+1].green - _colors[index].green)*reminder).round();
      int blueValue = _colors[index].blue == _colors[index+1].blue ? _colors[index].blue :
        (_colors[index].blue + (_colors[index+1].blue - _colors[index].blue)*reminder).round();
      _currentColor = Color.fromARGB(255, redValue, greenValue, blueValue);
    }
    return _currentColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 100,
          height: 50,
          decoration: BoxDecoration(
              color: _currentColor.withOpacity(_currentFxSize/100),
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(20),
              //shape: BoxShape.circle
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (details) {
            //print("DRAG start");
            _colorChangeHandler(details.localPosition.dx);
          },
          onHorizontalDragEnd: (details) {
            _colorChangeSend();
          },
          onHorizontalDragUpdate: (details) {
            //print("DRAG update");
            _colorChangeHandler(details.localPosition.dx);
          },
          onTapDown: (details) {
            _colorChangeHandler(details.localPosition.dx);
            _colorChangeSend();
          },
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              width: widget.width,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[800], width: 2),
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(colors: _colors)
              ),
              child:
                  CustomPaint(
                    painter: _SliderIndicatorPainter(_colorSliderPosition),
                  ),
            ),
          ),
        ),
        StatefulBuilder(
            builder: (context, setStat) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Material(
                  textStyle: TextStyle(color: Colors.black),
                  color: Colors.transparent,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        accentTextTheme: TextTheme(bodyText2: TextStyle(color: mainBackgroundColor))
                    ),
                    child: Slider(
                      activeColor: linesColor,
                        inactiveColor: mainBackgroundColor,
                        value: _currentFxSize,
                        label: _currentFxSize.round().toString(),
                        divisions: 100,
                        min: 0,
                        max: 100,
                        onChanged: (value) {
                          setStat(() {
                            _currentFxSize = value;
                          });
                        },
                      onChangeEnd: (value) {
                          _onFxSizeChangeEnd(value);
                      },
                        ),
                  ),
                ),
              );
            }
        )
      ],
    );
  }
}

class _SliderIndicatorPainter extends CustomPainter {
final double position;

_SliderIndicatorPainter(this.position);

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()..color = Colors.black.withOpacity(0.6)..style = PaintingStyle.stroke..strokeWidth = 10;
    canvas.drawCircle(Offset(position, size.height/2), 12, circlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class MyCustomSlider extends StatelessWidget {
  final String _label;
  final double value;
  final double min;
  final double max;
  final Color shadowColor;
  final Color borderColor;
  final Color sliderColor;
  final double borderRadius;
  final ValueChanged<double> _valueChanged;
  final ValueChanged<double> _valueChangeEnd;
  onValChanged(valuee) {
    _valueChanged(valuee);
  }
  onValChangeEnd(valuee) {
    _valueChangeEnd(valuee);
  }

  const MyCustomSlider(this._label, this.value, this.min, this.max, this.shadowColor, this.borderColor, this.sliderColor,
      this.borderRadius, this._valueChanged, this._valueChangeEnd);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Text(_label, style: smallText,),
        Card(
          color: Colors.transparent,
          shadowColor: secondaryBackgroundColor,
          shape: RoundedRectangleBorder(side: BorderSide(color: borderColor) ,borderRadius: BorderRadius.circular(borderRadius)),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
            ),
            child: Slider(
                min: min,
                max: max,
                activeColor: sliderColor,
                inactiveColor: sliderColor.withOpacity(0.3),
                value: value,
                label: value.round().toString(),
                divisions: max.round(),
                onChanged: onValChanged,
                onChangeEnd: onValChangeEnd
            ),
          ),
        ),
      ],
    );
  }
}
class MyCustomSliderNoCard extends StatelessWidget {
  final String _label;
  final double value;
  final double min;
  final double max;
  final Color shadowColor;
  final Color borderColor;
  final Color sliderColor;
  final double borderRadius;
  final ValueChanged<double> _valueChanged;
  final ValueChanged<double> _valueChangeEnd;
  onValChanged(valuee) {
    _valueChanged(valuee);
  }
  onValChangeEnd(valuee) {
    _valueChangeEnd(valuee);
  }

  const MyCustomSliderNoCard(this._label, this.value, this.min, this.max, this.shadowColor, this.borderColor, this.sliderColor,
      this.borderRadius, this._valueChanged, this._valueChangeEnd);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Text("$_label: ${value.round()}", style: smallText,),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
          ),
          child: Slider(
              min: min,
              max: max,
              activeColor: sliderColor,
              inactiveColor: sliderColor.withOpacity(0.3),
              value: value,
              label: value.round().toString(),
              divisions: max.round(),
              onChanged: onValChanged,
              onChangeEnd: onValChangeEnd
          ),
        ),
      ],
    );
  }
}

class FxSliderWidget extends StatefulWidget{
  final String label;
  final double fxParametr;
  final ValueChanged<double> onChanged;
  final bool visible;

  onParametrChanged(double value){
    onChanged(value);
  }
  const FxSliderWidget(
      this.label,
      this.fxParametr,
      this.onChanged,
      this.visible);

  @override
  _FxSliderWidgetState createState() => _FxSliderWidgetState();
}
class _FxSliderWidgetState extends State<FxSliderWidget> {

  @override
  Widget build(BuildContext context) {
    double _param = widget.fxParametr;
    return  Visibility(
      visible: widget.visible,
      child: StatefulBuilder(
        builder: (context, setStat) {
          return Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: mainBackgroundColor,),
                  onPressed: () {
                    setStat(() {
                      _param <= 1 ? 1 : _param--;
                      widget.onParametrChanged(_param);
                    });
                  }),
              Expanded(child: MyCustomSliderNoCard(widget.label, _param, 1, 100, secondaryBackgroundColor, linesColor, mainBackgroundColor, 5, (value) {setStat(() {_param = value;}); }, widget.onParametrChanged)),
              IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: mainBackgroundColor,),
                  onPressed: () {
                    setStat(() {
                      _param >= 100 ? 100 : _param++;
                      widget.onParametrChanged(_param);
                    });
                  }),
            ],
          );
        },
      ),
    );
  }
}

