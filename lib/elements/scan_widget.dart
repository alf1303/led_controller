import 'package:flutter/material.dart';

import '../controller.dart';
import '../styles.dart';

class ScanWidget extends StatefulWidget{
  @override
  _ScanWidgetState createState() => _ScanWidgetState();
}

class _ScanWidgetState extends State<ScanWidget> {
  Future<void> futur;
  bool _isLoading = false;
  void onScanPressed() async{
    _isLoading = true;
    futur = Controller.scan();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futur,
        builder: (context, snapshot) {
          Widget child;
          if(snapshot.connectionState == ConnectionState.none) child = (RaisedButton(
              elevation: 10,
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text("Scan"),
              onPressed: onScanPressed
          ));
          if(snapshot.connectionState == ConnectionState.waiting) child = child = (RaisedButton(
              elevation: 10,
              child: Container(
                  padding: EdgeInsets.all(2),
                  child: FittedBox(fit: BoxFit.fitHeight, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(linesColor),))),
              onPressed: null
          ));
//        if(snapshot.connectionState == ConnectionState.active) child = child = (RaisedButton(
//            child: Text("Scan"),
//            onPressed: onScanPressed
//        ));
          if(snapshot.connectionState == ConnectionState.done) child = (RaisedButton(
              elevation: 10,
              child: Text("Scan"),
              onPressed: onScanPressed
          ));
          return child;
        });
  }
}