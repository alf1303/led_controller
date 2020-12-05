import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:invert_colors/invert_colors.dart';
import 'package:ledcontroller/elements/custom/custom_group_radio.dart';
import 'package:ledcontroller/elements/palette_viewer.dart';
import 'package:ledcontroller/fx_names.dart';
import 'package:ledcontroller/provider_model_attribute.dart';
import 'package:ledcontroller/styles.dart';
import 'package:provider/provider.dart';

import '../controller.dart';
import 'custom/custom_radio.dart';
import 'custom/fitted_text.dart';
import 'my_bottom_bar.dart';

class MyValueSetter extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
     padding: EdgeInsets.symmetric(horizontal: 8),
     //color: Colors.black,
     decoration: secondaryDecoration,
     child: Column(
       children: <Widget>[
         MyBottomBar(true),
         Expanded(child: SingleChildScrollView(child: ValueSetterView())),
       ],
     ),
   );
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
  double _fxSpeed = 1;
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

  ////////////////
  double wwidth;
  double hheight;
  double ffontSize;

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

  onDimmerChangeEnd(double value) {
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(1);
    }
  }

  onRedChanged(double value) {
      _red = value;
  }
  onRedChangeEnd(double value) {
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(2);
    }
  }

  onGreenChanged(double value) {
      _green = value;
  }
  onGreenChangeEnd(double value) {
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(2);
    }
  }

  onBlueChanged(double value) {
      _blue = value;
  }
  onBlueChangeEnd(double value) {
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(2);
    }
  }

  onFxColorChanged(value) {
    //print("***FXColor changed");
    setState(() {
      _fxColor = value;
    });
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(129);
    }
  }

  onFxSpeedChangeEnd(value) {
    if(value > 99) _fxSpeed = 99;
      else _fxSpeed = value;
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
    if (value != 0) {
      showFxSettings(context);
    }
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

  void showFxSettings(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          double alertWidth;
          if(wwidth > hheight) {
            alertWidth = wwidth*0.6;
          }
          else {
            alertWidth = wwidth*0.95;
          }
          return Center(
            child: Card(
              shape: alertShape,
              color: thirdBackgroundColor.withOpacity(0.8),
              child: Container(
                width: alertWidth,
                decoration: BoxDecoration(
                ),
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    StatefulBuilder(builder: (context, setStat) {
                      //print("fxSpeed: $_fxSpeed");
                      //return MyCustomSliderNoCard("Speed", _fxSpeed, 0, 100, secondaryBackgroundColor, linesColor, linesColor, 5, (value) {setStat(() {_fxSpeed = value;}); }, onFxSpeedChangeEnd);
                      return FxSliderWidget("Speed", _fxSpeed, 100, onFxSpeedChangeEnd, true);
                    }),
                    FxSliderWidget("Width", _fxWidth, 30, onFxWidthChangeEnd, (_fxNum == FxNames.Cyclon.index || _fxNum == FxNames.Fade.index)),
                    FxSliderWidget("Parts", _fxParts, 100, onFxPartsChangeEnd, (_fxNum != FxNames.OFF.index && _fxNum != FxNames.Cyclon.index)),
                    StatefulBuilder(builder: (context, setStat) {
                      onAttack(value) {onFxAttackChange(value); setStat(() {});}
                      onSymm(value) {onFxSymmChange(value); setStat(() {});}
                      onReverse(value) {onFxReverseChange(value); setStat(() {});}
                      onRandom(value) {onFxRndChange(value); setStat(() {});}
                      onRandomCol(value) {onFxRndColorChange(value); setStat(() {});}
                      return Column(
                        children: <Widget>[
                          FxSliderWidget("Spread", _fxSpread, 100, onFxSpreadChangeEnd, (_fxNum == FxNames.Sinus.index || (_fxNum == FxNames.Fade.index && _fxRnd))),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              CustomRadio(label: "Attack", value: _fxAttack, onChanged: onAttack, color: radioColor, margin: 0, visible: (_fxNum == FxNames.Sinus.index), fontSize: ffontSize,),
                              CustomRadio(label: "Symm", value: _fxSymm, onChanged: onSymm, color: radioColor, margin: 0, visible: (_fxNum == FxNames.Sinus.index || _fxNum == FxNames.Fade.index), fontSize: ffontSize,),
                              CustomRadio(label: "Reverse", value: _fxReverse, onChanged: onReverse, color: radioColor, margin: 0, visible: (_fxNum != FxNames.OFF.index && _fxNum != FxNames.Cyclon.index), fontSize: ffontSize,),
                              CustomRadio(label: "Random", value: _fxRnd, onChanged: onRandom, color: radioColor, margin: 0, visible: (_fxNum == FxNames.Fade.index), fontSize: ffontSize,),
                            ],
                          ),
                          CustomRadio(label: "Random Color", value: _fxRndColor, onChanged: onRandomCol, color: radioColor, visible: (_fxNum == FxNames.Fade.index), fontSize: ffontSize,),
                        ],
                      );
                    })
                    //MyColorPicker(width*0.8)
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final double colPickerScale = 1.4;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double fontSize = height > width ? (width/25)/1.1 : (height/25)/1.1;
    final _attrModel = Provider.of<ProviderModelAttribute>(context, listen: true);

    wwidth = width;
    hheight = height;
    ffontSize = fontSize;

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

    return ExpandableTheme(
      data: ExpandableThemeData(
        headerAlignment: ExpandablePanelHeaderAlignment.bottom,
        iconSize: 30,
        iconPadding: EdgeInsets.all(0),
        iconPlacement: ExpandablePanelIconPlacement.left,
        iconRotationAngle: -1.5,
        //expandIcon: IconData(555)
      ),
      child: Column(
        children: <Widget>[
          //PALLETES VIEWER
          ExpandablePanel(
            header: Container(
                margin: EdgeInsets.only(bottom: 1),
                height: 60,
                decoration: BoxDecoration(
                    color: mainBackgroundColor,
                    border: Border.all(),
                    borderRadius: expandedHeaderRadius
                ),
                child: FText("Palettes:")),
            collapsed: Container(
              child: PaletteViewer(),
              // padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: mainBackgroundColor,
                border: Border.all(),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
              ),
              height: height > width ? height/4 : width/4,
              width: width,
            ),
          ),
          Container(height: 2 , color: mainBackgroundColor),
          SizedBox(height: 15,),

          /////////FX SETTER
          ExpandablePanel(
            header: Container(
                margin: EdgeInsets.only(bottom: 1),
                decoration: BoxDecoration(
                    color: mainBackgroundColor,
                    border: Border.all(),
                    borderRadius: expandedHeaderRadius
                ),
                child: SizedBox(
                  height:60 ,
                  child: CustomScrollView(
                    scrollDirection: Axis.horizontal,
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomRadio(label: _playlistMode ? "Stop Playlist" : "Start Playlist", value: _playlistMode, onChanged: onPlaylistModeChange, color: radioColor, fontSize: fontSize,),
                            FText("FX Setter"),
                            RaisedButton(
                                child: FittedBox(fit: BoxFit.scaleDown, child: Text("Playlist", style: smallText.copyWith(fontSize: fontSize),)),
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
                                                      child: Container(
                                                        color: mainBackgroundColor.withOpacity(0.8),
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
                      ),
                    ],
                  ),
                )),
            collapsed: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: mainBackgroundColor,
                border: Border.all(),
                borderRadius: expandedBodyRadius,
              ),
              child: Column(
                children: [
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          /////////////////////////////////////////////////    FX COLOR
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              child: Container(
                                height: height > width ? width/6 : height/6,
                                width: height > width ? width/6 : height/6,
                                decoration: BoxDecoration(
                                    boxShadow: [boxShadow1],
                                    color: _fxColor, border: Border.all(color: linesColor), borderRadius: BorderRadius.circular(12)),
                                child: InvertColors(child: FittedBox(fit: BoxFit.scaleDown, child: Text("  FX\ncolor", style: smallText.copyWith(fontSize: fontSize, color: _fxColor),))),
                              ),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return MyColorPicker(width*0.8, _fxColor, _fxSize, onFxColorChanged, onFxSizeChanged);
                                    });
                              },
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: GridView.count(crossAxisCount: 3,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              childAspectRatio: 1.5,
                              children: <Widget>[
                                CustomGroupRadio(label: "OFF", value: 0, groupValue: _fxNum, onChanged: onFxNumChanged, enabled: true, color: radioColor, fontSize: fontSize,),
                                CustomGroupRadio(label: "Sinus", value: 1, groupValue: _fxNum, onChanged: onFxNumChanged, enabled: true, color: radioColor, padding: 0, fontSize: fontSize,),
                                CustomGroupRadio(label: "Cyclon", value: 2, groupValue: _fxNum, onChanged: onFxNumChanged, enabled: true, color: radioColor, padding: 0, fontSize: fontSize),
                                CustomGroupRadio(label: "Fade", value: 3, groupValue: _fxNum, onChanged: onFxNumChanged, enabled: true, color: radioColor, fontSize: fontSize,),
                                CustomGroupRadio(label: "RGB", value: 4, groupValue: _fxNum, onChanged: onFxNumChanged, enabled: true, color: radioColor, fontSize: fontSize),
                              ],),
                          ),

                          //////////////////////////////////////////   FX SETTINGS
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                showFxSettings(context);
                              },
                              child: Container(
                                  height: height > width ? width/6 : height/6,
                                  width: height > width ? width/6 : height/6,
                                  decoration: BoxDecoration(
                                      boxShadow: [boxShadow1],
                                      color: Colors.grey, border: Border.all(color: linesColor), borderRadius: BorderRadius.circular(12)),
                                  child: FittedBox(fit: BoxFit.scaleDown, child: Text("    FX \nSettings", style: smallText.copyWith(fontSize: fontSize),))
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(height: 2, color: mainBackgroundColor),
          SizedBox(height: 15,),

          //COLOR SETTER
          ExpandablePanel(
            header: Container(
                margin: EdgeInsets.only(bottom: 1),
                height: 60,
                decoration: BoxDecoration(
                  color: mainBackgroundColor,
                  border: Border.all(),
                  borderRadius: expandedHeaderRadius,
                ),
                child: FText("Color Setter")),
            collapsed: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: mainBackgroundColor,
                border: Border.all(),
                borderRadius: expandedBodyRadius,
              ),
              child: StatefulBuilder(
                  builder: (context, setStat) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: Column(
                            children: <Widget>[
                              MyCustomSlider("", _dim, 0, 255, secondaryBackgroundColor, linesColor, Colors.black45, 5, (v) {setStat((){_dim = v;});}, onDimmerChangeEnd),
                              MyCustomSlider("", _red, 0, 255, secondaryBackgroundColor, linesColor, Colors.red, 5, (v) {setStat((){_red = v;});}, onRedChangeEnd),
                              MyCustomSlider("", _green, 0, 255, secondaryBackgroundColor, linesColor, Colors.green, 5, (v) {setStat((){_green = v;});}, onGreenChangeEnd),
                              MyCustomSlider("", _blue, 0, 255, secondaryBackgroundColor, linesColor, Colors.blue, 5, (v) {setStat((){_blue = v;});}, onBlueChangeEnd),
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
                                  color: buttonColor,
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
                    );
                  }
              ),
            ),
          ),
          Container(height: 50, color: thirdBackgroundColor),
        ],
      ),
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
    double tmpVal = value;
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Text(_label, style: smallText,),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(15)
          ),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
            ),
            child: StatefulBuilder(
              builder: (context, setStat) {
                return Slider(
                    min: min,
                    max: max,
                    activeColor: sliderColor,
                    inactiveColor: sliderColor.withOpacity(0.3),
                    value: tmpVal,
                    label: tmpVal.round().toString(),
                    divisions: max.round(),
                    onChanged: (value) {
                      setStat(() {tmpVal = value;});
                      _valueChanged(value);
                    },
                    onChangeEnd: onValChangeEnd
                );
              },
            )
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
   // print("$_label, $value");
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Text("$_label: ${value.round()}", style: smallText.copyWith(fontSize: 14),),
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
  final double max;
  final ValueChanged<double> onChanged;
  final bool visible;

  onParametrChanged(double value){
    onChanged(value);
  }
  const FxSliderWidget(
      this.label,
      this.fxParametr,
      this.max,
      this.onChanged,
      this.visible);

  @override
  _FxSliderWidgetState createState() => _FxSliderWidgetState();
}
class _FxSliderWidgetState extends State<FxSliderWidget> {

  @override
  Widget build(BuildContext context) {
    double _param = widget.fxParametr;
    print("${widget.label}, $_param");
    return  Visibility(
      visible: widget.visible,
      child: StatefulBuilder(
        builder: (context, setStat) {
          return Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: linesColor2,),
                  onPressed: () {
                    setStat(() {
                      _param <= 1 ? 1 : _param--;
                      widget.onParametrChanged(_param);
                    });
                  }),
              Expanded(child: MyCustomSliderNoCard(widget.label, _param, 1, widget.max, secondaryBackgroundColor, linesColor2, linesColor2, 5, (value) {setStat(() {_param = value;}); }, widget.onParametrChanged)),
              IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: linesColor2,),
                  onPressed: () {
                    setStat(() {
                      _param >= widget.max ? widget.max : _param++;
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

