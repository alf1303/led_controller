import 'package:flutter/material.dart';

//COLORS
const Color mainBackgroundColor = Colors.purpleAccent;
Color secondaryBackgroundColor = Colors.white.withOpacity(0.4);
const Color thirdBackgroundColor = Colors.cyanAccent;
const Color buttonColor = Colors.lightBlueAccent;
const Color linesColor = Colors.white70;
const Color textBlack = Colors.black;
const Color dividerColor = Colors.black12;
const Color splashColor = Colors.purpleAccent;
Color emptyPaletteColor = Colors.grey.withOpacity(0.7);

//TEXT STYLES
TextStyle headerText = TextStyle(fontSize: 25, letterSpacing: 2, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(1),
    shadows: [Shadow(color: Colors.pinkAccent, blurRadius: 5,)]
);
TextStyle headerTextSmall = TextStyle(fontSize: 16, letterSpacing: 2, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(1),
    shadows: [Shadow(color: Colors.pinkAccent, blurRadius: 5,)]
);
const TextStyle mainText = TextStyle(color: textBlack);
const TextStyle smallText = TextStyle(fontSize: 10, color: textBlack);
const TextStyle mainWhiteText = TextStyle(color: Colors.white);

//SHAPES AND BORDERS
RoundedRectangleBorder buttonShape = RoundedRectangleBorder(side: BorderSide(color: linesColor, width: 2), borderRadius: BorderRadius.circular(6));
RoundedRectangleBorder roundedButtonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(color: linesColor));
RoundedRectangleBorder alertShape = RoundedRectangleBorder(side: BorderSide(color: secondaryBackgroundColor,),  borderRadius: BorderRadius.circular(12));
const OutlineInputBorder focusedBorder = OutlineInputBorder(borderSide: BorderSide(color: splashColor));
const OutlineInputBorder enabledBorder = OutlineInputBorder(borderSide: BorderSide(color: mainBackgroundColor));
const OutlineInputBorder focusedErrorBorder = OutlineInputBorder(borderSide: BorderSide(color: Colors.red));

//INPUT DECORATION
InputDecoration inputDecoration = InputDecoration(
  focusedBorder: focusedBorder,
  enabledBorder: enabledBorder,
  focusedErrorBorder: focusedErrorBorder,
  isDense: true,
  contentPadding: EdgeInsets.only(top: 8, bottom: 8, left: 5),
);


//BUTTON THEME
ButtonTheme mainButtonTheme = ButtonTheme(
  buttonColor: buttonColor,
  splashColor: splashColor,
  shape: buttonShape,
);

//DECORATION
BoxDecoration mainDecoration = BoxDecoration( //GRADIENT
    gradient: LinearGradient(
        colors: [
          mainBackgroundColor,
          secondaryBackgroundColor
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter
    ),
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

BoxDecoration roundedDecoration = BoxDecoration( //GRADIENT
  gradient: LinearGradient(
      colors: [
        mainBackgroundColor,
        secondaryBackgroundColor
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter
  ),
  borderRadius: BorderRadius.circular(20)
);


