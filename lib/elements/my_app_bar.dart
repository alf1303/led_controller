import 'package:flutter/material.dart';
import 'package:ledcontroller/elements/playback_view.dart';
import 'package:ledcontroller/elements/scan_widget.dart';

import '../controller.dart';
import '../styles.dart';

class MyAppBar extends StatelessWidget{

  void onSavePressed() {
    if(Controller.providerModel.list != null) {
      Controller.setSend(255);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 30,
      child: CustomScrollView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ScanWidget(),
                GestureDetector(
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("Insert virtual fixtures?"),
                              actions: [
                                IconButton(icon: Icon(Icons.check), onPressed: () {
                                  Controller.fakeInit();
                                  Navigator.pop(context);
                                })
                              ],
                            );
                          }
                      );
                    },
                    child: Text("LEDCon", style: headerText,)),
                RaisedButton(
                    elevation: 5,
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    //child: Icon(Icons.save, size: 24,),
                    child: FittedBox(fit: BoxFit.scaleDown, child: Text("Save To Device"),),
                    onPressed: onSavePressed
                ),
                SizedBox( width: 100,
                  child: RaisedButton(
                      elevation: 5,
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      //child: Icon(Icons.save, size: 24,),
                      child: Icon(Icons.play_circle_outline),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PlaybackView()));
                      }
                  ),
                ),

//                IconButton(icon: Icon(Icons.help_outline, color: Colors.black), onPressed: () {
//                  showDialog(
//                      context: context,
//                      builder: (context) {
//                        return HelpWidget();
//                      });
//                })
              ],
            ),
          )
        ],
      ),
    );
  }
}