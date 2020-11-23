import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ledcontroller/controller.dart';
import 'package:ledcontroller/model/palette.dart';
import 'package:ledcontroller/model/palette_types.dart';
import 'package:ledcontroller/styles.dart';
import 'package:provider/provider.dart';
import '../palettes_provider.dart';

class PaletteViewer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final paletteProvider = Provider.of<PaletteProvider>(context, listen: true);
    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: GridView.count(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            mainAxisSpacing: 3,
            childAspectRatio: 1,
            children: List.generate(paletteProvider.list.length, (index) => ViewPaletteItem(paletteProvider.list[index])),
            crossAxisCount: 1),
      ),
    );
  }
}

class ViewPaletteItem extends StatefulWidget{
final Palette _palette;
ViewPaletteItem(this._palette);

  @override
  _ViewPaletteItemState createState() => _ViewPaletteItemState();
}

class _ViewPaletteItemState extends State<ViewPaletteItem> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  bool _allowResetanimation = true;
var _tapPosition;

  @override
  void initState() {
    super.initState();
            //Animating pallete element on pressing
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),lowerBound: 0.65,
      vsync: this,
    )..addListener(() {
      if(_controller.status == AnimationStatus.completed && _allowResetanimation) _controller.reset();
    });
    _animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
  }

        //allow pallete item to resize to default size after resizing on long press
  void resetAllowAnimation(bool val) {
    _allowResetanimation = val;
    _controller.animateTo(0.65);
    setState(() {  });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _showCustomMenu() {
  final RenderBox overlay = Overlay.of(context).context.findRenderObject();

  showMenu(
      context: context,
      color: mainBackgroundColor.withOpacity(0),
      //shape: Border.all(color: secondaryBackgroundColor),
      elevation: 10,
      items: <PopupMenuEntry<void>>[MyPaletteEntry(widget._palette, resetAllowAnimation)],
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
    final paletteProvider = Provider.of<PaletteProvider>(context, listen: true);
    bool isPalette = widget._palette.paletteType == PaletteType.PALETTE;
    Color colorPal = widget._palette.getColor();
    String label = widget._palette.getLabel();
    //print(colorPal);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          child: Column(
            children: <Widget>[
              //Text(isPalette ? "Palette" : "Program"),
              Expanded(
                child: Container(
                  decoration: isPalette ? BoxDecoration(border: Border.all(color: Colors.transparent, width: 0), color: colorPal, shape: BoxShape.circle, boxShadow: [
                    BoxShadow(color: mainBackgroundColor, spreadRadius: 2, blurRadius: 4)]) :
                    BoxDecoration(border: Border.all(color: Colors.transparent, width: 0), borderRadius: BorderRadius.circular(8), shape: BoxShape.rectangle, gradient: colorPal != emptyPaletteColor ? LinearGradient(
                        colors: [Colors.cyanAccent, Colors.amber, Colors.pink,],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight) : LinearGradient(colors: [Colors.grey.withOpacity(0.7), Colors.grey.withOpacity(0.7)]),
                      boxShadow: [
                        BoxShadow(color: mainBackgroundColor, spreadRadius: 2, blurRadius: 4)
                      ]
                    ),
                  child: Material(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(side: BorderSide(color: Colors.transparent, width: 0), borderRadius: BorderRadius.all(Radius.circular(isPalette ? 20 : 5))),
                    color: Colors.transparent,
                    child: InkWell(
                      child: Center(child: Column(
                        children: <Widget>[
                          SizedBox(height: 6,),
                          Text(label, style: smallText,),
                          Visibility(
                            visible: widget._palette.playlistItem,
                              child: Icon(Icons.play_circle_outline, size: 16,))
                        ],
                      )),
                      splashColor: mainBackgroundColor,
                      onTap: () {
                        _controller.animateTo(1);
                        Controller.loadPalette(widget._palette);
                        Controller.setSendWithoutUpdate(128);
                      },
                      onLongPress: () {
                        _controller.animateTo(1);
                        _allowResetanimation = false;
                        _showCustomMenu();
                      },
                      onTapDown: _storePosition,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyPaletteEntry extends PopupMenuEntry<int>{
  final Palette _palette;
  final ValueChanged<bool> valueChanged;

  MyPaletteEntry(this._palette, this.valueChanged);

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
    Controller.savePalette(widget._palette);
    widget.valueChanged(true);
    Navigator.pop(context);
  }

  void clear() {
    Controller.clearPalette(widget._palette);
    widget.valueChanged(true);
    Navigator.pop(context);
  }

  void add() {
    Controller.addPaletteToPlaylist(widget._palette);
    widget.valueChanged(true);
    Navigator.pop(context);
  }

  void remove() {
    Controller.removePaletteFromPlaylist(widget._palette);
    widget.valueChanged(true);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RaisedButton(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,shape: buttonShape, onPressed: save, color: buttonColor.withOpacity(0.7), child: Text("Save"),),
        SizedBox(height: 2,),
        RaisedButton(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, shape: buttonShape, onPressed: clear, color: buttonColor.withOpacity(0.6), child: Text("Clear", style: TextStyle(color: Colors.white),),),
        SizedBox(height: 2,),
        Visibility(
            child:
            RaisedButton(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, shape: buttonShape, onPressed: add, color: buttonColor.withOpacity(0.6), child: Text("Add to PL", style: TextStyle(color: Colors.white),),),
        visible: widget._palette.canAdd(),
        ),
        SizedBox(height: 2,),
        Visibility(
          child:
          RaisedButton(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, shape: buttonShape, onPressed: remove, color: buttonColor.withOpacity(0.6), child: Text("Rem from PL", style: TextStyle(color: Colors.white),),),
          visible: widget._palette.canRemove(),
        ),
      ],
    );
  }
}