import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ledcontroller/elements/buttons_bar/settings_widget.dart';
import 'package:ledcontroller/model/settings.dart';
import 'package:ledcontroller/styles.dart';
import 'package:ledcontroller/provider_model.dart';
import 'package:provider/provider.dart';

import '../../controller.dart';
import 'indicator_raised_button.dart';

class MyBottomBar extends StatelessWidget {
  final bool isEditor;
  const MyBottomBar(this.isEditor);

  @override
  Widget build(BuildContext context) {
    final providerModel = Provider.of<ProviderModel>(context, listen: true);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    //print("buttonsBar, h: $height, w: $width");
    return Container(
      padding: EdgeInsets.symmetric(vertical: isEditor ? 5 : 0),
      //decoration: bottomDecoration,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Visibility(
              visible: !isEditor,
              child: Expanded(
                child: RaisedButton(
                    elevation: 5,
                    child: Text("Reset", style: mainText,),
                    onPressed: !providerModel.selected ? null : () {
                      showDialog(
                          context: context,
                      builder: (context) {
                            return AlertDialog(
                              shape: alertShape,
                              backgroundColor: alertBackgroundColor,
                              title: Text("Reset selected fixtures?", style: mainWhiteText,),
                              actions: [
                                IconButton(icon: Icon(Icons.check, color: Colors.white,), onPressed: () {
                                  Controller.setReset();
                                  Navigator.pop(context);
                                })
                              ],
                            );
                      }
                      );
                    }),
              ),
            ),
            Visibility(
              visible: !isEditor,
              child: Expanded(
                child: RaisedButton(
                  elevation: 5,
                    child: Text("Area", style: mainText,),
                    onPressed: !Controller.providerModel.selected ? null : () {
                      showDialog(
                          context: context,
                        builder: (context) {
                          Settings set = providerModel.getFirstChecked().ramSet;
                          RangeValues val = RangeValues(set.startPixel.roundToDouble(), set.endPixel.roundToDouble());
                            return Row(
                              children: <Widget>[
                                Material(
                                  color:Colors.transparent,
                                  child: Container(
                                    color: Colors.transparent,
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: StatefulBuilder(
                                          builder: (context, setState) {
                                            return Row(
                                              children: <Widget>[
                                                Container(
                                                  //color:Colors.red,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text("${val.start.round()}"),
                                                  ),
                                                  decoration: roundedDecoration,
                                                ),
                                                Expanded(
                                                  child: RangeSlider(
                                                      values: val,
                                                      min: 0,
                                                      max: set.pixelCount.roundToDouble(),
                                                      divisions: set.pixelCount,
//                                                        labels: RangeLabels(
//                                                          val.start.toString(),
//                                                          val.end.toString()
//                                                        ),
                                                      onChanged: (values) {
                                                        val = values;
                                                        setState(() {});
                                                      },
                                                  onChangeEnd: (values) {
                                                        Controller.setArea(set.pixelCount, values);
                                                  },
                                                  ),
                                                ),
                                                Container(
                                                    decoration: roundedDecoration,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("${val.end.round()}"),
                                                    )),
                                              ],
                                            );
                                          }
                                      )
                                    ),
                                  ),
                                ),
                              ],
                            );
                        }
                      );
                    }),
              ),
            ),
            Expanded(child: SettingsWidget()),
            Expanded(
              child: StatefulBuilder(builder: (context, setState) {
                onChanged(bool value) {
                  Controller.highlite = value;
                  if(value) {
                    Controller.setHighlite();
                  }
                  else {
                    Controller.unsetHLAll();
                  }
                  setState(() {});
                }
                return IndicatorRaisedButton(label: "HL", value: Controller.highlite, onPressed: onChanged,);
              }),
            ),
            Expanded(
              child: RaisedButton(
                shape: buttonShape,
                elevation: 5,
                  child: Icon(Icons.select_all),
                  onPressed: () {
                    Controller.selectAll();
                  }),
            ),
            Expanded(
              child: RaisedButton(
                  color: Controller.areNotSelected() ? buttonColor : buttonSelectedColor,
                shape: Controller.areNotSelected() ? buttonShape : buttonSelectShape,
                elevation: 5,
                  child: Icon(Icons.clear, color: Controller.areNotSelected() ? Colors.black : accentColor,),
                  onPressed: () {
                    Controller.deselectAll();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}


