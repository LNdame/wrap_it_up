import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class WrapItUpPrefs {

  static const int DEFAULT_TIMER = 800;
  static const int DEFAULT_SHARPNESS = 0;

  static WrapItUpPrefs _instance;

  SharedPreferences _sharedPref;

  static Future<WrapItUpPrefs> getInstance() async {
    if (_instance == null) {
      SharedPreferences internalSharedPrefs = await SharedPreferences.getInstance();
      _instance = new WrapItUpPrefs._(internalSharedPrefs);
    }
    return _instance;
  }

  WrapItUpPrefs._(this._sharedPref);

  void saveTimer(int timer) {
    _sharedPref?.setInt(_PrefTypes.timer.toString(), timer);
  }

  int getTimer() {
    return _sharedPref?.getInt(_PrefTypes.timer.toString()) ?? DEFAULT_TIMER;
  }

  void saveAntiBlur(int antiBlur) {
    _sharedPref?.setInt(_PrefTypes.blur.toString(), antiBlur);
  }

  int getAntiBlur() {
    return _sharedPref?.getInt(_PrefTypes.blur.toString()) ?? DEFAULT_SHARPNESS;
  }

}

enum _PrefTypes {
  timer,
  blur
}
