import 'package:flutter/material.dart';
import 'package:ledcontroller/palettes_provider.dart';
import 'package:ledcontroller/provider_model.dart';
import 'package:ledcontroller/provider_model_attribute.dart';
import 'package:ledcontroller/styles.dart';
import 'package:ledcontroller/udp_controller.dart';
import 'package:provider/provider.dart';

import 'controller.dart';
import 'elements/custom/fitted_text.dart';
import 'elements/fixtures_view.dart';
import 'elements/help_widget.dart';
import 'elements/my_bottom_bar.dart';
import 'elements/my_value_setter.dart';
import 'elements/playback_view.dart';
import 'elements/settings_widget.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 // await Controller.fakeInit();
  await Controller.initPalettes();
  await Controller.initWiFi();
  runApp(Main());
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final _tabController = TabController(length: 3, vsync: this);
    Future.delayed(Duration(seconds: 2), () {
      Controller.scan();
    });
    return MaterialApp(
      theme: ThemeData(
        buttonTheme: mainButtonTheme.data,
        cardColor: secondaryBackgroundColor.withOpacity(0.4)
      ),
      home: SafeArea(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<ProviderModel>(create: (_) => ProviderModel(),),
            ChangeNotifierProvider<ProviderModelAttribute>(create: (_) => ProviderModelAttribute(),),
            ChangeNotifierProvider<PaletteProvider>(create: (_) => PaletteProvider(),)
          ],
          child: Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    thirdBackgroundColor,
                    mainBackgroundColor,
                  ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                )
              ),),
                title: MyAppBar(_tabController),
                bottom: TabBar(
                  controller: _tabController,
                  labelColor: mainBackgroundColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.all(0),
                  indicator: BoxDecoration(
                      color: thirdBackgroundColor,
                      border: Border(top: BorderSide(color: Colors.grey, width: 1),
                        left: BorderSide(color: Colors.grey, width: 1),
                        right: BorderSide(color: Colors.grey, width: 1),
                        bottom: BorderSide(color: Colors.grey, width: 1),),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)
                      )),
                  tabs: [
                    Tab(child: FText("Fixtures List")),
                    Tab(child: FText("Color Editor")),
                    Tab(child: FText("PLAYBACK")),
                  ],),
            ),
            body: TabMainPage(_tabController),
            //bottomNavigationBar: MyBottomBar(),
          ),
        ),
      ),
    );
  }
}

class TabMainPage extends StatelessWidget{
  final _tabController;

  TabMainPage(this._tabController);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: _tabController,
        children: [
          FixturesView(),
          MyValueSetter(),
          PlaybackView()
          //Text("")
        ]);
  }
}


class MyAppBar extends StatelessWidget{
  final _tabController;

  const MyAppBar(this._tabController);

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
                SettingsWidget(),
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

class ScanWidget extends StatefulWidget{
  TabController _tabController;

  ScanWidget(this._tabController);

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
    widget._tabController.animateTo(0);
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
            elevation: 10,
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


