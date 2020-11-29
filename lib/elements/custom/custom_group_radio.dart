import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomGroupRadio extends StatefulWidget {
  final String label;
  final value;
  final groupValue;
  final ValueChanged<dynamic> onChanged;
  final Color color;
  final bool enabled;
  final double margin;
  final double padding;
  final double fontSize;
  @override
  State createState() {
    return CustomGroupRadioState();
  }
  const CustomGroupRadio({
    @required this.label,
    @required this.value,
    @required this.groupValue,
    @required this.onChanged,
    @required this.enabled,
    this.color,
    this.margin,
    this.padding,
    this.fontSize
  });
}

class CustomGroupRadioState extends State<CustomGroupRadio> {
  void onTapFunction() {
    setState(() {
      widget.onChanged(widget.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.enabled ? onTapFunction : null,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: widget.margin == null ? 6 : widget.margin),
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: widget.padding == null ? 6 : widget.padding),
        decoration: BoxDecoration(
            border: Border.all(color: (widget.enabled && widget.value == widget.groupValue) ? widget.color : Colors.grey),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(7)
        ),
        child: Center(child: Text(widget.label, style: TextStyle(fontSize: widget.fontSize == null ? 10 : widget.fontSize, color: (widget.enabled && widget.value == widget.groupValue) ? widget.color : Colors.grey),)),
      ),
    );
  }
}