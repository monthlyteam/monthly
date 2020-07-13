import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Monthly',
      theme: ThemeData(
        fontFamily: 'NanumGothic',
        canvasColor: Colors.transparent,
      ),
      home: Home(),
    );
  }
}
