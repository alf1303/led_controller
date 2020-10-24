import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:ledcontroller/elements/pallete_viewer.dart';
import 'package:ledcontroller/provider_model_attribute.dart';
import 'package:ledcontroller/styles.dart';
import 'package:provider/provider.dart';

import '../controller.dart';

class MyValueSetter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Container(
     padding: EdgeInsets.symmetric(horizontal: 8),
     //color: valueSetterMainColor,
     decoration: secondaryDecoration,
     child: ExpandablePanel(
                      //HEADER
       header: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: <Widget>[
           RaisedButton(
               child: Text("Scan", style: mainText,),
               color: buttonColor,
               elevation: 10,
               shape: buttonShape,
               onPressed: () {

               }),
           Text("LedController", style: headerText,),
           Text("")
         ],
       ),
                    //VALUE SETTER
       expanded: ValueSetterView(),
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
  double _speed = 0;
  int _numEff = 0;

  void processAttributes() {
    Controller.providerModel.list.forEach((element) {
      if(element.selected) {
        element.ram_set.speed = _speed.round();
        element.ram_set.numEffect = _numEff;
        element.ram_set.color = Color.fromRGBO((_red).round(), (_green).round(), (_blue).round(), 1);
        element.ram_set.dimmer = _dim.round();
      }
    });
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

  void _zeroVals() {
    _dim = 255;
    _red = 0;
    _green = 0;
    _blue = 0;
    setState(() {  });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final _attrModel = Provider.of<ProviderModelAttribute>(context, listen: true);
    if(_attrModel.flag) {
      _dim = _attrModel.dim;
      _red = _attrModel.red;
      _green = _attrModel.green;
      _blue = _attrModel.blue;
      _speed = _attrModel.speed;
      _numEff = _attrModel.numEff;
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
                  MyCustomSlider(_dim, 255, secondaryBackgroundColor, Colors.white, Colors.white, 5, onDimmerChanged, onDimmerChangeEnd),
                  MyCustomSlider(_red, 255, secondaryBackgroundColor, Colors.white, Colors.red, 5, onRedChanged, onRedChangeEnd),
                  MyCustomSlider(_green, 255, secondaryBackgroundColor, Colors.white, Colors.green, 5, onGreenChanged, onGreenChangeEnd),
                  MyCustomSlider(_blue, 255, secondaryBackgroundColor, Colors.white, Colors.blue, 5, onBlueChanged, onBlueChangeEnd),
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
                            BoxShadow(
                                color: mainBackgroundColor.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(1, 1)
                            )
                          ]
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Icon(Icons.clear, size: 24,),
                    color: buttonColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onPressed: _zeroVals
                  )
                ],
              ),
            )
          ],
        ),
                                  //PALLETES VIEWER
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
            height: height > width ? height/15 : width/15,
            width: width,
          ),
        ),
      ],
    );
  }
}

class MyCustomSlider extends StatelessWidget {
  final double value;
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

  const MyCustomSlider(this.value, this.max, this.shadowColor, this.borderColor, this.sliderColor,
      this.borderRadius, this._valueChanged, this._valueChangeEnd);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      shadowColor: secondaryBackgroundColor,
      shape: RoundedRectangleBorder(side: BorderSide(color: borderColor) ,borderRadius: BorderRadius.circular(borderRadius)),
      child: Slider(
        min: 0,
          max: max,
          activeColor: sliderColor,
          inactiveColor: sliderColor.withOpacity(0.3),
          value: value ,
          onChanged: onValChanged,
          onChangeEnd: onValChangeEnd
      ),
    );
  }
}