import 'package:flutter/cupertino.dart';
import 'package:ledcontroller/styles.dart';

  class FText extends StatelessWidget {
    final String text;

    const FText(this.text);

    @override
    Widget build(BuildContext context) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(text, style: headerTextSmall,),
      );
    }
  }