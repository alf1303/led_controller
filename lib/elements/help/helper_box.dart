import 'package:flutter/material.dart';
import 'package:ledcontroller/global_keys.dart';
import 'package:ledcontroller/styles.dart';

OverlayEntry HelperBox(BuildContext context, Offset position, Size size, String text) {
  return OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy+1,
        left: position.dx+1,
        child: GestureDetector(
          onTap: () {
            entries.forEach((element) {
              element.remove();
            });
            showDialog(
                context: context,
              builder: (context) {
                  return AlertDialog(
                    shape: alertShape,
                    backgroundColor: alertBackgroundColor,
                    content: Text(text, style: TextStyle(color: Colors.white, fontSize: 20),),
                      actions: [
                        IconButton(icon: Icon(Icons.check, color: Colors.white,), onPressed: () {
                          Navigator.pop(context);
                        })
                      ]
                  );
              }
            ).then((value) {
              entries.forEach((entry) {
                OVERLAYSTATE.insert(entry);
              });
            });
          },
          child: Container(
            width: size.width-2,
            height: size.height-2,
            //color: Colors.purple.withOpacity(0.5),
            decoration: BoxDecoration(
              color: Colors.yellow.withOpacity(0.4),
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
          ),
        ),
      )
  );
}