import 'package:flutter/material.dart';
import 'package:ledcontroller/elements/fixture_view/dimmer_widget.dart';
import 'package:ledcontroller/model/esp_model.dart';
import 'package:ledcontroller/styles.dart';

import '../../controller.dart';
import 'color_view_widget.dart';

class SimpleEspView extends StatefulWidget {
  final EspModel _espModel;
  const SimpleEspView(this._espModel);

  @override
  _SimpleEspViewState createState() => _SimpleEspViewState();
}

class _SimpleEspViewState extends State<SimpleEspView> {

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
    final highlited = Controller.highlite;
    final selected = widget._espModel.selected;
    final BoxDecoration espViewDecoration = BoxDecoration(
        border: Border.all(color: (highlited && selected) ? selectedLinesColor : (selected) ? Colors.pinkAccent.shade200 : Colors.white, width: (highlited && selected) ? 5 : selected ? 3 : 2),
        borderRadius: BorderRadius.circular(6),
        color: selected ? mainBackgroundColor : Colors.blueGrey,
        gradient: LinearGradient(
          colors: [
            selected ? Colors.white : Colors.grey,
            selected ? Colors.white : mainBackgroundColor
          ],
          tileMode: TileMode.mirror,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.blueGrey,
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(1, 1)
          )
        ]
    );

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: _onTapFunction,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: espViewDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //DimmerWidget(widget._espModel.ramSet.dimmer),
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: FittedBox(fit: BoxFit.fitHeight, child: Text("${widget._espModel.uni}", style: smallText.copyWith(color: selected ? Colors.black : Colors.white),))),
                    //SizedBox(width: 2,),
                    Expanded(child: ColorView(widget._espModel.ramSet.color, true)),
                  ],
                ),
              ),
              Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: FittedBox(fit: BoxFit.scaleDown, child: Text(widget._espModel.name == null ? "name${widget._espModel.uni}" : widget._espModel.name, style: smallText.copyWith( fontSize: 30, color: selected ? Colors.black : Colors.black),)),
              ))
            ],
          ),
        ),
      ),
    );
  }
}