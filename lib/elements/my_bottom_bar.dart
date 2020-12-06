import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ledcontroller/model/settings.dart';
import 'package:ledcontroller/styles.dart';
import 'package:ledcontroller/provider_model.dart';
import 'package:provider/provider.dart';

import '../controller.dart';

class MyBottomBar extends StatelessWidget {
  final bool isEditor;
  const MyBottomBar(this.isEditor);

  void onSavePressed() {
    if(Controller.providerModel.list != null) {
      Controller.setSend(255);
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerModel = Provider.of<ProviderModel>(context, listen: true);
    return Container(
      padding: EdgeInsets.symmetric(vertical: isEditor ? 5 : 0),
      //decoration: bottomDecoration,
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
                  Visibility(
                    visible: !isEditor,
                    child: RaisedButton(
                        elevation: 10,
                        child: Text("Reset", style: mainText,),
                        onPressed: !providerModel.selected ? null : () {
                          Controller.setReset();
                        }),
                  ),
                  Visibility(
                    visible: !isEditor,
                    child: RaisedButton(
                      elevation: 10,
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
                    shape: buttonShape,
                    elevation: 10,
                      child: Icon(Icons.select_all),
                      onPressed: () {
                        Controller.selectAll();
                      }),
                  RaisedButton(
                    shape: Controller.areNotSelected() ? buttonShape : buttonSelectShape,
                    elevation: 10,
                      child: Icon(Icons.clear, color: Controller.areNotSelected() ? Colors.black : Colors.red,),
                      onPressed: () {
                        Controller.deselectAll();
                      }),
                  Visibility(
                    visible: isEditor,
                    child: RaisedButton(
                        child: Icon(Icons.save, size: 24,),
                        shape: roundedButtonShape,
                        onPressed: onSavePressed
                    )
                  ),
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
      buttonColor: mainBackgroundColor.withOpacity(0.5),
        splashColor: splashColor,
        minWidth: 36,
      child: RaisedButton(
        shape: RoundedRectangleBorder(side: BorderSide(color: buttonBorderColor, width: 1), borderRadius: BorderRadius.circular(6) ),
        //padding: EdgeInsets.only(top: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(label == null ? "" : label, style: mainText,),
                Container(
                  decoration: BoxDecoration(
                      color: value ? Colors.yellowAccent : Colors.black,
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
