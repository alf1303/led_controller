import 'dart:ui';
import 'package:flutter/material.dart';

Widget ColorView(final Color color, final bool shape) {
  //print("ColorViewBuild ${k++}");
  return Padding(
    padding: const EdgeInsets.only(top: 3.0),
    child: Container(
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
    ),
  );
}