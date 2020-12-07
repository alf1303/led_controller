import 'package:flutter/material.dart';

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
        });
  }
}