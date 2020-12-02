import 'package:flutter/material.dart';
import 'package:ledcontroller/elements/my_value_setter.dart';
import 'package:ledcontroller/palettes_provider.dart';
import 'package:ledcontroller/provider_model.dart';
import 'package:ledcontroller/provider_model_attribute.dart';
import 'package:ledcontroller/styles.dart';
import 'package:ledcontroller/udp_controller.dart';
import 'package:provider/provider.dart';

import 'controller.dart';
import 'elements/fixtures_view.dart';
import 'elements/help_widget.dart';
import 'elements/my_bottom_bar.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Controller.fakeInit();
  await Controller.initPalettes();
  await Controller.initWiFi();
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        buttonTheme: mainButtonTheme.data,
      ),
      home: SafeArea(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<ProviderModel>(create: (_) => ProviderModel(),),
            ChangeNotifierProvider<ProviderModelAttribute>(create: (_) => ProviderModelAttribute(),),
            ChangeNotifierProvider<PaletteProvider>(create: (_) => PaletteProvider(),)
          ],
          child: Scaffold(
            body: MainPage(),
            bottomNavigationBar: MyBottomBar(),
          ),
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget{
  Future<void> futur;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double _winHeight = MediaQuery.of(context).size.height;
    double _winWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: mainDecoration,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ScanWidget(),
                      SettingsWidget(),
                      Text("LEDControl", style: headerText,),
                      IconButton(icon: Icon(Icons.help_outline, color: Colors.black), onPressed: () {
                        showDialog(
                            context: context,
                        builder: (context) {
                           return HelpWidget();
                        });
                      })
                    ],
                  ),
                )
              ],
            ),
          )
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
              height: _winHeight > _winWidth ? _winHeight + 50 : _winWidth + 50,
              //color: mainBackgroundColor,
              decoration: mainDecoration,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  MyValueSetter(),
                  Container(
                    height: 3,
                    color: dividerColor,
                  ),
                  Expanded(child: FixturesView())
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyAppBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Text("LedController", style: headerText);
  }
}

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
              shape: buttonShape,
              elevation: 10,
              child: Text("Scan"),
              onPressed: onScanPressed
          ));
          if(snapshot.connectionState == ConnectionState.waiting) child = child = (RaisedButton(
              color: mainBackgroundColor,
              splashColor: linesColor,
              child: Container(
                  padding: EdgeInsets.all(2),
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(linesColor),)),
              onPressed: null
          ));
//        if(snapshot.connectionState == ConnectionState.active) child = child = (RaisedButton(
//            child: Text("Scan"),
//            onPressed: onScanPressed
//        ));
          if(snapshot.connectionState == ConnectionState.done) child = (RaisedButton(
              shape: RoundedRectangleBorder(side: BorderSide(color: linesColor), borderRadius: BorderRadius.circular(6)),
              child: Text("Scan"),
              onPressed: onScanPressed
          ));
          return child;
        });
  }
}


