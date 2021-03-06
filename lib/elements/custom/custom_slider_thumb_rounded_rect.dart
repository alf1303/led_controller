import 'package:flutter/material.dart';

class CustomSliderThumbRoundedRect extends SliderComponentShape{
  final double thumbRadius;
  final double thumbHeight;
  final int min;
  final int max;


  const CustomSliderThumbRoundedRect({
    @required this.thumbRadius,
    @required this.thumbHeight,
    this.min,
    this.max});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {Animation<double> activationAnimation,
      Animation<double> enableAnimation,
      bool isDiscrete,
      TextPainter labelPainter,
      RenderBox parentBox,
      SliderThemeData sliderTheme,
      TextDirection textDirection,
      double value,
      double textScaleFactor,
      Size sizeWithOverflow}) {

    final Canvas canvas = context.canvas;
    final rRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: thumbHeight*1.2, height: thumbHeight*0.6),
        Radius.circular(thumbRadius*0.4));

    final paint = Paint()
    ..color = sliderTheme.activeTrackColor
    ..style = PaintingStyle.fill;

    TextSpan span = new TextSpan(
      style: TextStyle(
        fontSize: thumbHeight*0.5,
        fontWeight: FontWeight.w700,
        color: sliderTheme.thumbColor,
        height: 1),
      text: '${getValue(value)}'
    );

    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    Offset textCenter = Offset(center.dx - (tp.width/2), center.dy - (tp.height/2));

    canvas.drawRRect(rRect, paint);
    tp.paint(canvas, textCenter);

  }

  String getValue(double value) {
    return (min + (max - min)*value).round().toString();
  }
}