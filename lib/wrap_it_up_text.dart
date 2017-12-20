import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import 'customizables.dart';
import 'customizations_sheet.dart';
import 'preferences.dart';

class WrapItUpBackground extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;

  WrapItUpBackground(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() => new _WrapItUpBackgroundState();
}

class _WrapItUpBackgroundState extends State<WrapItUpBackground> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> sizeTween;

  final CustomizableFactors _customizables =
  new CustomizableFactors(WrapItUpPrefs.DEFAULT_TIMER, WrapItUpPrefs.DEFAULT_SHARPNESS);

  GestureLongPressCallback _showBottomSheetCallback;

  CustomizationsBottomSheet _bottomSheetView;

  _initFromPrefs() async {
    WrapItUpPrefs prefs = await WrapItUpPrefs.getInstance();
    int durationTimer = prefs.getTimer();
    int blur = prefs.getAntiBlur();
    debugPrint("Preference values - $durationTimer , $blur");
    _refreshAnimations(duration: durationTimer, blur: blur);
  }

  _refreshAnimations({int duration, int blur}) {
    setState(() {
      if (duration != null) {
        _customizables.timer = duration;
        //TODO ahhhh! how do i fix this? i dont want to create new objects every time
        controller.duration = new Duration(milliseconds: _customizables.timer);
      }
      if (blur != null) {
        _customizables.sharpness = blur;
      }
    });
  }

  _showBottomSheet() {
    setState(() {
      // disable the button
      _showBottomSheetCallback = null;
    });
    PersistentBottomSheetController<Null> persistentController =
    widget._scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
      return _bottomSheetView;
    });
    persistentController.closed.whenComplete(() {
      if (mounted) {
        setState(() {
          // re-enable the button
          _showBottomSheetCallback = _showBottomSheet;
        });
      }
    });
  }

  void _animationTimerHasChanged() {
    debugPrint("Timer has changed - ${_customizables.timer}");
    _refreshAnimations(duration: _customizables.timer);
  }

  void _animationBlurHasChanged() {
    debugPrint("Blur has changed - ${_customizables.sharpness}");
    _refreshAnimations(blur: _customizables.sharpness);
  }

  @override
  void initState() {
    super.initState();

    _showBottomSheetCallback = _showBottomSheet;
    _customizables.getTimerNotifier().addListener(_animationTimerHasChanged);
    _customizables.getSharpnessNotifier().addListener(_animationBlurHasChanged);
    this._bottomSheetView = new CustomizationsBottomSheet(_customizables);

    _initFromPrefs();

    controller = new AnimationController(duration: new Duration(milliseconds: _customizables.timer), vsync: this);
    CurvedAnimation curvedAnimation = new CurvedAnimation(parent: controller, curve: Curves.bounceOut);
    sizeTween = new Tween<double>(begin: 0.2, end: 0.8).animate(curvedAnimation);
    curvedAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        new Timer(new Duration(milliseconds: 500), () => controller.reverse());
      } else if (status == AnimationStatus.dismissed) {
        new Timer(new Duration(seconds: 1), () => controller.forward());
      }
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    _customizables.getTimerNotifier().removeListener(_animationTimerHasChanged);
    _customizables.getSharpnessNotifier().removeListener(_animationBlurHasChanged);
    super.dispose();
  }

  @override
  AnimatedFlashyBackground build(BuildContext context) {
    return new AnimatedFlashyBackground(
      animation: sizeTween,
      openBottomSheet: _showBottomSheetCallback,
      innerStop: _customizables.sharpness,
    );
  }
}

class AnimatedFlashyBackground extends AnimatedWidget {
  final GestureLongPressCallback _bottomSheetNeedsToOpenMethod;

  final int _innerStop;

  AnimatedFlashyBackground({Key key, Animation<double> animation, VoidCallback openBottomSheet, int innerStop})
      : this._bottomSheetNeedsToOpenMethod = openBottomSheet,
        this._innerStop = innerStop,
        super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation<double> radiusAnimation = listenable;
    final String wrapItUpText =
    MediaQuery
        .of(context)
        .orientation == Orientation.portrait ? "WRAP\nIT\nUP" : "WRAP IT UP";

    return new GestureDetector(
      onLongPress: _bottomSheetNeedsToOpenMethod,
      child: new Container(
        decoration: new BoxDecoration(
            gradient: new RadialGradient(
                colors: [Colors.amber.shade50, Colors.amber],
                center: Alignment.center,
                radius: radiusAnimation.value,
                stops: [_innerStop / 100, 1.0])),
        child: new Center(
          child: new Text(
            wrapItUpText,
            textAlign: TextAlign.center,
            style: Theme
                .of(context)
                .textTheme
                .display4,
          ),
        ),
      ),
    );
  }
}
