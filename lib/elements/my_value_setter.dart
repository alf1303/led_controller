import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:ledcontroller/elements/pallete_viewer.dart';
import 'package:ledcontroller/model/esp_model.dart';
import 'package:ledcontroller/provider_model_attribute.dart';
import 'package:ledcontroller/styles.dart';
import 'package:ledcontroller/udp_controller.dart';
import 'package:provider/provider.dart';

import '../controller.dart';
import '../provider_model.dart';

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
           header: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: <Widget>[
               RaisedButton(
                   child: Text("Scan", style: mainText,),
                   elevation: 10,
                   onPressed: () async{
                     await Controller.scan();
                   }),
               RaisedButton(
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
                                                     if(int.parse(value) > 1024) return "< 1025";
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
                   }),
               Text("LED", style: headerText,),
               Text("")
             ],
           ),
                        //VALUE SETTER
           expanded: ValueSetterView(),
         ),
         Container(height: 2, color: Colors.white),
         ExpandablePanel(
           header: Center(child: Padding(
             padding: const EdgeInsets.only(top: 8.0),
             child: Text("FX Settings", style: headerTextSmall,),
           )),
           expanded: FxSetter(),
         )
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
  double _speed = 0;
  int _numEff = 0;

  void processAttributes() {
    Controller.providerModel.list.forEach((element) {
      if(element.selected) {
        element.ramSet.speed = _speed.round();
        element.ramSet.numEffect = _numEff;
        element.ramSet.color = Color.fromRGBO((_red).round(), (_green).round(), (_blue).round(), 1);
        element.ramSet.dimmer = _dim.round();
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
            height: height > width ? height/13 : width/13,
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

class FxSetter extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Text("FXXXXX");
  }
}