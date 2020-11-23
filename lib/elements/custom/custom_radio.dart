import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRadio extends StatefulWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color color;
  final double margin;
  final double padding;
  final bool visible;
  @override
  State createState() {
    return CustomRadioState();
  }
  const CustomRadio({
    @required this.label,
    @required this.value,
    @required this.onChanged,
    this.color,
    this.margin,
    this.padding,
    this.visible = true
  });
}

class CustomRadioState extends State<CustomRadio> {
  void onTapFunction() {
    setState(() {
      widget.onChanged(!widget.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visible,
      child: GestureDetector(
        onTap: onTapFunction,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: widget.margin == null ? 6 : widget.margin),
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: widget.padding == null ? 6 : widget.padding),
          decoration: BoxDecoration(
              border: Border.all(color: (widget.value) ? widget.color : Colors.grey),
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(7)
          ),
          child: Text(widget.label, style: TextStyle(color: (widget.value) ? widget.color : Colors.grey, fontSize: 10), ),
        ),
      ),
    );
  }
}