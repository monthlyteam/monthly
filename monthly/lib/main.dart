import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:monthly/user_data.dart';
import 'home.dart';
import 'package:provider/provider.dart';
import 'stock.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String> checkToken() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    print('token:$token');
    if (token == null) {
      final response = await http.get('http://13.125.225.138:5000/token');
      print('response: ${response.body}');
      prefs.setString("token", response.body);
    }
    return token;
  } catch (e) {
    return '';
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  KakaoContext.clientId = "dfc5584eeb7d68ba3b1eac6eeb72db96";
  KakaoContext.javascriptClientId = "681b9f88d5034e80c2d669f839a5bac1";

  //Token for Develop
  String token = await checkToken();
//  String token = 'hJewaJavNAdx2BbR9wRiDQ';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserData(tokenId: token)),
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
