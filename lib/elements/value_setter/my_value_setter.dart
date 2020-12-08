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
    @override
  Widget build(BuildContext context) {
    final double colPickerScale = 1.4;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double fontSize = height > width ? (width/25)/1.1 : (height/25)/1.1;
    final _attrModel = Provider.of<ProviderModelAttribute>(context, listen: true);

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
