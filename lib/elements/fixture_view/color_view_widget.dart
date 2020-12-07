import 'dart:ui';
import 'package:flutter/material.dart';

Widget ColorView(final Color color, final bool shape) {
  //print("ColorViewBuild ${k++}");
  return Container(
    //width: 30,
    decoration: BoxDecoration(
        color: color,
        shape: shape ? BoxShape.circle : BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 2
          )
        ]
    ),
  );
}