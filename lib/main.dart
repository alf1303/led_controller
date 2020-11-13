import 'package:flutter/material.dart';
import 'package:ledcontroller/elements/my_value_setter.dart';
import 'package:ledcontroller/palettes_provider.dart';
import 'package:ledcontroller/provider_model.dart';
import 'package:ledcontroller/provider_model_attribute.dart';
import 'package:ledcontroller/styles.dart';
import 'package:provider/provider.dart';

import 'controller.dart';
import 'elements/fixtures_view.dart';
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
  @override
  Widget build(BuildContext context) {
    double _winHeight = MediaQuery.of(context).size.height;
    double _winWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
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
    );
  }
}

class MyAppBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Text("LedController", style: headerText);
  }
}