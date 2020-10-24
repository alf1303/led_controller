import 'package:flutter/material.dart';

class InnerShadedContainer extends StatelessWidget {
  final double height;
  //final double width;
  final double shadeWidth; // 0.5-0.95
  final Color shadeColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;


  InnerShadedContainer(this.height, this.shadeWidth,
      this.shadeColor, this.borderColor, this.borderWidth, this.borderRadius);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        MyInnerShadedContainer(height, shadeWidth, shadeColor, borderColor, borderWidth, borderRadius, Alignment.centerLeft, Alignment.centerRight, true),
        MyInnerShadedContainer(height, shadeWidth, shadeColor, borderColor, borderWidth, borderRadius, Alignment.centerRight, Alignment.centerLeft, true),
        MyInnerShadedContainer(height, shadeWidth, shadeColor, borderColor, borderWidth, borderRadius, Alignment.bottomCenter, Alignment.topCenter, false),
        MyInnerShadedContainer(height, shadeWidth, shadeColor, borderColor, borderWidth, borderRadius, Alignment.topCenter, Alignment.bottomCenter, false),
      ],
    );
  }

}

class MyInnerShadedContainer extends StatelessWidget {
  final double height;
  //final double width;
  final double shadeWidth; // 0.5-0.95
  final Color shadeColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final Alignment begin;
  final Alignment end;
  final bool horizontal;

  MyInnerShadedContainer(this.height,
      this.shadeWidth,
      this.shadeColor,
      this.borderColor,
      this.borderWidth,
      this.borderRadius,
      this.begin,
      this.end,
      this.horizontal
      );


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: borderWidth),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          gradient: LinearGradient(colors: [
            shadeColor.withOpacity(0),
            shadeColor,
          ],
              begin: begin,
              end: end,
              stops: horizontal ? [shadeWidth, 1] : [shadeWidth - 0.13, 1]
          )
      ),
      height: height,
      //width: width,
    );
  }
}