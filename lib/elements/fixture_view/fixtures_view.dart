import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ledcontroller/elements/buttons_bar/buttons_bar.dart';
import 'package:ledcontroller/provider_model.dart';
import 'package:provider/provider.dart';
import 'package:ledcontroller/styles.dart';

import 'esp_view.dart';

class FixturesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final model = Provider.of<ProviderModel>(context, listen: true);
    return Container(
        //decoration: secondaryDecoration,
      color: thirdBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(left:5, right: 5, top: 18.0),
          child: Column(
            children: [
              MyBottomBar(false),
              SizedBox(height: 5,),
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: GridView.count(
                      childAspectRatio: 0.9,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      padding: EdgeInsets.only(bottom: 5),
                      //crossAxisCount: (MediaQuery.of(context).size.width/75).floor(),
                        crossAxisCount: width > height ? 10 : 5 ,
                    children: List.generate(model.list.length, (index) {
                    return EspView(model.list[index]);
                })
                ),
                  )
        ),
              ),
            ],
          )
          )
        );
  }
}

