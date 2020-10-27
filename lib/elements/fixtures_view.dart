import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ledcontroller/model/esp_model.dart';
import 'package:ledcontroller/provider_model.dart';
import 'package:provider/provider.dart';
import 'package:ledcontroller/styles.dart';

import '../controller.dart';

class FixturesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final model = Provider.of<ProviderModel>(context, listen: true);
    return Container(
        //color: espViewMainColor,
        child: Padding(
          padding: const EdgeInsets.only(left:5, right: 5, top: 18.0),
          child: Container(
            child: GridView.count(
              childAspectRatio: 0.9,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              //crossAxisCount: (MediaQuery.of(context).size.width/75).floor(),
                crossAxisCount: width > height ? 10 : 5 ,
            children: List.generate(model.list.length, (index) {
            return EspView(model.list[index]);
          })
          )
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
      Controller.setFaders(widget._espModel.ram_set);
    }
    if(Controller.highlite) {
      if (widget._espModel.selected) {
        Controller.setHighlite();
      }
      else {
        Controller.unsetHL(widget._espModel.uni);
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
              (Controller.highlite && widget._espModel.selected) ? Colors.white : widget._espModel.selected ? mainBackgroundColor : mainBackgroundColor.withOpacity(0.6),
              secondaryBackgroundColor.withOpacity(0.8)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
        ),
        border: Border.all(color: widget._espModel.selected ? Colors.white : Colors.black, width: widget._espModel.selected ? 2 : 1),
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
      child: Container(
        decoration: espViewDecoration,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        child: DimmerWidget(widget._espModel.ram_set.dimmer)),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  //mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(child: ColorView(widget._espModel.ram_set.color, true)),
                    SizedBox(width: 2,),
                    Expanded(child: ColorView(widget._espModel.fs_set.color, false))
                  ],
                ),
              )
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
int k = 0;
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
          spreadRadius: 3,
          blurRadius: 5
        )
      ]
    ),
  );
}