import 'package:flutter/material.dart';
import 'package:ledcontroller/model/esp_model.dart';

import '../../controller.dart';
import '../../styles.dart';
import 'color_view_widget.dart';
import 'dimmer_widget.dart';

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
    final highlited = Controller.highlite;
    final selected = widget._espModel.selected;
    final BoxDecoration espViewDecoration = BoxDecoration(
        gradient: LinearGradient(
            colors: [
              (selected) ? Colors.white : mainBackgroundColor.withOpacity(0.1),
              (selected) ? mainBackgroundColor.withOpacity(1) :  thirdBackgroundColor.withOpacity(1)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
        ),
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
              Expanded(child: FittedBox(fit: BoxFit.scaleDown, child: Text(widget._espModel.name == null ? "empty" : widget._espModel.name, style: smallText,)))
            ],
          ),
        ),
      ),
    );
  }
}