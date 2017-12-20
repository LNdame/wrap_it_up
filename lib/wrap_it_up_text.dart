import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import 'customizables.dart';
import 'customizations.dart';
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
    setState(() {
      _customizables.timer = durationTimer;
      //TODO ahhhh! how do i fix this? i dont want to create new objects every time
      controller.duration = new Duration(milliseconds: _customizables.timer);

      _customizables.sharpness = blur;
    });
  }

  _showBottomSheet() {
    debugPrint("trying to open bottomsheet");
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

  @override
  void initState() {
    super.initState();
    debugPrint("initstate being called");
    _showBottomSheetCallback = _showBottomSheet;
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
  AnimatedFlashyBackground build(BuildContext context) {
    debugPrint("${_customizables.timer},${_customizables.sharpness} - Trying to redraw the flashy background");
    return new AnimatedFlashyBackground(
      sizeTween,
      _showBottomSheetCallback,
      _customizables.sharpness,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AnimatedFlashyBackground extends AnimatedWidget {
  final GestureLongPressCallback _bottomSheetNeedsToOpenMethod;

  final int _innerStop;

  AnimatedFlashyBackground(Animation<double> animation, this._bottomSheetNeedsToOpenMethod, this._innerStop, [Key key])
      : super(key: key, listenable: animation);

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
