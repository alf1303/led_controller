import 'package:flutter/material.dart';
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
import 'elements/my_value_setter.dart';
import 'elements/settings_widget.dart';

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
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                flexibleSpace: Container(decoration: secondaryDecoration,),
                  title: MyAppBar(),
                  bottom: TabBar(
                    labelColor: mainBackgroundColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: EdgeInsets.all(0),
                    indicator: BoxDecoration(
                        color: thirdBackgroundColor,
                        border: Border.all(color: thirdBackgroundColor),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)
                        )),
                    tabs: [
                      Tab(child: Text("Fixtures List", style: mainText,)),
                      Tab(child: Text("Color Editor", style: mainText,)),
                      Tab(child: Text("PLAYBACK", style: mainText,)),
                    ],),
              ),
              body: TabMainPage(),
              //bottomNavigationBar: MyBottomBar(),
            ),
          ),
        ),
      ),
    );
  }
}

class TabMainPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return TabBarView(
        children: [
          FixturesView(),
          MyValueSetter(),
          Text("Playback")
        ]);
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("LEDController", style: headerText,),
                SettingsWidget(),
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
    );
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


