import 'package:flutter/material.dart';

import 'pages/home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Curcon',
      home: new HomePage()
    );
  }
}