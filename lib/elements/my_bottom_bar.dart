import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ledcontroller/elements/custom/custom_radio.dart';
import 'package:ledcontroller/model/settings.dart';
import 'package:ledcontroller/styles.dart';
import 'package:ledcontroller/provider_model.dart';
import 'package:provider/provider.dart';

import '../controller.dart';

class MyBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerModel = Provider.of<ProviderModel>(context, listen: true);
    return Container(
      decoration: bottomDecoration,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 40,
        child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          slivers: <Widget>[
            SliverFillRemaining(
              hasScrollBody: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                      child: Text("Reset", style: mainText,),
                      color: buttonColor,
                      splashColor: splashColor,
                      shape: buttonShape,
                      onPressed: !providerModel.selected ? null : () {
                        Controller.setReset();
                      }),
                  RaisedButton(
                      child: Text("Area", style: mainText,),
                      color: buttonColor,
                      splashColor: splashColor,
                      shape: buttonShape,
                      onPressed: !Controller.providerModel.selected ? null : () {
                        showDialog(
                            context: context,
                          builder: (context) {
                            Settings set = providerModel.getFirstChecked().ram_set;
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
                  StatefulBuilder(builder: (context, setState) {
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
                  RaisedButton(
                      child: Icon(Icons.select_all),
                      color: buttonColor,
                      splashColor: splashColor,
                      shape: buttonShape,
                      onPressed: () {
                        Controller.selectAll();
                      }),
                  RaisedButton(
                      child: Icon(Icons.clear),
                      color: buttonColor,
                      splashColor: splashColor,
                      shape: buttonShape,
                      onPressed: () {
                        Controller.deselectAll();
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class IndicatorRaisedButton extends StatelessWidget{
  final String label;
  final bool value;
  final ValueChanged<bool> onPressed;
const IndicatorRaisedButton({
  @required this.label,
  @required this.value,
  @required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      buttonColor: buttonColor,
        splashColor: splashColor,
        minWidth: 36,
      child: RaisedButton(
        //padding: EdgeInsets.only(top: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(label == null ? "" : label, style: mainText,),
                Container(
                  decoration: BoxDecoration(
                      color: value ? Colors.white : Colors.black,
                    boxShadow: [
                      BoxShadow(color: Colors.white,
                      blurRadius: value ? 3 : 0,
                      spreadRadius: value ? 2 : 0)
                    ]
                  ),

                  width: 12,
                  height: 12,
                ),
              ],
            ),
            onPressed: () {
              onPressed(!value);
            })
      );
  }
}
