import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:ledcontroller/elements/scan_widget.dart';
import 'package:provider/provider.dart';

import '../controller.dart';
import '../global_keys.dart';
import '../provider_model.dart';
import '../styles.dart';
import 'help/help_widget.dart';

class MyAppBar extends StatelessWidget{
  final TabController _tabController;

  const MyAppBar(this._tabController);

  void onSavePressed() {
    if(Controller.providerModel.list != null) {
      Controller.setSend(255);
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerModer = Provider.of<ProviderModel>(context, listen: true);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final iconSize = height > width ? 0.04*height : 0.04 * width;
    return  SizedBox(
      width: MediaQuery.of(context).size.width,
      height: height > width ? 0.045*height : 0.045 * width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              flex: 2,
              child: ScanWidget(thirdBackgroundColor)),
          Expanded(
            flex: 5,
            child: Center(
              child: GestureDetector(
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: alertShape,
                            backgroundColor: alertBackgroundColor,
                            content: Text("Insert virtual fixtures?", style: mainWhiteText,),
                            actions: [
                              IconButton(icon: Icon(Icons.check, color: Colors.white), onPressed: () {
                                Controller.fakeInit();
                                Navigator.pop(context);
                              })
                            ],
                          );
                        }
                    );
                  },
                  child: FittedBox(fit: BoxFit.fitHeight, child: Text("LEDControll", style: headerText,))),
            ),
          ),
          Expanded(
            flex: 2,
            child: RaisedButton(
                key: saveKey,
                color: thirdBackgroundColor,
                elevation: 5,
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: FittedBox(fit: BoxFit.fitHeight, child: Icon(Icons.save, size: 40,)),
                //child: FittedBox(fit: BoxFit.scaleDown, child: Text("Save To Device"),),
                onPressed: Controller.areNotSelected() ? null : onSavePressed
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox( width: 100,
              child: RaisedButton(
                  key: playbackKey,
                  color: thirdBackgroundColor,
                  elevation: 5,
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  //child: Icon(Icons.save, size: 24,),
                  child: FittedBox(fit: BoxFit.fitHeight, child: Icon(Icons.play_circle_outline, size: 40,)),
                  onPressed: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => PlaybackView()));
                    _tabController.animateTo(1);
                  },
              ),
            ),
          ),
          HelpWidget(iconSize)
        ],
      ),
    );
  }
}