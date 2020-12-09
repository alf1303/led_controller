import 'package:flutter/material.dart';
import 'package:ledcontroller/model/esp_model.dart';
import 'package:provider/provider.dart';

import '../../controller.dart';
import '../../provider_model.dart';
import '../../styles.dart';


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
                  backgroundColor: alertBackgroundColor,
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
                                      color: mainBackgroundColor.withOpacity(0.8),
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
                            //child: SizedBox(height: 2, child: Container(color: Colors.white),),
                          ),
                          Column(
                            children: <Widget>[
                              Text("PixelCount:", style: mainWhiteText,),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      color: mainBackgroundColor.withOpacity(0.8),
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
                            //child: SizedBox(height: 2, child: Container(color: Colors.white),),
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
                                            inactiveTrackColor: secondaryBackgroundColor,
                                            activeTrackColor: secondaryBackgroundColor,
                                            activeColor: Colors.white,
                                            inactiveThumbColor: Colors.white,
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
                                            color: mainBackgroundColor.withOpacity(0.8),
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
                                    SizedBox(height: 3,),
                                    Row(
                                      children: <Widget>[
                                        Text("PASSWORD:", style: mainWhiteText,),
                                        Expanded(
                                          child: Container(
                                            color: mainBackgroundColor.withOpacity(0.8),
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