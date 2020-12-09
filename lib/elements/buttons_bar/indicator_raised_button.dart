import 'package:flutter/material.dart';
import 'package:ledcontroller/controller.dart';
import 'package:ledcontroller/global_keys.dart';

import '../../styles.dart';
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
    return RaisedButton(
      key: highliteKey, //////////////////////////////////////
      color: Controller.highlite ? buttonSelectedColor : buttonColor,
        shape: Controller.highlite ? buttonSelectShape : buttonShape,
        //padding: EdgeInsets.only(top: 25),
        child: Row(
         // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(label == null ? "" : label, style: mainText.copyWith(color: Controller.highlite ? Colors.yellowAccent : Colors.black),),
            SizedBox(width: 4,),
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
        });
  }
}