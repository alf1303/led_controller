import 'package:flutter/material.dart';

import '../../styles.dart';

class MyCustomSlider extends StatelessWidget {
  final String _label;
  final double value;
  final double min;
  final double max;
  final Color shadowColor;
  final Color borderColor;
  final Color sliderColor;
  final double borderRadius;
  final ValueChanged<double> _valueChanged;
  final ValueChanged<double> _valueChangeEnd;
  onValChanged(valuee) {
    _valueChanged(valuee);
  }
  onValChangeEnd(valuee) {
    _valueChangeEnd(valuee);
  }

  const MyCustomSlider(this._label, this.value, this.min, this.max, this.shadowColor, this.borderColor, this.sliderColor,
      this.borderRadius, this._valueChanged, this._valueChangeEnd);

  @override
  Widget build(BuildContext context) {
    double tmpVal = value;
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Text(_label, style: smallText,),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(15)
          ),
          child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
              ),
              child: StatefulBuilder(
                builder: (context, setStat) {
                  return Slider(
                      min: min,
                      max: max,
                      activeColor: sliderColor,
                      inactiveColor: sliderColor.withOpacity(0.3),
                      value: tmpVal,
                      label: tmpVal.round().toString(),
                      divisions: max.round(),
                      onChanged: (value) {
                        setStat(() {tmpVal = value;});
                        _valueChanged(value);
                      },
                      onChangeEnd: onValChangeEnd
                  );
                },
              )
          ),
        ),
      ],
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////
class MyCustomSliderNoCard extends StatelessWidget {
  final String _label;
  final double value;
  final double min;
  final double max;
  final Color shadowColor;
  final Color borderColor;
  final Color sliderColor;
  final double borderRadius;
  final ValueChanged<double> _valueChanged;
  final ValueChanged<double> _valueChangeEnd;
  onValChanged(valuee) {
    _valueChanged(valuee);
  }
  onValChangeEnd(valuee) {
    _valueChangeEnd(valuee);
  }

  const MyCustomSliderNoCard(this._label, this.value, this.min, this.max, this.shadowColor, this.borderColor, this.sliderColor,
      this.borderRadius, this._valueChanged, this._valueChangeEnd);

  @override
  Widget build(BuildContext context) {
    // print("$_label, $value");
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Text("$_label: ${value.round()}", style: smallText.copyWith(fontSize: 14),),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
          ),
          child: Slider(
              min: min,
              max: max,
              activeColor: sliderColor,
              inactiveColor: sliderColor.withOpacity(0.3),
              value: value,
              label: value.round().toString(),
              divisions: max.round(),
              onChanged: onValChanged,
              onChangeEnd: onValChangeEnd
          ),
        ),
      ],
    );
  }
}


/////////////////////////////////////////////////////////////////////////////////////////
class FxSliderWidget extends StatefulWidget{
  final String label;
  final double fxParametr;
  final double max;
  final ValueChanged<double> onChanged;
  final bool visible;

  onParametrChanged(double value){
    onChanged(value);
  }
  const FxSliderWidget(
      this.label,
      this.fxParametr,
      this.max,
      this.onChanged,
      this.visible);

  @override
  _FxSliderWidgetState createState() => _FxSliderWidgetState();
}
class _FxSliderWidgetState extends State<FxSliderWidget> {
  @override
  Widget build(BuildContext context) {
    double _param = widget.fxParametr;
    print("${widget.label}, $_param");
    return  Visibility(
      visible: widget.visible,
      child: StatefulBuilder(
        builder: (context, setStat) {
          return Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: linesColor2,),
                  onPressed: () {
                    setStat(() {
                      _param <= 1 ? 1 : _param--;
                      widget.onParametrChanged(_param);
                    });
                  }),
              Expanded(child: MyCustomSliderNoCard(widget.label, _param, 1, widget.max, secondaryBackgroundColor, linesColor2, linesColor2, 5, (value) {setStat(() {_param = value;}); }, widget.onParametrChanged)),
              IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: linesColor2,),
                  onPressed: () {
                    setStat(() {
                      _param >= widget.max ? widget.max : _param++;
                      widget.onParametrChanged(_param);
                    });
                  }),
            ],
          );
        },
      ),
    );
  }
}

