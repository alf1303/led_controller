import 'package:flutter/material.dart';
import 'package:ledcontroller/palettes_provider.dart';
import 'package:ledcontroller/provider_model.dart';
import 'package:ledcontroller/provider_model_attribute.dart';
import 'package:ledcontroller/styles.dart';
import 'package:provider/provider.dart';

import 'controller.dart';
import 'elements/value_setter/my_value_setter.dart';
import 'elements/playback_view.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //await Controller.fakeInit();
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
    Future.delayed(Duration(seconds: 2), () {
      Controller.scan();
    });
    final _tabController = TabController(length: 2, vsync: this);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProviderModel>(create: (_) => ProviderModel(),),
        ChangeNotifierProvider<ProviderModelAttribute>(create: (_) => ProviderModelAttribute(),),
        ChangeNotifierProvider<PaletteProvider>(create: (_) => PaletteProvider(),)
      ],
      child: MaterialApp(
        theme: ThemeData(
          buttonTheme: mainButtonTheme.data,
          cardColor: secondaryBackgroundColor.withOpacity(0.4),
          backgroundColor: thirdBackgroundColor
        ),
        home: SafeArea(
            child: Scaffold(
              body: TabMainPage(_tabController),
              //bottomNavigationBar: SimpleFixtureView(),
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
          MyValueSetter(_tabController),
          PlaybackView(_tabController)
          //Text("")
        ]);
  }
}



