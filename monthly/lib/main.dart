import 'dart:convert';
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:monthly/user_data.dart';
import 'home.dart';
import 'package:provider/provider.dart';
import 'stock.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'my_stock.dart';
import 'package:flutter/services.dart';

Future<String> checkToken() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    print('token:$token');
    if (token == null) {
      final response = await http.get('http://13.125.225.138:5000/token');
      print('response: ${response.body}');
      prefs.setString("token", response.body);
      token = response.body;
    }
    return token;
  } catch (e) {
    return '';
  }
}

Future<double> getDollarData() async {
  try {
    final response = await http.get('http://13.125.225.138:5000/dollar');
    var dollar = json.decode(response.body);
    return dollar['USD'].toDouble();
  } catch (e) {
    return 1200.0;
  }
}

Future<List<MyStock>> initStockData(String token, double dollar) async {
  try {
    final response = await http.get('http://13.125.225.138:5000/data/$token');
    var myData = json.decode(response.body);
    double exchange = 1;
    List<MyStock> stockList = [];
    myData.forEach((item) {
      if (item['ticker'].contains('.KS'))
        exchange = 1;
      else
        exchange = dollar;

      print('dividendmonth: ${item['DividendMonth']}');
      stockList.add(MyStock(
          ticker: item['ticker'],
          name: item['Name'],
          amount: item['amount'],
          avg: item['avgPrice'],
          dividendMonth: item['DividendMonth'],
          exDividends: item['ExList'],
          nextDividend: item['NextAmount'].toDouble(),
          yearlyDividend: item['YearlyDividend'].toDouble(),
          divPercent: (item['DividendYield'] ?? 0.0) * 100.0,
          closingPrice: item['Price'],
          frequency: item['Frequency'],
          dividendDate: item['DividendDate'] ?? '',
          logoURL: item['Logo'],
          wonExchange: exchange));
    });
    return stockList;
  } catch (e) {
    exit(0);
    return null;
  }
}

Future<UserData> initUserData(String token) async {
  UserData userData = UserData(tokenId: token);
  try {
    User user = await UserApi.instance.me();
    userData.isKakaoLogin = true;
    userData.kakaoId = user.id.toString();
    userData.name = user.properties['nickname'];
    return userData;
  } catch (e) {
    print('No kakao login');
    return userData;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  KakaoContext.clientId = "dfc5584eeb7d68ba3b1eac6eeb72db96";
  KakaoContext.javascriptClientId = "681b9f88d5034e80c2d669f839a5bac1";

  String token = await checkToken();
  double dollar = await getDollarData();
  UserData userData = await initUserData(token);
  List<MyStock> stockList = await initStockData(userData.getId(), dollar);

  String admobID = Platform.isIOS
      ? 'ca-app-pub-1325163385377987~2796674910'
      : 'ca-app-pub-1325163385377987~2220469154';

  Admob.initialize(admobID);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => Stock(userData, dollar, stockList)),
        ],
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('${context.watch<Stock>().thisMonthDividend}');
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'Monthly',
      theme: ThemeData(
        fontFamily: 'NanumGothic',
      ),
      home: Home(),
    );
  }
}
