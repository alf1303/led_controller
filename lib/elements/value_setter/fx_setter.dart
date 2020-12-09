import 'package:flutter/material.dart';
import 'package:ledcontroller/elements/custom/custom_group_radio.dart';
import 'package:ledcontroller/elements/custom/custom_radio.dart';
import 'package:provider/provider.dart';
import 'package:invert_colors/invert_colors.dart';
import '../../controller.dart';
import '../../provider_model_attribute.dart';
import '../../styles.dart';
import 'fx_num_widget.dart';
import 'my_color_picker.dart';

class FxSetter extends StatelessWidget {

  onPlaylistModeChange(value) {
    if(Controller.providerModel.list != null) {
      Controller.setSend(131);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    //print("fxSetter, h: $height, w: $width");
    final double fontSize = height > width ? (width/25)/1.1 : (height/25)/1.1;
    final attr = Provider.of<ProviderModelAttribute>(context, listen: true);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: mainBackgroundColor,
        border: Border.all(),
        borderRadius: expandedBodyRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          /////////////////////////////////////////////////    FX COLOR
          Expanded(
            flex: 2,
            child: StatefulBuilder(
                builder: (context, setStat) {
                  return GestureDetector(
                    child: Container(
                      height: height > width ? width/6 : height/6,
                      width: height > width ? width/6 : height/6,
                      decoration: BoxDecoration(
                          boxShadow: [boxShadow1],
                          color: attr.fxColor, border: Border.all(color: Colors.black45), borderRadius: BorderRadius.circular(12)),
                      child: InvertColors(child: FittedBox(fit: BoxFit.scaleDown, child: Text("  FX\ncolor", style: smallText.copyWith(fontSize: fontSize*1.3, color: attr.fxColor),))),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return MyColorPicker(width*0.8, attr.fxColor, attr.fxSize, (val) {setStat((){});});
                          });
                    },
                  );
                }
            )
          ),
          Expanded(
            flex: 4,
            child: FxNumWidget(),
          ),

          //////////////////////////////////////////   FX SETTINGS
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                //showFxSettings(context);
                showDialog(context: context,
                    builder: (context) {
                      final _formKey = GlobalKey<FormState>();
                      TextEditingController _periodController = TextEditingController();
                      _periodController.text = Controller.paletteProvider.playlistPeriod.toString();
                      return AlertDialog(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        shape: alertShape,
                        backgroundColor: alertBackgroundColor,
                        title: Text("Playlist settings", style: mainWhiteText,),
                        content: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text("Playlist items: ${Controller.paletteProvider.playlist.length}", style: mainWhiteText),
                              Row(
                                children: <Widget>[
                                  Text("Period (seconds):", style: mainWhiteText),
                                  Expanded(
                                    child: Container(
                                      color: mainBackgroundColor.withOpacity(0.8),
                                      child: TextFormField(
                                        decoration: inputDecoration,
                                        controller: _periodController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if(value.isEmpty || int.parse(value) < 1 || int.parse(value) > 3600) return "1-3600 seconds";
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          Container(
                            //color: mainBackgroundColor,
                            decoration: roundedDecoration,
                            child: Row(
                              children: [
                                StatefulBuilder(
                                    builder: (context, setStat) {
                                      return CustomRadio(label: attr.playlistMode ? "Stop Playlist" : "Start Playlist", value: attr.playlistMode, onChanged: (value) {
                                        setStat((){
                                          attr.playlistMode = value;
                                        });
                                        attr.processPlaylist();
                                        onPlaylistModeChange(value);
                                      },
                                        color: radioColor, fontSize: fontSize*0.7,);
                                    }
                                ),
                                RaisedButton(
                                    shape: roundedButtonShape,
                                    child: Text("Save to Device"),
                                    onPressed: () {
                                      if(_formKey.currentState.validate()) {
                                        Controller.paletteProvider.playlistPeriod = int.parse(_periodController.text);
                                        Controller.sendPlaylist();
                                        Navigator.of(context).pop();
                                      }
                                    })
                              ],
                            ),
                          )
                        ],
                      );
                    }
                );
              },
              child: Container(
                  height: height > width ? width/6 : height/6,
                  width: height > width ? width/6 : height/6,
                  decoration: BoxDecoration(
                      boxShadow: [boxShadow1],
                      color: Colors.grey, border: Border.all(color: linesColor), borderRadius: BorderRadius.circular(12)),
                  child: FittedBox(fit: BoxFit.scaleDown, child: Text("Playlist \nSettings", style: smallText.copyWith(fontSize: fontSize*1.3),))
              ),
            ),
          )
        ],
      ),
    );
  }
}