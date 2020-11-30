import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ledcontroller/styles.dart';

class HelpWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double ww = height > width ? width/7 : height/13;
    double hh = height > width ? height/13 : width/7;
    return AlertDialog(
      shape: alertShape,
      backgroundColor: thirdBackgroundColor.withOpacity(0.7),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //Scan
            Row(
              children: [
                SizedBox(
                    width: ww, height: hh,
                    child: Image(image: AssetImage('assets/help/scan.jpg'),)),
                SizedBox(width: 4,),
                Expanded(child: Text("  Press to search you Esp8266 on connected WiFi network. Ensure, that you are connected to right network. Close and reopen Application, reload Esp8266 if something goes wrong"))
              ],
            ),
            //Settings
            DividerMy(),
            Row(
              children: [
                SizedBox(
                    width: ww, height: hh,
                    child: Image(image: AssetImage('assets/help/settings.jpg'),)),
                SizedBox(width: 4,),
                Expanded(child: Text("  Changing name, pixels count and WiFi settings"))
              ],
            ),
            DividerMy(),
            //HL
            Row(
              children: [
                SizedBox(
                    width: ww, height: hh,
                    child: Image(image: AssetImage('assets/help/highlite.jpg'),)),
                SizedBox(width: 4,),
                Expanded(child: Text("  Highlites selected Esp8266 (lights it up in white color)"))
              ],
            ),
            DividerMy(),
            Row(
              children: [
                SizedBox(
                    width: ww, height: hh,
                    child: Image(image: AssetImage('assets/help/palette.jpg'),)),
                SizedBox(width: 4,),
                Expanded(child: Text("  Press and Hold for showing menu.\n  Press to load data from Palette\n"
                    " You can store the desired look(color, effect) of selected Esp8266 into palette for reusing. You can add palettes to playlist and store that playlist"
                    " into Esp8266 for playing back it later"))
              ],
            ),
            DividerMy(),
            //Playlist
            Row(
              children: [
                SizedBox(
                    width: ww, height: hh,
                    child: Image(image: AssetImage('assets/help/playlist.jpg'),)),
                SizedBox(width: 4,),
                Expanded(child: Text("  Change duration for plalist items and save them to Esp8266"))
              ],
            ),
            DividerMy(),
            //startplaylist
            Row(
              children: [
                SizedBox(
                    width: ww, height: hh,
                    child: Image(image: AssetImage('assets/help/startplaylist.jpg'),)),
                SizedBox(width: 4,),
                Expanded(child: Text("  Start/Stop playlist playing back"))
              ],
            ),
            DividerMy(),
            Row(
              children: [
                SizedBox(
                    width: ww, height: hh,
                    child: Image(image: AssetImage('assets/help/fxcolor.jpg'),)),
                SizedBox(width: 4,),
                Expanded(child: Text("  Select color for effect. Effect color and main color are adding. So to see effect you need to set main color to black or decrement its brightness"))
              ],
            ),
            DividerMy(),
            Row(
              children: [
                SizedBox(
                    width: ww, height: hh,
                    child: Image(image: AssetImage('assets/help/fxsettings.jpg'),)),
                SizedBox(width: 4,),
                Expanded(child: Text("  Change effect settings (speed, reverse, width and others)"))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DividerMy extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(height: 2, color: Colors.grey,
      ),
    );
  }
}