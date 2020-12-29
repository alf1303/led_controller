import 'package:flutter/material.dart';
import 'package:ledcontroller/elements/help/helper_box.dart';
import 'package:ledcontroller/styles.dart';
import '../../controller.dart';
import '../../global_keys.dart';

class HelpWidget extends StatelessWidget{
  final double iconSize;
  const HelpWidget(this.iconSize);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setStat) {
        return IconButton(
          padding: EdgeInsets.all(0),
            icon: Icon(Icons.help_outline, color: Controller.help ? Colors.red : Colors.black, size: iconSize*0.8,),
            onPressed: () {
            if (MediaQuery.of(context).orientation == Orientation.portrait) {
              Controller.help = !Controller.help;
              OVERLAYSTATE = Overlay.of(context);
              if (Controller.help && entries.isEmpty) {
                            globalKeysMap.forEach((key, value) {
                                      try {
                                        RenderBox box = key.currentContext.findRenderObject();
                                        Offset position = box.localToGlobal(Offset.zero);
                                        Size size = box.size;
                                        entries.add(HelperBox(context, position, size, value));
                                        //print(key);
                                      } catch (e) {
                                        //print("ogogog");
                                      }
                                    });

                            entries.forEach((entry) {
                                      OVERLAYSTATE.insert(entry);
                                    });
                          } else {
                            entries.forEach((entry) {
                              entry.remove();
                            });
                            entries.clear();
                          }
              setStat((){});
            } else {
              showDialog(context: context,
              builder: (context) {
                return AlertDialog(
                  shape: alertShape,
                  backgroundColor: alertBackgroundColor,
                  title: Text("Help available only in Portrait orientation", style: TextStyle(color: Colors.white),),
                  actions: [
                    IconButton(icon: Icon(Icons.check, color: Colors.white,), onPressed: () {
                      Navigator.pop(context);
                    })
                  ],
                );
              }
              );
            }
            },
            );
      }
    );
  }
}