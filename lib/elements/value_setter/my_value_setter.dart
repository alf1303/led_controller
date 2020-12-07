import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:invert_colors/invert_colors.dart';
import 'package:ledcontroller/elements/custom/custom_group_radio.dart';
import 'package:ledcontroller/elements/custom/sliders.dart';
import '../../palettes_provider.dart';
import 'color_setter.dart';
import 'package:ledcontroller/elements/value_setter/palette_viewer.dart';
import 'package:ledcontroller/fx_names.dart';
import 'package:ledcontroller/provider_model_attribute.dart';
import 'package:ledcontroller/styles.dart';
import 'package:provider/provider.dart';

import '../../controller.dart';
import '../custom/custom_radio.dart';
import '../custom/fitted_text.dart';
import 'fx_setter.dart';
import 'my_color_picker.dart';

class MyValueSetter extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
     padding: EdgeInsets.symmetric(horizontal: 8),
     //color: Colors.black,
     decoration: secondaryDecoration,
     child: Column(
       children: <Widget>[
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
  int _fxNum = 0;
  Color _fxColor = Colors.grey;
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

  onFxSpreadChangeEnd(value) {
    _fxSpread = value;
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
    if(Controller.providerModel.list != null) {
      processAttributes();
      Controller.setSend(131);
    }
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
                height: 45,
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
                  height:45 ,
                  child: FText("FX Setter"),
                )),
            collapsed: FxSetter()
          ),
          Container(height: 2, color: mainBackgroundColor),
          SizedBox(height: 15,),

          //COLOR SETTER
          ExpandablePanel(
            header: Container(
                margin: EdgeInsets.only(bottom: 1),
                height: 45,
                decoration: BoxDecoration(
                  color: mainBackgroundColor,
                  border: Border.all(),
                  borderRadius: expandedHeaderRadius,
                ),
                child: FText("Color Setter")),
            collapsed: ColorSetter()
          ),
          Container(height: 50, color: thirdBackgroundColor),
        ],
      ),
    );
  }
}
