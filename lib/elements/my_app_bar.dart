import 'package:flutter/material.dart';
import 'package:ledcontroller/elements/scan_widget.dart';
import 'package:provider/provider.dart';

import '../controller.dart';
import '../provider_model.dart';
import '../styles.dart';

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
    return  SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              flex: 2,
              child: ScanWidget()),
          Expanded(
            flex: 5,
            child: GestureDetector(
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
                child: Text("LEDControl", style: headerText,)),
          ),
          RaisedButton(
              elevation: 5,
              padding: EdgeInsets.symmetric(horizontal: 6),
              //child: Icon(Icons.save, size: 24,),
              child: FittedBox(fit: BoxFit.scaleDown, child: Text("Save To Device"),),
              onPressed: Controller.areNotSelected() ? null : onSavePressed
          ),
          Expanded(
            flex: 2,
            child: SizedBox( width: 100,
              child: RaisedButton(
                  elevation: 5,
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  //child: Icon(Icons.save, size: 24,),
                  child: Icon(Icons.play_circle_outline),
                  onPressed: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => PlaybackView()));
                    _tabController.animateTo(1);
                  }
              ),
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
    );
  }
}