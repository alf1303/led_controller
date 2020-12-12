import 'package:flutter/material.dart';
import 'package:ledcontroller/provider_model_attribute.dart';

import '../../controller.dart';
import '../../styles.dart';

class MyColorPicker extends StatefulWidget{
  final double width;
  final Color color;
  final double fxSize;
  final ValueChanged<bool> updFunc;

  MyColorPicker(this.width, this.color, this.fxSize, this.updFunc);
  @override
  _MyColorPickerState createState() => _MyColorPickerState();
}
class _MyColorPickerState extends State<MyColorPicker> {
  final attr = ProviderModelAttribute();
  final List<Color> _colors = [
    Color.fromARGB(255, 0, 0, 0),
    Color.fromARGB(255, 255, 0, 0),
    Color.fromARGB(255, 255, 128, 0),
    Color.fromARGB(255, 255, 255, 0),
    Color.fromARGB(255, 128, 255, 0),
    Color.fromARGB(255, 0, 255, 0),
    Color.fromARGB(255, 0, 255, 128),
    Color.fromARGB(255, 0, 255, 255),
    Color.fromARGB(255, 0, 128, 255),
    Color.fromARGB(255, 0, 0, 255),
    Color.fromARGB(255, 128, 0, 255),
    Color.fromARGB(255, 255, 0, 255),
    Color.fromARGB(255, 255, 0, 128),
    Color.fromARGB(255, 255, 255, 255),
  ];

  @override
  void initState() {
    super.initState();
    _currentColor = widget.color;
    _currentFxSize = widget.fxSize;
    _colorSliderPosition = _calculatePositionFromColor(_currentColor);
  }

  double _colorSliderPosition = 0;
  Color _currentColor;
  double _currentFxSize;

  _colorChangeHandler(double position) {
    if(position > widget.width) {
      position = widget.width;
    }
    if(position < 0) {
      position = 0;
    }
    _colorSliderPosition = position;
    _currentColor = _calculateSelectedColor(position);
    setState(() {    });
  }

  _colorChangeEnd() {
    attr.fxColor = _currentColor;
    if(Controller.providerModel.list != null) {
      attr.processFxColor();
      Controller.setSend(129);
      widget.updFunc(false);
    }
  }

  _onFxSizeChangeEnd(value) {
    attr.fxSize = value;
    if(Controller.providerModel.list != null) {
      attr.processFxColor();
      Controller.setSend(130);
    }
    setState(() {
      _currentFxSize = value;
    });
  }

  double _calculatePositionFromColor(Color col) {
    double dist = widget.width/(_colors.length-1);
    if(col.red == 255 && col.green == 255 && col.blue == 255) return widget.width;
    if(col.red == 0 && col.green == 0 && col.blue == 0) return 0;
    List<int> diff = List.filled(3, 255);
    Color closest;
    _colors.forEach((e) {
      if((col.red - e.red).abs() <= diff[0] && (col.green - e.green).abs() <= diff[1] && (col.blue - e.blue).abs() <= diff[2]) {
        diff[0] = (col.red - e.red).abs();
        diff[1] = (col.green - e.green).abs();
        diff[2] = (col.blue - e.blue).abs();
        closest = e;
      }
    });
    return _colors.indexOf(closest)*dist;
  }

  Color _calculateSelectedColor(double position) {
    double positionInArray = (position/widget.width * (_colors.length - 1));
    int index = positionInArray.truncate();
    double reminder = positionInArray - index;
    if(reminder == 0) {
      _currentColor = _colors[index];
    }
    else {
      int redValue = _colors[index].red == _colors[index+1].red ? _colors[index].red :
      (_colors[index].red + (_colors[index+1].red - _colors[index].red)*reminder).round();
      int greenValue = _colors[index].green == _colors[index+1].green ? _colors[index].green :
      (_colors[index].green + (_colors[index+1].green - _colors[index].green)*reminder).round();
      int blueValue = _colors[index].blue == _colors[index+1].blue ? _colors[index].blue :
      (_colors[index].blue + (_colors[index+1].blue - _colors[index].blue)*reminder).round();
      _currentColor = Color.fromARGB(255, redValue, greenValue, blueValue);
    }
    return _currentColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 100,
          height: 50,
          decoration: BoxDecoration(
            color: _currentColor.withOpacity(_currentFxSize/100),
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(20),
            //shape: BoxShape.circle
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (details) {
            //print("DRAG start");
            _colorChangeHandler(details.localPosition.dx);
          },
          onHorizontalDragEnd: (details) {
            _colorChangeEnd();
          },
          onHorizontalDragUpdate: (details) {
            //print("DRAG update");
            _colorChangeHandler(details.localPosition.dx);
          },
          onTapDown: (details) {
            _colorChangeHandler(details.localPosition.dx);
            _colorChangeEnd();
          },
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              width: widget.width,
              height: 20,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[800], width: 2),
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(colors: _colors)
              ),
              child:
              CustomPaint(
                painter: _SliderIndicatorPainter(_colorSliderPosition),
              ),
            ),
          ),
        ),
        StatefulBuilder(
            builder: (context, setStat) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Material(
                  textStyle: TextStyle(color: Colors.black),
                  color: Colors.transparent,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        accentTextTheme: TextTheme(bodyText2: TextStyle(color: mainBackgroundColor))
                    ),
                    child: Column(
                      children: [
                        Text("FX color Size:", style: mainWhiteText.copyWith(fontSize: 14)),
                        Slider(
                          activeColor: linesColor,
                          inactiveColor: mainBackgroundColor,
                          value: _currentFxSize,
                          label: _currentFxSize.round().toString(),
                          divisions: 100,
                          min: 0,
                          max: 100,
                          onChanged: (value) {
                            setStat(() {
                              _currentFxSize = value;
                            });
                          },
                          onChangeEnd: (value) {
                            _onFxSizeChangeEnd(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        )
      ],
    );
  }
}

class _SliderIndicatorPainter extends CustomPainter {
  final double position;

  _SliderIndicatorPainter(this.position);

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()..color = Colors.black.withOpacity(0.6)..style = PaintingStyle.stroke..strokeWidth = 10;
    canvas.drawCircle(Offset(position, size.height/2), 12, circlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}