import 'package:flutter/material.dart';
import 'package:invert_colors/invert_colors.dart';
import 'package:ledcontroller/global_keys.dart';
import 'package:ledcontroller/model/palette_types.dart';
import 'package:provider/provider.dart';
import '../../controller.dart';
import '../../palettes_provider.dart';
import 'package:ledcontroller/model/palette.dart';

import '../../styles.dart';

class PaletteViewer extends StatelessWidget {
//final double height;
//const PaletteViewer(this.height);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    //print("paletteViewer, h: $height, w: $width");
    final paletteProvider = Provider.of<PaletteProvider>(context, listen: true);
    List<Palette> palettes = paletteProvider.getPalettes();
    List<Palette> programs = paletteProvider.getProgramms();
    //print("palLength: ${palettes.length}, progLength: ${programs.length}, allLength: ${paletteProvider.list.length}");
    return Container(
      //color: Colors.yellow,
      decoration: BoxDecoration(
        //color: Colors.yellow,
        //border: Border.all(),
        //borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            key: palettesKey,
            child: Scrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: GridView.count(
                    scrollDirection: Axis.horizontal,
                    crossAxisCount: 1,
                    shrinkWrap: true,
                    childAspectRatio: 1.3,
                    mainAxisSpacing: 6,
                    children: List.generate(palettes.length, (index) => ViewPalette(palettes[index])),
                  )
                )
            ),
          ),
          SizedBox(height: 5,),
          Expanded(
            child: Container(
              key: programsKey,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                //color: palBackColor
              ),
              child: Scrollbar(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: GridView.count(
                        scrollDirection: Axis.horizontal,
                        crossAxisCount: 1,
                        shrinkWrap: true,
                        childAspectRatio: 1.3,
                        mainAxisSpacing: 6,
                        children: List.generate(programs.length, (index) => ViewPrograms(programs[index])),
                      )
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ViewPalette extends StatefulWidget{
final Palette _palette;

const ViewPalette(this._palette);
  @override
  _ViewPaletteState createState() => _ViewPaletteState();
}
class _ViewPaletteState extends State<ViewPalette> {
  var _tapPosition;

  void _showCustomMenu() {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    showMenu(
        context: context,
        color: Colors.transparent,
        //shape: Border.all(color: secondaryBackgroundColor),
        elevation: 0,
        items: <PopupMenuEntry<void>>[MyPaletteEntry(widget._palette)],
        position: RelativeRect.fromRect(
            _tapPosition & const Size(40, 40), // smaller rect, the touch area
            Offset.zero & overlay.size   // Bigger rect, the entire screen
        )
    )
    // This is how you handle user selection
        .then<void>((void g) {
      // delta would be null if user taps on outside the popup menu
      // (causing it to close without making selection)

      setState(() { });
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
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    double radius = width/12;
    final paletteProvider = Provider.of<PaletteProvider>(context, listen: false);
    //print("PaletteItem, width: $width, height: $height");
    final double iconSize = height > width ? (width/25) : (height/25);
    Color colorPal = widget._palette.getColor();
    String label = widget._palette.getLabel();
    bool selected = widget._palette.selected;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              decoration: BoxDecoration(
                //boxShadow: [selected ? boxShadow2 : boxShadow1],
                color: colorPal,
                border: Border.all(color: selected ? Colors.blueGrey : Colors.grey, width: selected ? 6 : 2),
                borderRadius: BorderRadius.circular(selected ? radius/3 : radius)
              ),
              child: Material(
                //clipBehavior: Clip.hardEdge,
                //shape:RoundedRectangleBorder(side: BorderSide(color: Colors.transparent, width: 0), borderRadius: BorderRadius.all(Radius.circular(selected ? radius/3 : radius))),
                color: Colors.transparent,
                child: InkWell(
                  child: Center(child: Column(
                    children: <Widget>[
                      SizedBox(height: 6),
                      InvertColors(child: Text(label, style: smallText.copyWith(fontSize: iconSize/1.6, color: widget._palette.settings.isNotEmpty ? widget._palette.settings[0].settings.fxColor : Colors.white),)),
                      Visibility(
                          visible: widget._palette.playlistItem,
                          child: InvertColors(child: Icon(Icons.play_circle_outline, size: iconSize, color: widget._palette.settings.isNotEmpty ? widget._palette.settings[0].settings.color : Colors.white,)))
                    ],
                  )),
                  splashColor: mainBackgroundColor,
                  onTap: () {
                    if(Controller.areNotSelected()) {
                      final snackBar = SnackBar(
                        content: Text("Fixtures are not selected!"),
                        duration: Duration(seconds: 2),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                    }
                    else {
                      if (widget._palette.isNotEmpty()) {
                        Controller.loadPalette(widget._palette);
                        Controller.setSendWithoutUpdate(128);
                        paletteProvider.deselectPalettes();
                        setState(() {
                          widget._palette.selected = true;
                        });
                      }
                    }
                  },
                  onLongPress: () {
                    _showCustomMenu();
                  },
                  onTapDown: _storePosition,
                ),
              ),
            ),
          ),
          SizedBox(height: 1,),
          Expanded(
              flex: 2,
              child: FittedBox(fit: BoxFit.fill,child: Text(widget._palette.name)))
        ],
      ),
    );
  }
}

class ViewPrograms extends StatefulWidget{
  final Palette _palette;

  const ViewPrograms(this._palette);
  @override
  _ViewProgramsState createState() => _ViewProgramsState();
}
class _ViewProgramsState extends State<ViewPrograms> {
  var _tapPosition;

  void _showCustomMenu() {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    //print(overlay.size.width);
    showMenu(
        context: context,
        color: Colors.transparent,
        //shape: Border.all(color: secondaryBackgroundColor),
        elevation: 0,
        items: <PopupMenuEntry<void>>[MyPaletteEntry(widget._palette)],
        position: RelativeRect.fromRect(
            _tapPosition & const Size(40, 40), // smaller rect, the touch area
            Offset.zero & overlay.size   // Bigger rect, the entire screen
        ),
    )
    // This is how you handle user selection
        .then<void>((void g) {
      // delta would be null if user taps on outside the popup menu
      // (causing it to close without making selection)

      setState(() { });
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
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    double radius = width/50;
    final paletteProvider = Provider.of<PaletteProvider>(context, listen: false);
    //print("PaletteItem, width: $width, height: $height");
    Color colorPal = widget._palette.getColor();
    String label = widget._palette.getLabel();
    bool selected = widget._palette.selected;
    List<Color> colors = [Colors.cyanAccent, Colors.amber, Colors.pink,];
    List<Color> colors2 = [Colors.cyanAccent, Colors.white, Colors.pink,];

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              decoration: BoxDecoration(
                  border: Border.all(color: mainBackgroundColor, width: selected ? 6 : 2), borderRadius: BorderRadius.circular(10), shape: BoxShape.rectangle
              ),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                decoration: BoxDecoration(
                  //boxShadow: [selected ? boxShadow2 : boxShadow1],
                    border: Border.all(color: selected ? Colors.blueGrey : Colors.grey, width: selected ? 4 : 2), borderRadius: BorderRadius.circular(10),
                    gradient: colorPal != emptyPaletteColor ? LinearGradient(
                    colors: selected ? colors2 : colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight) : LinearGradient(colors: [Colors.grey, Colors.grey]),
                ),
                child: Material(
                  //clipBehavior: Clip.hardEdge,
                  //shape:RoundedRectangleBorder(side: BorderSide(color: Colors.transparent, width: 0), borderRadius: BorderRadius.all(Radius.circular(selected ? radius/3 : radius))),
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: mainBackgroundColor,
                    onTap: () {
                      if (widget._palette.isNotEmpty()) {
                        Controller.loadPalette(widget._palette);
                        Controller.setSendWithoutUpdate(128);
                        paletteProvider.deselectPrograms();
                        setState(() {
                          widget._palette.selected = true;
                        });
                      }
                    },
                    onLongPress: () {
                      _showCustomMenu();
                    },
                    onTapDown: _storePosition,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 1,),
          Expanded(
              flex: 2,
              child: FittedBox(fit: BoxFit.fill,child: Text(widget._palette.name)))
        ],
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
  final double height = 100;

  @override
  bool represents(int value) => value == 1 || value == -1;
}

class MyPaletteEntryState extends State<MyPaletteEntry> {
  final butCol = thirdBackgroundColor;
  void save() {
    if(widget._palette.paletteType == PaletteType.PROGRAM) {
      Controller.savePalette(widget._palette);
    }
    else {
      if (!Controller.areNotSelected()) {
        Controller.savePalette(widget._palette);
      }
    }

    Navigator.pop(context);
  }

  void clear() {
    Controller.clearPalette(widget._palette);
    Navigator.pop(context);
  }

  void add() {
    Controller.addPaletteToPlaylist(widget._palette);
    Navigator.pop(context);
  }

  void remove() {
    Controller.removePaletteFromPlaylist(widget._palette);
    Navigator.pop(context);
  }

  void rename() {
    final _formKey67 = GlobalKey<FormState>();
    showDialog(context: context,
        builder: (context) {
          TextEditingController _nameController = TextEditingController();
          _nameController.text = widget._palette.name;
          return AlertDialog(
            shape: alertShape,
            backgroundColor: alertBackgroundColor,
            title: Text("Palette name:", style: mainWhiteText,),
            content: Form(
              key: _formKey67,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: mainBackgroundColor.withOpacity(0.8),
                      child: TextFormField(
                        decoration: inputDecoration,
                        controller: _nameController,
                        validator: (value) {
                          if(value.length > 10) return "<10";
                          return null;
                        },
                      ),
                    ),
                  ),
                  IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.save, size: 40, color: Colors.white,), onPressed: () {
                    if(_formKey67.currentState.validate()) {
                      widget._palette.name = _nameController.text;
                      Navigator.pop(context);
                    }
                  })
                ],
              ),
            ),
          );
        }).then((value) => Navigator.pop(context));
    //Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RaisedButton(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,shape: buttonShape, onPressed: save, color: butCol.withOpacity(0.9), child: Text("    Save   "),),
        SizedBox(height: 1,),
        RaisedButton(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, shape: buttonShape, onPressed: clear, color: butCol.withOpacity(0.9), child: Text("   Clear   "),),
        SizedBox(height: 1,),
        RaisedButton(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,shape: buttonShape, onPressed: rename, color: butCol.withOpacity(0.9), child: Text(" Rename"),),
        SizedBox(height: 1,),
        Visibility(
          child:
          RaisedButton(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, shape: buttonShape, onPressed: add, color: butCol.withOpacity(0.9), child: Text("Playlist +"),),
          visible: widget._palette.canAdd(),
        ),
        SizedBox(height: 1,),
        Visibility(
          child:
          RaisedButton(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, shape: buttonShape, onPressed: remove, color: butCol.withOpacity(0.9), child: Text("Playlist -", style: TextStyle(color: Colors.red),),),
          visible: widget._palette.canRemove(),
        ),
      ],
    );
  }
}