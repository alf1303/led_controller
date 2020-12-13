import 'package:flutter/material.dart';
import 'package:ledcontroller/elements/custom/sliders.dart';
import 'package:ledcontroller/provider_model_attribute.dart';
import 'package:provider/provider.dart';

import '../../controller.dart';
import '../../global_keys.dart';
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
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double trackHeight = height > width ? height*0.006 : width*0.006;
    //print("ColorSetter, h: $height, w: $width");
    final attr = Provider.of<ProviderModelAttribute>(context, listen: false);
    return Container(
      key: colorSetterKey, ///////////////////////////////
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(child: MyCustomSlider("", attr.dim, 0, 255, secondaryBackgroundColor, linesColor, Colors.grey, 5, (v) {attr.dim = v; setStat((){});}, onDimmerChangeEnd, trackHeight)),
                      Expanded(child: MyCustomSlider("", attr.red, 0, 255, secondaryBackgroundColor, linesColor, Colors.red, 5, (v) {attr.red = v; setStat((){});}, onColorChangeEnd, trackHeight)),
                      Expanded(child: MyCustomSlider("", attr.green, 0, 255, secondaryBackgroundColor, linesColor, Colors.green, 5, (v) {attr.green = v; setStat((){});}, onColorChangeEnd, trackHeight)),
                      Expanded(child: MyCustomSlider("", attr.blue, 0, 255, secondaryBackgroundColor, linesColor, Colors.blue, 5, (v) {attr.blue = v; setStat((){});}, onColorChangeEnd, trackHeight)),
                    ],
                  ),
                ),
                //COLOR VIEWER
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8.0),
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(attr.red.round(), attr.green.round(), attr.blue.round(), 1),
                                border: Border.all(color: Colors.grey),
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                boxShadow: [boxShadow1]
                            ),
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