import 'package:flutter/material.dart';

//COLORS
Color mainBackgroundColor = Colors.purpleAccent;
Color secondaryBackgroundColor = Colors.white.withOpacity(0.4);
Color thirdBackgroundColor = Colors.cyanAccent;
Color buttonColor = Colors.lightBlueAccent;
Color linesColor = Colors.white70;
Color textBlack = Colors.black;
Color dividerColor = Colors.black12;

//TEXT STYLES
TextStyle headerText = TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(1));
TextStyle mainText = TextStyle(color: textBlack);
TextStyle smallText = TextStyle(fontSize: 8, color: textBlack);

//SHAPES AND BORDERS
RoundedRectangleBorder buttonShape = RoundedRectangleBorder(side: BorderSide(color: linesColor, width: 2), borderRadius: BorderRadius.circular(6));

//DECORATION
BoxDecoration mainDecoration = BoxDecoration( //GRADIENT
    gradient: LinearGradient(
        colors: [
          mainBackgroundColor,
          secondaryBackgroundColor
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter
    )
);

BoxDecoration secondaryDecoration = BoxDecoration( //GRADIENT
    gradient: LinearGradient(
        colors: [
          thirdBackgroundColor,
          secondaryBackgroundColor
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter
    )
);

BoxDecoration bottomDecoration = BoxDecoration(
    gradient: LinearGradient(
        colors: [
          mainBackgroundColor,
          secondaryBackgroundColor
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        tileMode: TileMode.repeated
    )
);

