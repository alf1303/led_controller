import 'package:flutter/material.dart';
import 'package:ledcontroller/elements/scan_widget.dart';

import '../controller.dart';
import '../styles.dart';

class MyAppBar extends StatelessWidget{
  final _tabController;

  const MyAppBar(this._tabController);

  void onSavePressed() {
    if(Controller.providerModel.list != null) {
      Controller.setSend(255);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 40,
      child: CustomScrollView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ScanWidget(_tabController),
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
                    child: Text("LEDController", style: headerText,)),
                RaisedButton(
                    elevation: 5,
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    //child: Icon(Icons.save, size: 24,),
                    child: FittedBox(fit: BoxFit.scaleDown, child: Text("Save To Device"),),
                    onPressed: onSavePressed
                )
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