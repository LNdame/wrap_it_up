import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'customizables.dart';
import 'preferences.dart';

class CustomizationsBottomSheet extends StatefulWidget {
  CustomizationsBottomSheet(this._customizables);

  final CustomizableFactors _customizables;

  @override
  _CustomizationsState createState() => new _CustomizationsState();
}

class _CustomizationsState extends State<CustomizationsBottomSheet> {
  WrapItUpPrefs _prefs;

  _initPreferences() async {
    _prefs = await WrapItUpPrefs.getInstance();
  }

  void _whenTimerSliderChanged(double value) {
    _prefs.saveTimer(value.floor());
    setState(() {
      widget._customizables.timer = value.floor();
    });
  }

  void _whenAntiBlurSliderChanged(double value) {
    _prefs.saveAntiBlur(value.floor());
    setState(() {
      widget._customizables.sharpness = value.floor();
    });
  }

  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  @override
  Widget build(BuildContext context) {
    Expanded buildExpandedSlider(BuildContext context, double sliderValue, ValueChanged<double> onChangedCallback,
        String label, double min, double max, int stops) =>
        new Expanded(
            child: Theme
                .of(context)
                .platform == TargetPlatform.android
                ? new Slider(
              value: sliderValue,
              onChanged: onChangedCallback,
              min: min,
              max: max,
              divisions: stops,
              label: label,
            )
                : new CupertinoSlider(
              value: sliderValue,
              onChanged: onChangedCallback,
              min: min,
              max: max,
              divisions: stops,
            ));

    final TextStyle fieldTitle = Theme
        .of(context)
        .textTheme
        .body1;
    return new Container(
      color: Colors.cyan,
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new Text("Blink speed", style: fieldTitle),
          new Row(
            children: <Widget>[
              const Icon(Icons.fast_forward),
              buildExpandedSlider(
                  context,
                  widget._customizables.timer.toDouble(),
                  _whenTimerSliderChanged,
                  '${widget._customizables.timer.toString()} ms',
                  300.0,
                  1500.0,
                  12),
              const Icon(Icons.play_arrow),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
          ),
          new Text("Sharpness", style: fieldTitle),
          new Row(
            children: <Widget>[
              const Icon(Icons.blur_on),
              buildExpandedSlider(
                  context,
                  widget._customizables.sharpness.toDouble(),
                  _whenAntiBlurSliderChanged,
                  '${widget._customizables.sharpness.toString()}%',
                  0.0,
                  100.0,
                  10),
              const Icon(Icons.blur_off),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
          ),
        ],
      ),
    );
  }
}
