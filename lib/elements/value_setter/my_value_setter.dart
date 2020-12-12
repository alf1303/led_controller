import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:invert_colors/invert_colors.dart';
import 'package:ledcontroller/elements/custom/custom_group_radio.dart';
import 'package:ledcontroller/elements/custom/sliders.dart';
import 'package:ledcontroller/elements/fixture_view/simple_fixture_view.dart';
import 'package:ledcontroller/elements/my_app_bar.dart';
import 'package:ledcontroller/global_keys.dart';
import 'package:ledcontroller/model/palette.dart';
import '../../palettes_provider.dart';
import '../playback_view.dart';
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
  final _tabController;

  const MyValueSetter(this._tabController);

  @override
  Widget build(BuildContext context) {
    return Container(
     padding: EdgeInsets.symmetric(horizontal: 8),
     //color: Colors.black,
     decoration: secondaryDecoration,
     child: ValueSetterView(_tabController),
   );
  }
}

class ValueSetterView extends StatefulWidget{
  final _tabController;

  ValueSetterView(this._tabController);

  bool pallExp = true;
  bool fxExp = true;
  bool colorExp = true;
  @override
  _ValueSetterViewState createState() => _ValueSetterViewState();
}

class _ValueSetterViewState extends State<ValueSetterView> {
    @override
  Widget build(BuildContext context) {
    final double colPickerScale = 1.4;
    final double h = MediaQuery.of(context).size.height;
    //print("aspectRatio: ${MediaQuery.of(context).size.aspectRatio}");
    final double width = MediaQuery.of(context).size.width;
    final double height = h - 100;
    final double uniform = h > width ? h : width;
    double paletteHeight = (uniform - (uniform*0.16 + uniform*0.25 + 140 + 60 + 65));
    //print("valueSetter, h: $h, w: $width");
    if(paletteHeight < 100) paletteHeight = uniform*0.25;
    final double fontSize = h > width ? (width/25)/1.1 : (h/25)/1.1;
    final _attrModel = Provider.of<ProviderModelAttribute>(context, listen: true);
    final paletteController = ExpandableController();
    final fxController = ExpandableController();
    final colorController = ExpandableController();
    paletteController.expanded = widget.pallExp;
    fxController.expanded = widget.fxExp;
    colorController.expanded = widget.colorExp;

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
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 2,),
          MyAppBar(widget._tabController),
          SizedBox(height: 2,),
          SizedBox(
            height: 30,
            child: Row(
              children: [
                Expanded(
                  child: RaisedButton(
                    key: palButKey,
                    color: !widget.pallExp ? buttonSelectedColor.withOpacity(0.6) : buttonColor,
                    shape: !widget.pallExp ? buttonSelectShape2 : buttonShape,
                    onPressed: () {
                      setState(() {
                        widget.pallExp = !widget.pallExp;
                        paletteController.expanded = widget.pallExp;
                        //paletteController.toggle();
                      });
                    },
                    child: Text("Palettes", style: mainText.copyWith(color: !widget.pallExp ? mainBackgroundColor : Colors.black),),
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    key: fxButKey,
                    color: !widget.fxExp ? buttonSelectedColor.withOpacity(0.6) : buttonColor,
                    shape: !widget.fxExp ? buttonSelectShape2 : buttonShape,
                    onPressed: () {
                      setState(() {
                        widget.fxExp = !widget.fxExp;
                        fxController.expanded = widget.fxExp;
                        //paletteController.toggle();
                      });
                    },
                    child: Text("Fx setter", style: mainText.copyWith(color: !widget.fxExp ? mainBackgroundColor : Colors.black)),
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    key: colButKey,
                    color: !widget.colorExp ? buttonSelectedColor.withOpacity(0.6) : buttonColor,
                    shape: !widget.colorExp ? buttonSelectShape2 : buttonShape,
                    onPressed: () {
                      setState(() {
                        widget.colorExp = !widget.colorExp;
                        colorController.expanded = widget.colorExp;
                        //paletteController.toggle();
                      });
                    },
                    child: Text("ColorSetter", style: mainText.copyWith(color: !widget.colorExp ? mainBackgroundColor : Colors.black)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4,),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //PALLETES VIEWER
                  ExpandablePanel(
                    controller: paletteController,
                    expanded: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Container(
                        child: PaletteViewer(),
                        // padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: mainBackgroundColor,
                          border: Border.all(),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        height: height > width ? height*0.26 : width*0.25,
                        width: width,
                      ),
                    ),
                  ),
                  //Container(height: 2 , color: mainBackgroundColor),

                  /////////FX SETTER
                  ExpandablePanel(
                    controller: fxController,
                    expanded: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Container(
                        height: height > width ? height*0.18 : width*0.18,
                          child: FxSetter()
                      ),
                    )
                  ),
                 // Container(height: 2, color: mainBackgroundColor),

                  //COLOR SETTER
                  ExpandablePanel(
                    controller: colorController,
                    expanded: Container(
                        height: height > width ? height*0.25 < 140 ? 140 : height*0.25 : width*0.25 < 140 ? 140 : width*0.25,
                        child: ColorSetter()
                    )
                  ),
                  //SimpleFixtureView()
                ],
              ),
            ),
          ),
          Container(
              height: height > width ? height*0.27 : height*0.33,
              child: SimpleFixtureView())
        ],
      ),
    );
  }
}
