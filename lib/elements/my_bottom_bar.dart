import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ledcontroller/styles.dart';

import '../controller.dart';

class MyBottomBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
                      shape: buttonShape,
                      onPressed: () {

                      }),
                  RaisedButton(
                      child: Text("Area", style: mainText,),
                      color: buttonColor,
                      shape: buttonShape,
                      onPressed: () {

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
                      shape: buttonShape,
                      onPressed: () {
                        Controller.selectAll();
                      }),
                  RaisedButton(
                      child: Icon(Icons.clear),
                      color: buttonColor,
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
      minWidth: 36,
      child: RaisedButton(
        //padding: EdgeInsets.only(top: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(label == null ? "" : label, style: mainText,),
                Container(
                  color: value ? Colors.white : Colors.black,
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
