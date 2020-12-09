import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//COLORS
//const Color mainBackgroundColor = Color.fromARGB(255, 252, 215, 251);
const Color mainBackgroundColor = Color.fromARGB(255, 252, 235, 255);
Color secondaryBackgroundColor = Colors.white;
const Color thirdBackgroundColor = Color.fromARGB(255, 212, 255, 233);
//const Color palBackColor = Color.fromARGB(255, 150, 240, 255);
const Color palBackColor = thirdBackgroundColor;

//const Color buttonColor = Color.fromARGB(255, 161, 230, 255);
const Color buttonColor = mainBackgroundColor;
const Color buttonBorderColor = Colors.grey;
const Color linesColor = mainBackgroundColor;
const Color linesColor2 = Colors.pink;
const Color radioColor = linesColor2;
const Color textBlack = Colors.black;
const Color mainTextColor = Colors.black; //*************
const Color dividerColor = Colors.black12;
const Color splashColor = mainBackgroundColor;
Color emptyPaletteColor = Colors.grey.withOpacity(0.7);

const Color selectedColor = mainBackgroundColor;
const Color selectedLinesColor = Colors.yellowAccent;
const Color accentColor = Colors.yellowAccent;
Color buttonSelectedColor = Colors.blueGrey;
Color alertBackgroundColor = thirdBackgroundColor.withOpacity(0);

//SHADOWS
BoxShadow boxShadow1 = BoxShadow(
    color: mainBackgroundColor.withOpacity(0.3),
    spreadRadius: 0.5,
    blurRadius: 2,
    offset: Offset(1, 2)
);

//TEXT STYLES
TextStyle headerText = TextStyle(fontSize: 25, letterSpacing: 2, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(1),
    shadows: [Shadow(color: Colors.pinkAccent, blurRadius: 5,)]
);
TextStyle headerTextSmall = TextStyle(fontSize: 20, letterSpacing: 2, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(1),
    shadows: [Shadow(color: Colors.pinkAccent, blurRadius: 5,)]
);
const TextStyle mainText = TextStyle(color: mainTextColor);
const TextStyle smallText = TextStyle(fontSize: 20, color: textBlack);
const TextStyle mainWhiteText = TextStyle(color: Colors.white);

//SHAPES AND BORDERS
RoundedRectangleBorder buttonShape = RoundedRectangleBorder(side: BorderSide(color: buttonBorderColor, width: 2), borderRadius: BorderRadius.circular(6));
RoundedRectangleBorder buttonSelectShape = RoundedRectangleBorder(side: BorderSide(color: accentColor, width: 2), borderRadius: BorderRadius.circular(6));
RoundedRectangleBorder roundedButtonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(color: buttonBorderColor));
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


LinearGradient tabGradient = LinearGradient(
colors: [
mainBackgroundColor,
secondaryBackgroundColor
],
begin: Alignment.topCenter,
end: Alignment.bottomCenter
);

//BUTTON THEME
ButtonTheme mainButtonTheme = ButtonTheme(
  buttonColor: buttonColor,
  splashColor: splashColor,
  shape: buttonShape,
  minWidth: 20,
  padding: EdgeInsets.symmetric(horizontal: 6),
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

const BorderRadius expandedHeaderRadius = BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15));
const BorderRadius expandedBodyRadius = BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15));


