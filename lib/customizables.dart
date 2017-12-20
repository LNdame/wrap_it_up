import 'package:flutter/foundation.dart';

class CustomizableFactors {
  CustomizableFactors(int timer, int sharpness)
      : this._timer = new ValueNotifier<int>(timer),
        this._sharpness = new ValueNotifier<int>(sharpness);

  final ValueNotifier<int> _timer, _sharpness;

  int get timer => _timer.value;

  set timer(int newValue) {
    if (_timer.value != newValue) _timer.value = newValue;
  }

  ValueNotifier<int> getTimerNotifier() => _timer;

  int get sharpness => _sharpness.value;

  set sharpness(int newValue) {
    if (_sharpness.value != newValue) _sharpness.value = newValue;
  }

  ValueNotifier<int> getSharpnessNotifier() => _sharpness;
}
