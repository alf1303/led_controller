import 'package:flutter/material.dart';
import 'package:ledcontroller/elements/custom/custom_group_radio.dart';
import 'package:ledcontroller/elements/custom/custom_radio.dart';
import 'package:ledcontroller/elements/custom/sliders.dart';
import 'package:ledcontroller/global_keys.dart';
import 'package:ledcontroller/provider_model_attribute.dart';

import '../../controller.dart';
import '../../fx_names.dart';
import '../../styles.dart';

class FxNumWidget extends StatefulWidget{

  @override
  _FxNumWidgetState createState() => _FxNumWidgetState();
}

class _FxNumWidgetState extends State<FxNumWidget> {
  final attr = ProviderModelAttribute();
  double wwidth;
  double hheight;
  double ffontSize;

  onFxNumChanged(value) {
    if (value != 0) {
      showFxSettings(context);
    }
    setState(() {
      attr.fxNum = value;
    });
    if(Controller.providerModel.list != null) {
      attr.processFxNum();
      Controller.setSend(130);
    }
  }

  onFxSpeedChangeEnd(value) {
    if(value > 99) attr.fxSpeed = 99;
    else attr.fxSpeed = value;
    if(Controller.providerModel.list != null) {
      attr.processFxAttributes();
      Controller.setSend(130);
    }
  }

  onFxPartsChangeEnd(value) {
    attr.fxParts = value;
    if(Controller.providerModel.list != null) {
      attr.processFxAttributes();
      Controller.setSend(130);
    }
  }

  onFxSpreadChangeEnd(value) {
    attr.fxSpread = value;
    if(Controller.providerModel.list != null) {
      attr.processFxAttributes();
      Controller.setSend(130);
    }
  }

  onFxWidthChangeEnd(value) {
    attr.fxWidth = value;
    if(Controller.providerModel.list != null) {
      attr.processFxAttributes();
      Controller.setSend(130);
    }
  }

  onFxAttackChange(value) {
    setState(() {
      attr.fxAttack = value;
    });
    if(Controller.providerModel.list != null) {
      attr.processFxAttributes();
      Controller.setSend(130);
    }
  }

  onFxReverseChange(value) {
    setState(() {
      attr.fxReverse = value;
    });
    if(Controller.providerModel.list != null) {
      attr.processFxAttributes();
      Controller.setSend(130);
    }
  }

  onFxSymmChange(value) {
    setState(() {
      attr.fxSymm = value;
    });
    if(Controller.providerModel.list != null) {
      attr.processFxAttributes();
      Controller.setSend(130);
    }
  }

  onFxRndChange(value) {
    setState(() {
      attr.fxRnd = value;
    });
    if(Controller.providerModel.list != null) {
      attr.processFxAttributes();
      Controller.setSend(130);
    }
  }

  onFxRndColorChange(value) {
    setState(() {
      attr.fxRndColor = value;
    });
    if(Controller.providerModel.list != null) {
      attr.processFxAttributes();
      Controller.setSend(130);
    }
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
              color: alertBackgroundColor,
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
                      return FxSliderWidget("Speed", mainBackgroundColor, attr.fxSpeed, 100, onFxSpeedChangeEnd, true);
                    }),
                    FxSliderWidget("Width", mainBackgroundColor, attr.fxWidth, 30, onFxWidthChangeEnd, (attr.fxNum == FxNames.Cyclon.index || attr.fxNum == FxNames.Fade.index)),
                    FxSliderWidget("Parts", mainBackgroundColor, attr.fxParts, 100, onFxPartsChangeEnd, (attr.fxNum != FxNames.OFF.index && attr.fxNum != FxNames.Cyclon.index)),
                    StatefulBuilder(builder: (context, setStat) {
                      onAttack(value) {onFxAttackChange(value); setStat(() {});}
                      onSymm(value) {onFxSymmChange(value); setStat(() {});}
                      onReverse(value) {onFxReverseChange(value); setStat(() {});}
                      onRandom(value) {onFxRndChange(value); setStat(() {});}
                      onRandomCol(value) {onFxRndColorChange(value); setStat(() {});}
                      return Column(
                        children: <Widget>[
                          FxSliderWidget("Spread", mainBackgroundColor, attr.fxSpread, 100, onFxSpreadChangeEnd, (attr.fxNum == FxNames.Sinus.index || (attr.fxNum == FxNames.Fade.index && attr.fxRnd))),

                          SingleChildScrollView(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                CustomRadio(label: "Attack", value: attr.fxAttack, onChanged: onAttack, color: accentColor, selectedCol: buttonSelectedColor, margin: 0, visible: (attr.fxNum == FxNames.Sinus.index), fontSize: ffontSize,),
                                CustomRadio(label: "Symm", value: attr.fxSymm, onChanged: onSymm, color: accentColor, selectedCol: buttonSelectedColor, margin: 0, visible: (attr.fxNum == FxNames.Sinus.index || attr.fxNum == FxNames.Fade.index), fontSize: ffontSize,),
                                CustomRadio(label: "Reverse", value: attr.fxReverse, onChanged: onReverse, color: accentColor, selectedCol: buttonSelectedColor, margin: 0, visible: (attr.fxNum != FxNames.OFF.index && attr.fxNum != FxNames.Cyclon.index), fontSize: ffontSize,),
                                CustomRadio(label: "Random", value: attr.fxRnd, onChanged: onRandom, color: accentColor, selectedCol: buttonSelectedColor, margin: 0, visible: (attr.fxNum == FxNames.Fade.index), fontSize: ffontSize,),
                                CustomRadio(label: "Random Color", value: attr.fxRndColor, onChanged: onRandomCol, color: accentColor, selectedCol: buttonSelectedColor, visible: (attr.fxNum == FxNames.Fade.index), fontSize: ffontSize,),
                              ],
                            ),
                          ),
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
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double fontSize = height > width ? (width/25)/1.1 : (height/25)/1.1;
    bool portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    wwidth = width;
    hheight = height;
    ffontSize = fontSize;
    return GridView.count(
      key: fxNumKey, /////////////////////////////////////////////
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      childAspectRatio: portrait ? 1.6 : 2,
      children: <Widget>[
        CustomGroupRadio(label: "OFF", value: 0, groupValue: attr.fxNum, onChanged: onFxNumChanged, enabled: true, color: accentColor, selectedCol: buttonSelectedColor, fontSize: fontSize,),
        CustomGroupRadio(label: "Sinus", value: 1, groupValue: attr.fxNum, onChanged: onFxNumChanged, enabled: true, color: accentColor, selectedCol: buttonSelectedColor, padding: 0, fontSize: fontSize,),
        CustomGroupRadio(label: "Cyclon", value: 2, groupValue: attr.fxNum, onChanged: onFxNumChanged, enabled: true, color: accentColor, selectedCol: buttonSelectedColor, padding: 0, fontSize: fontSize),
        CustomGroupRadio(label: "Fade", value: 3, groupValue: attr.fxNum, onChanged: onFxNumChanged, enabled: true, color: accentColor, selectedCol: buttonSelectedColor, fontSize: fontSize,),
        CustomGroupRadio(label: "RGB", value: 4, groupValue: attr.fxNum, onChanged: onFxNumChanged, enabled: true, color: accentColor, selectedCol: buttonSelectedColor, fontSize: fontSize),
      ],);
  }
}