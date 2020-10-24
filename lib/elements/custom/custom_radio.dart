import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRadio extends StatefulWidget {
  final String label;
  final int value;
  final int groupValue;
  final ValueChanged<int> onChanged;
  final Color color;
  final bool enabled;
  final double margin;
  final double padding;
  @override
  State createState() {
    return CustomRadioState();
  }
  const CustomRadio({
    @required this.label,
    @required this.value,
    @required this.groupValue,
    @required this.onChanged,
    @required this.enabled,
    this.color,
    this.margin,
    this.padding
  });
}

class CustomRadioState extends State<CustomRadio> {
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
        child: Text(widget.label, style: TextStyle(color: (widget.enabled && widget.value == widget.groupValue) ? widget.color : Colors.grey),),
      ),
    );
  }
}