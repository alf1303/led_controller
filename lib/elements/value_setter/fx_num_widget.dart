import 'package:flutter/material.dart';

class FxNumWidget extends StatelessWidget{

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
    return GridView.count(crossAxisCount: 3,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      childAspectRatio: 1.0,
      children: <Widget>[
        CustomGroupRadio(label: "OFF", value: 0, groupValue: attr.fxNum, onChanged: onFxNumChanged, enabled: true, color: radioColor, fontSize: fontSize,),
        CustomGroupRadio(label: "Sinus", value: 1, groupValue: attr.fxNum, onChanged: onFxNumChanged, enabled: true, color: radioColor, padding: 0, fontSize: fontSize,),
        CustomGroupRadio(label: "Cyclon", value: 2, groupValue: attr.fxNum, onChanged: onFxNumChanged, enabled: true, color: radioColor, padding: 0, fontSize: fontSize),
        CustomGroupRadio(label: "Fade", value: 3, groupValue: attr.fxNum, onChanged: onFxNumChanged, enabled: true, color: radioColor, fontSize: fontSize,),
        CustomGroupRadio(label: "RGB", value: 4, groupValue: attr.fxNum, onChanged: onFxNumChanged, enabled: true, color: radioColor, fontSize: fontSize),
      ],);
  }
}