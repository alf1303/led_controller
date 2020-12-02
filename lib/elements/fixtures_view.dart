import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ledcontroller/elements/my_bottom_bar.dart';
import 'package:ledcontroller/model/esp_model.dart';
import 'package:ledcontroller/provider_model.dart';
import 'package:provider/provider.dart';
import 'package:ledcontroller/styles.dart';

import '../controller.dart';
import 'custom/fitted_text.dart';

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
              Container(
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
              )
        ),
            ],
          )
          )
        );
  }
}

class EspView extends StatefulWidget {
  final EspModel _espModel;
  const EspView(this._espModel);

  @override
  _EspViewState createState() => _EspViewState();
}

class _EspViewState extends State<EspView> {
  void _onTapFunction() {
    widget._espModel.selected = !widget._espModel.selected;
    Controller.providerModel.checkSelected();
    if(widget._espModel.selected) {
      Controller.setFaders(widget._espModel.ramSet);
    }
    if(Controller.highlite) {
      if (widget._espModel.selected) {
        Controller.setHighlite();
      }
      else {
        Controller.unsetHL(widget._espModel);
      }
    }
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    final BoxDecoration espViewDecoration = BoxDecoration(
        gradient: LinearGradient(
            colors: [
              (widget._espModel.selected) ?
              Colors.white : mainBackgroundColor.withOpacity(0.1),
              widget._espModel.selected ? mainBackgroundColor.withOpacity(1) : thirdBackgroundColor.withOpacity(1)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
        ),
        border: Border.all(color: (Controller.highlite && widget._espModel.selected) ? Colors.yellow : widget._espModel.selected ? Colors.white : Colors.grey, width: (Controller.highlite && widget._espModel.selected) ? 4 : widget._espModel.selected ? 3 : 2),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
              color: Colors.blueGrey,
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(1, 1)
          )
        ]
    );
    return GestureDetector(
      onTap: _onTapFunction,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: espViewDecoration,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("${widget._espModel.uni}"),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)
                        ),
                        child: DimmerWidget(widget._espModel.ramSet.dimmer)),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  //mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(child: ColorView(widget._espModel.ramSet.color, true)),
                    SizedBox(width: 2,),
                    Expanded(child: ColorView(widget._espModel.fsSet.color, false))
                  ],
                ),
              ),
              Expanded(child: FText(widget._espModel.name == null ? "empty" : widget._espModel.name, smallText,))
            ],
          ),
        ),
      ),
    );
  }
}

class DimmerWidget  extends StatelessWidget{
  final int dimmer;
  const DimmerWidget(this.dimmer);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: constraints.constrainWidth()*(dimmer*1.0/255),
              height: 2,
              color: Colors.white,
            ),
          );
        });
  }
}
 Widget ColorView(final Color color, final bool shape) {
  //print("ColorViewBuild ${k++}");
  return Container(
    //width: 30,
    decoration: BoxDecoration(
      color: color,
      shape: shape ? BoxShape.circle : BoxShape.rectangle,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          spreadRadius: 1,
          blurRadius: 2
        )
      ]
    ),
  );
}