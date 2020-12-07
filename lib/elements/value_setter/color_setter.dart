import 'package:flutter/material.dart';
import 'package:ledcontroller/elements/custom/sliders.dart';
import 'package:ledcontroller/provider_model_attribute.dart';
import 'package:provider/provider.dart';

import '../../controller.dart';
import '../../styles.dart';

class ColorSetter extends StatelessWidget {
  final attrProvider = ProviderModelAttribute();
  onDimmerChangeEnd(value) {
    if(Controller.providerModel.list != null) {
      attrProvider.processColors();
      Controller.setSend(1);
    }
  }

  onColorChangeEnd(value) {
    if(Controller.providerModel.list != null) {
      attrProvider.processColors();
      Controller.setSend(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final attr = Provider.of<ProviderModelAttribute>(context, listen: false);
    return Container(
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
                      MyCustomSlider("", attr.dim, 0, 255, secondaryBackgroundColor, linesColor, Colors.black45, 5, (v) {setStat((){attr.dim = v;});}, onDimmerChangeEnd),
                      MyCustomSlider("", attr.red, 0, 255, secondaryBackgroundColor, linesColor, Colors.red, 5, (v) {setStat((){attr.red = v;});}, onColorChangeEnd),
                      MyCustomSlider("", attr.green, 0, 255, secondaryBackgroundColor, linesColor, Colors.green, 5, (v) {setStat((){attr.green = v;});}, onColorChangeEnd),
                      MyCustomSlider("", attr.blue, 0, 255, secondaryBackgroundColor, linesColor, Colors.blue, 5, (v) {setStat((){attr.blue = v;});}, onColorChangeEnd),
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
                              color: Color.fromRGBO(attr.red.round(), attr.green.round(), attr.blue.round(), 1),
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
                          onPressed: () {
                            attr.zeroColors();
                            Controller.setSend(2);
                            setStat(() {  });
                          }
                      ),
                    ],
                  ),
                )
              ],
            );
          }
      ),
    );
  }
}