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
        border: Border.all(color: (highlited && selected) ? selectedLinesColor : (selected) ? selectedColor : Colors.grey, width: (selected) ? 4 : 2),
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
        child: Column(
          children: [
            DimmerWidget(widget._espModel.ramSet.dimmer),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: FittedBox(fit: BoxFit.scaleDown, child: Text("${widget._espModel.uni}", style: smallText,))),
                  //SizedBox(width: 2,),
                  Expanded(child: ColorView(widget._espModel.ramSet.color, true)),
                ],
              ),
            ),
            Expanded(child: FittedBox(fit: BoxFit.scaleDown, child: Text(widget._espModel.name == null ? "empty" : widget._espModel.name, style: smallText,)))
          ],
        ),
      ),
    );
  }
}