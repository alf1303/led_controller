import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ledcontroller/elements/custom/custom_slider_thumb_rounded_rect.dart';
import 'package:ledcontroller/model/palette.dart';
import 'package:ledcontroller/palettes_provider.dart';
import 'package:ledcontroller/styles.dart';
import 'package:provider/provider.dart';

import '../controller.dart';
import 'custom/fitted_text.dart';

class PlaybackView extends StatelessWidget{
  final TabController _tabController;

  const PlaybackView(this._tabController);

  @override
  Widget build(BuildContext context) {
    final paletteProvider = Provider.of<PaletteProvider>(context, listen: true);
    final List<Palette> programs = paletteProvider.getProgramms().where((element) => element.isNotEmpty()).toList();
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.black,
          padding: EdgeInsets.all(4),
          child: Column(
            children: [
              Container(
                width: 200,
                child: RaisedButton(
                    elevation: 5,
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(Icons.arrow_back_outlined, size: 24,),
                    onPressed: () {
                      _tabController.animateTo(0);
                    }
                ),
              ),
              SizedBox(height: 15),
              StatefulBuilder(
                builder: (context, setStat) {
                  return SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: accentColor,
                      inactiveTrackColor: Colors.white.withOpacity(.5),
                      trackHeight: 4.0,
                      thumbShape: CustomSliderThumbRoundedRect(
                        thumbRadius: 20,
                        thumbHeight: 50,
                        min: 0,
                        max: 100,
                      ),
                      overlayColor: Colors.white.withOpacity(.4),
                      //valueIndicatorColor: Colors.white,
                      activeTickMarkColor: Colors.white,
                      inactiveTickMarkColor: Colors.red.withOpacity(.7),
                    ),
                    child: Slider(
                     value: paletteProvider.grandMaster,
                     label: paletteProvider.grandMaster.round().toString(),
                     min: 0,
                     max: 100,
                     divisions: 100,
                     onChanged: (value) {
                      setStat(() {
                        paletteProvider.grandMaster = value;
                      });
                    },
                    onChangeEnd: (value) {
                       Controller.setSendWithoutUpdate(1, value.round());
                    },
                    ),
                  );
                }
              ),
              SizedBox(height: 15),
              GridView.count(
                shrinkWrap: true,
                  crossAxisCount: 3,
                childAspectRatio: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                scrollDirection: Axis.vertical,
                children: List.generate(programs.length, (index) => ViewPlayback(programs[index])),
              ),
            ],
          ),
        ),
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
        Controller.setSendWithoutUpdate(128, paletteProvider.grandMaster.round());
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
              color: _selected ? Colors.white38 : Colors.transparent,
              border: Border.all(color: _selected ? Colors.yellowAccent : Colors.grey, width: _selected ? 4 : 1),
              borderRadius: BorderRadius.circular(5)
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: FittedBox(fit: BoxFit.fitWidth, child: Text("  ${widget._palette.name}  ", style: TextStyle(fontSize: 40, color: widget._palette.selected ? Colors.yellowAccent : Colors.white),))),
            ],
          )
        ],
      ),
    );
  }
}