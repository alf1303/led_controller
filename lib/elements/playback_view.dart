import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ledcontroller/model/palette.dart';
import 'package:ledcontroller/palettes_provider.dart';
import 'package:ledcontroller/styles.dart';
import 'package:provider/provider.dart';

import '../controller.dart';
import 'custom/fitted_text.dart';

class PlaybackView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final paletteProvider = Provider.of<PaletteProvider>(context, listen: true);
    final List<Palette> programs = paletteProvider.getProgramms().where((element) => element.isNotEmpty()).toList();
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(4),
      child: GridView.count(
          crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        scrollDirection: Axis.vertical,
        children: List.generate(programs.length, (index) => ViewPlayback(programs[index])),
      ),
    );
  }
}

class ViewPlayback extends StatefulWidget {
Palette _palette;

ViewPlayback(this._palette);

  @override
  _ViewPlaybackState createState() => _ViewPlaybackState();
}

class _ViewPlaybackState extends State<ViewPlayback> {
  @override
  Widget build(BuildContext context) {
    final paletteProvider = Provider.of<PaletteProvider>(context, listen: true);
    //print("build: selected: ${widget._palette.selected}");
    bool _selected = widget._palette.selected;
    return GestureDetector(
      onTap: () {
        Controller.loadPalette(widget._palette);
        Controller.setSendWithoutUpdate(128);
        paletteProvider.deselectPrograms();
        setState(() {
          widget._palette.selected = true;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 400),
            decoration: BoxDecoration(
              color: _selected ? mainBackgroundColor : Colors.grey,
              border: Border.all(color: _selected ? Colors.yellowAccent : Colors.grey, width: _selected ? 4 : 1),
              borderRadius: BorderRadius.circular(5)
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: FText(" ${widget._palette.name} ", headerTextSmall)),
            ],
          )
        ],
      ),
    );
  }
}