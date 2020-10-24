import 'package:flutter/material.dart';
import 'package:ledcontroller/model/palette.dart';
import 'package:provider/provider.dart';

import '../palettes_provider.dart';

class PaletteViewer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final paletteProvider = Provider.of<PaletteProvider>(context, listen: true);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: paletteProvider.list.length,
          itemBuilder: (context, index) {
            return ViewPaletteItem(paletteProvider.list[index]);
          }),
    );
  }
}

class ViewPaletteItem extends StatelessWidget{
final Palette _palette;

ViewPaletteItem(this._palette);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(

        width: 50,
        //height: 50,
        color: Colors.yellow,
      ),
    );
  }
}