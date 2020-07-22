import 'package:flutter/material.dart';
import 'package:monthly/constants.dart';

class StockListAdd extends StatefulWidget {
  @override
  _StockListAddState createState() => _StockListAddState();
}

class _StockListAddState extends State<StockListAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Text("add")),
    );
  }
}