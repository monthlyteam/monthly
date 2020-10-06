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

Future<String> checkToken(SharedPreferences prefs) async {
  try {
    String token = prefs.getString("token");
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

Future<List<MyStock>> initStockData(
    String token, double dollar, bool isInputAvgDollar) async {
  try {
    final response = await http.get('http://13.125.225.138:5000/data/$token');
    var myData = json.decode(response.body);
    double exchange = 1;
    List<MyStock> stockList = [];
    myData.forEach((item) {
      if (item['ticker'].contains('.KS') || item['ticker'].contains('.KQ'))
        exchange = 1;
      else
        exchange = dollar;

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
          wonExchange: exchange,
          isInputAvgDollar: isInputAvgDollar));
    });
    return stockList;
  } catch (e) {
    exit(0);
    return null;
  }
}

Future<UserData> initUserData(String token, SharedPreferences prefs) async {
  UserData userData = UserData(tokenId: token);
  if (prefs.containsKey("appleName")) {
    userData.isSnsLogin = true;
    userData.snsId = prefs.getString('appleToken');
    userData.name = prefs.getString('appleName');
    userData.profileImgUrl = '';
  } else {
    try {
      User user = await UserApi.instance.me();
      userData.isSnsLogin = true;
      userData.snsId = user.id.toString();
      userData.name = user.properties['nickname'];
      userData.profileImgUrl = user.properties['profile_image'];
    } catch (e) {
      print('No kakao login');
    }
  }
  return userData;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  KakaoContext.clientId = "dfc5584eeb7d68ba3b1eac6eeb72db96";
  KakaoContext.javascriptClientId = "681b9f88d5034e80c2d669f839a5bac1";

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = await checkToken(prefs);
  String notionVersion = prefs.getString("notion") ?? "";
  double dollar = await getDollarData();
  UserData userData = await initUserData(token, prefs);

  bool isStockListShowDollar = prefs.getBool('show') ?? false;
  bool isInputAvgDollar = prefs.getBool('input');
  if (isInputAvgDollar == null) {
    var json = jsonEncode({
      'id': userData.getId(),
    });
    try {
      final response = await http.post(
        'http://13.125.225.138:5000/currency',
        headers: {"content-Type": "application/json"},
        body: json,
        encoding: Encoding.getByName("utf-8"),
      );
      isInputAvgDollar = response.body == 'true' ? true : false;
      print("InputAvgDollar TEST: $isInputAvgDollar");
    } catch (e) {
      print('e1:$e');
    }
  } else {
    var json = jsonEncode({
      'id': userData.getId(),
      'currency': isInputAvgDollar ? 1 : 0,
    });
    try {
      await http.post(
        'http://13.125.225.138:5000/currency',
        headers: {"content-Type": "application/json"},
        body: json,
        encoding: Encoding.getByName("utf-8"),
      );
    } catch (e) {
      print('e2:$e');
    }
  }

  prefs.remove('input');

  List<MyStock> stockList =
      await initStockData(userData.getId(), dollar, isInputAvgDollar);

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
              create: (_) => Stock(
                  userData,
                  dollar,
                  stockList,
                  isInputAvgDollar,
                  isStockListShowDollar,
                  notionVersion,
                  prefs)),
        ],
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
