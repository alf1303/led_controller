import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:invert_colors/invert_colors.dart';
import 'package:ledcontroller/controller.dart';
import 'package:ledcontroller/model/palette.dart';
import 'package:ledcontroller/model/palette_types.dart';
import 'package:ledcontroller/styles.dart';
import 'package:provider/provider.dart';
import '../palettes_provider.dart';
import 'package:shimmer/shimmer.dart';

class PaletteViewer extends StatelessWidget {
  final bool isPalette;

  const PaletteViewer(this.isPalette);

  @override
  Widget build(BuildContext context) {
    final paletteProvider = Provider.of<PaletteProvider>(context, listen: true);
    List<Palette> list = isPalette ? paletteProvider.getPalettes() : paletteProvider.getProgramms();
    //print(list.length);
    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: GridView.count(
          cacheExtent: 100,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            mainAxisSpacing: 3,
            childAspectRatio: 1.3,
            children: List.generate(list.length, (index) => ViewPaletteItem(list[index])),
            crossAxisCount: 1),
      ),
    );
  }
}

class ViewPaletteItem extends StatefulWidget{
final Palette _palette;

const ViewPaletteItem(this._palette);

  @override
  _ViewPaletteItemState createState() => _ViewPaletteItemState();
}

class _ViewPaletteItemState extends State<ViewPaletteItem> with TickerProviderStateMixin {
var _tapPosition;
double radiusPal = 24;
bool index = false;

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
  //print("palettesCount: ${paletteProvider.list.length}");
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    print("PaletteItem, width: $width, height: $height");
    final double iconSize = height > width ? (width/25) : (height/25);
    final paletteProvider = Provider.of<PaletteProvider>(context, listen: true);
    bool isPalette = widget._palette.paletteType == PaletteType.PALETTE;
    bool selected = widget._palette.selected == null ? false : widget._palette.selected;
    Color colorPal = widget._palette.getColor();
    String label = widget._palette.getLabel();
    double rPalSelected = width/30;
    double rPal = width/15;
    List<double> paletteRadiuses = [rPalSelected, rPal];
    int indexPal = 0;

    //print(colorPal);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        child: Column(
          children: <Widget>[
            //Text(isPalette ? "Palette" : "Program"),
            Expanded(
              flex: 7,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 1000),

                onEnd: () {
                  setState(() {
                    indexPal = (indexPal + 1);
                  });
                },
                decoration: isPalette ? BoxDecoration(border: Border.all(color: Colors.grey, width: selected ? 4 : 0), color: colorPal, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(selected ? paletteRadiuses[indexPal%2] : rPal)) :
                  BoxDecoration(border: Border.all(color: Colors.grey, width: selected ? 4 : 0), borderRadius: BorderRadius.circular(8), shape: BoxShape.rectangle, gradient: colorPal != emptyPaletteColor ? LinearGradient(
                      colors: [Colors.cyanAccent, Colors.amber, Colors.pink,],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight) : LinearGradient(colors: [Colors.grey, Colors.grey]),
                  ),
                child: Material(
                  //clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(side: BorderSide(color: Colors.transparent, width: 0), borderRadius: BorderRadius.all(Radius.circular(isPalette ? 20 : 5))),
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
                      if (widget._palette.isNotEmpty()) {
                        Controller.loadPalette(widget._palette);
                        Controller.setSendWithoutUpdate(128);
                        isPalette ? paletteProvider.deselectPalettes() : paletteProvider.deselectPrograms();
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
            SizedBox(height: 1,),
            Expanded(
                flex: 2,
                child: SizedBox(height: 12,child: Text(widget._palette.name, style: smallText.copyWith(fontSize: 12)))
            )
          ],
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
  final double height = 100;

  @override
  bool represents(int value) => value == 1 || value == -1;
}

class MyPaletteEntryState extends State<MyPaletteEntry> {
  void save() {
    if (!Controller.areNotSelected()) {
      Controller.savePalette(widget._palette);
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
        backgroundColor: thirdBackgroundColor.withOpacity(0.8),
        content: Form(
          key: _formKey67,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: inputDecoration,
                  controller: _nameController,
                  validator: (value) {
                    if(value.length > 10) return "<10";
                    return null;
                  },
                ),
              ),
              IconButton(icon: Icon(Icons.save, size: 40,), onPressed: () {
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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RaisedButton(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,shape: buttonShape, onPressed: save, color: buttonColor.withOpacity(0.9), child: Text("Save"),),
        SizedBox(height: 2,),
        RaisedButton(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, shape: buttonShape, onPressed: clear, color: buttonColor.withOpacity(0.9), child: Text("Clear"),),
        SizedBox(height: 2,),
        RaisedButton(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,shape: buttonShape, onPressed: rename, color: buttonColor.withOpacity(0.9), child: Text("Rename"),),
        SizedBox(height: 2,),
        Visibility(
            child:
            RaisedButton(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, shape: buttonShape, onPressed: add, color: buttonColor.withOpacity(0.9), child: Text("Playlist +"),),
        visible: widget._palette.canAdd(),
        ),
        SizedBox(height: 2,),
        Visibility(
          child:
          RaisedButton(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, shape: buttonShape, onPressed: remove, color: buttonColor.withOpacity(0.9), child: Text("Playlist -", style: TextStyle(color: Colors.red),),),
          visible: widget._palette.canRemove(),
        ),
      ],
    );
  }
}