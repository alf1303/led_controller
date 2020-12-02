import 'package:flutter/cupertino.dart';

Widget FText(String text, TextStyle style) {
  return FittedBox(
    fit: BoxFit.scaleDown,
    child: Text(text, style: style,),
  );
}