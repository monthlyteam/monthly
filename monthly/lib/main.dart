import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:monthly/user_data.dart';
import 'home.dart';
import 'package:provider/provider.dart';
import 'stock.dart';
//import 'package:http/http.dart' as http;



void main() {
  KakaoContext.clientId = "dfc5584eeb7d68ba3b1eac6eeb72db96";
  KakaoContext.javascriptClientId = "681b9f88d5034e80c2d669f839a5bac1";
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserData()),
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
      theme: ThemeData(
        fontFamily: 'NanumGothic',
      ),
      home: Home(),
    );
  }
}
