import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ledcontroller/elements/buttons_bar/buttons_bar.dart';
import 'package:ledcontroller/elements/fixture_view/simple_esp_view.dart';
import 'package:ledcontroller/styles.dart';
import 'package:provider/provider.dart';
import 'package:ledcontroller/provider_model.dart';

class SimpleFixtureView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final model = Provider.of<ProviderModel>(context, listen: true);
    //print("SimpleFixture, h: $height, w: $width");
    return Container(
      padding: EdgeInsets.all(3),
      color: thirdBackgroundColor,
      child: Column(
        children: [
          SizedBox(height: 3,),
          Expanded(child: SingleChildScrollView(
            child: GridView.count(
           // scrollDirection: Axis.horizontal,
            childAspectRatio: 1.4,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            crossAxisCount: model.list.length < 4 ? 3 : model.list.length == 4 ? 4 : 5,
            children: List.generate(model.list.length, (index) {
              return SimpleEspView(model.list[index]);
            }),
          ),
          ),
          ),
          MyBottomBar(false),
        ],
      ),
    );
  }
}