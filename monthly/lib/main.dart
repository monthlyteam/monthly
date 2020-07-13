import 'package:flutter/material.dart';
import 'home.dart';
import 'package:provider/provider.dart';
import 'stock.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Stock()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print('${context.watch<Stock>().thisMonthDividend}');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Monthly',
      theme: ThemeData(fontFamily: 'NanumGothic'),
      home: Home(),
    );
  }
}
