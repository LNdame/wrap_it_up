import 'package:flutter/material.dart';

import 'wrap_it_up_text.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Stop changing the app',
      theme: new ThemeData(primarySwatch: Colors.amber, accentColor: Colors.amberAccent),
      home: new MyScaffoldWrapper(),
    );
  }
}

class MyScaffoldWrapper extends StatefulWidget {
  @override
  _MyScaffoldWrapperState createState() => new _MyScaffoldWrapperState();
}

class _MyScaffoldWrapperState extends State<MyScaffoldWrapper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(key: _scaffoldKey, body: new WrapItUpBackground(_scaffoldKey));
  }
}
