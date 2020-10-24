import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ledcontroller/controller.dart';
import 'package:ledcontroller/model/palette.dart';
import 'package:ledcontroller/model/palette_types.dart';
import 'package:provider/provider.dart';

import '../palettes_provider.dart';

class PaletteViewer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final paletteProvider = Provider.of<PaletteProvider>(context, listen: true);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: GridView.count(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          mainAxisSpacing: 3,
          childAspectRatio: 1,
          children: List.generate(paletteProvider.list.length, (index) => ViewPaletteItem(paletteProvider.list[index])),
          crossAxisCount: 1),
    );
  }
}

class ViewPaletteItem extends StatefulWidget{
final Palette _palette;
ViewPaletteItem(this._palette);

  @override
  _ViewPaletteItemState createState() => _ViewPaletteItemState();
}

class _ViewPaletteItemState extends State<ViewPaletteItem> {
var _tapPosition;
var _count;

void _showCustomMenu() {
  final RenderBox overlay = Overlay.of(context).context.findRenderObject();

  showMenu(
      context: context,
      items: <PopupMenuEntry<int>>[MyPaletteEntry(widget._palette)],
      position: RelativeRect.fromRect(
          _tapPosition & const Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size   // Bigger rect, the entire screen
      )
  )
  // This is how you handle user selection
      .then<void>((int delta) {
    // delta would be null if user taps on outside the popup menu
    // (causing it to close without making selection)
    if (delta == null) return;

    setState(() {
      _count = _count + delta;
    });
  });

  // Another option:
  //
  // final delta = await showMenu(...);
  //
  // Then process `delta` however you want.
  // Remember to make the surrounding function `async`, that is:
  //
  // void _showCustomMenu() async { ... }
}

void _storePosition(TapDownDetails details) {
  _tapPosition = details.globalPosition;
}

  @override
  Widget build(BuildContext context) {
    bool isPalette = widget._palette.paletteType == PaletteType.PALETTE;
    Color colorPal = widget._palette.getColor();
    //print(color);
    return GestureDetector(
      onTap: () {
        Controller.loadPalette(widget._palette);
        },
      onLongPress: () {
        _showCustomMenu();
      },
      onTapDown: _storePosition,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          child: Column(
            children: <Widget>[
              //Text(isPalette ? "Palette" : "Program"),
              Expanded(
                child: Container(
                  decoration: isPalette ? BoxDecoration(border: Border.all(color: Colors.blueGrey), color: colorPal, shape: BoxShape.circle) :
                    BoxDecoration(border: Border.all(color: Colors.blueGrey), shape: BoxShape.rectangle, gradient: colorPal != Colors.transparent? LinearGradient(
                        colors: [Colors.cyanAccent, Colors.amber, Colors.pink,],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight) : null
                    ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyPaletteEntry extends PopupMenuEntry<int>{
  final Palette _palette;

  MyPaletteEntry(this._palette);


  @override
  MyPaletteEntryState createState() {
    return MyPaletteEntryState();
  }

  @override
  double height = 100;

  @override
  bool represents(int value) => value == 1 || value == -1;
}

class MyPaletteEntryState extends State<MyPaletteEntry> {
  void save() {
    Controller.savePalette(widget._palette);
    Navigator.pop(context);
  }

  void clear() {
    Controller.clearPalette(widget._palette);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          FlatButton(onPressed: save, color: Colors.transparent, child: Text("Save"),),
          FlatButton(onPressed: clear, child: Text("Clear"),)
        ],
      ),
    );
  }
}