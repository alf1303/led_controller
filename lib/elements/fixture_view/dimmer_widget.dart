import 'package:flutter/material.dart';

class DimmerWidget  extends StatelessWidget{
  final int dimmer;
  const DimmerWidget(this.dimmer);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: constraints.constrainWidth()*(dimmer*1.0/255),
              height: 2,
              color: Colors.white,
            ),
          );
        });
  }
}