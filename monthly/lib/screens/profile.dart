import 'dart:io';

import 'package:monthly/screens/profile_modify_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile_info.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monthly/constants.dart';
import 'package:monthly/stock.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isKakao = false;

  @override
  void initState() {
    super.initState();
    _isKakaoInstalled();
  }

  _launchURL() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'youngthly@gmail.com',
      query:
          'subject=먼슬리 문의 메일 &body=버전:${context.read<Stock>().notionVersion}\n 문의 내용을 아래에 써서 보내주시면 최대한 빠르게 응답하겠습니다!\n >',
    );

    var url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      final scaffold = Scaffold.of(context);
      scaffold.showSnackBar(
        SnackBar(
          backgroundColor: Colors.black38,
          content: const Text('메일 기본 앱을 찾을 수 없습니다.'),
          action: SnackBarAction(
              textColor: Colors.redAccent,
              label: '확인',
              onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    }
  }

  void _isKakaoInstalled() async {
    final installed = await isKakaoTalkInstalled();
    print('isKakaoInstalled: $installed');
    setState(() {
      _isKakao = installed;
    });
  }

  _accessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      _getUserKakaoName();
      print('token : ${token.toString()} !');
    } catch (e) {
      print("accessToken Method Error : $e");
    }
  }

  _loginInstalled() async {
    try {
      var code = await AuthCodeClient.instance.requestWithTalk();
      await _accessToken(code);
    } catch (e) {
      print(e);
    }
  }

  _loginUninstalled() async {
    try {
      var code = await AuthCodeClient.instance.request();
      await _accessToken(code);
    } catch (e) {
      print(e);
    }
  }

  _logout() async {
    try {
      var code = await UserApi.instance.logout();
      print(code.toString());
    } catch (e) {
      print(e);
    }
  }

  _unlink() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("appleName")) {
      context.read<Stock>().logoutProfile();
    } else {
      try {
        var code = await UserApi.instance.unlink();
        context.read<Stock>().logoutProfile();
        print(code.toString());
      } catch (e) {
        print(e);
      }
    }
  }

  _getUserKakaoName() async {
    try {
      User user = await UserApi.instance.me();
      print("user : ${user.properties}");
      context.read<Stock>().addKakaoProfile(
          name: user.properties['nickname'],
          snsId: user.id,
          profileImgUrl: user.properties['profile_image']);
    } catch (e) {
      context.read<Stock>().logoutProfile();
      print('UserData method Error : $e');
    }
  }

  void _appleLogin() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: 'com.monthly.monthly',
        redirectUri: Uri.parse(
          'https://messy-flicker-onion.glitch.me/callbacks/sign_in_with_apple',
        ),
      ),
    );

    context.read<Stock>().addAppleProfile(
          name:
              "${credential.familyName ?? ""}${credential.givenName ?? "투자자"}",
          snsId: credential.userIdentifier,
        );

    // This is the endpoint that will convert an authorization code obtained
    // via Sign in with Apple into a session in your system
    final signInWithAppleEndpoint = Uri(
      scheme: 'https',
      host: 'messy-flicker-onion.glitch.me',
      path: '/sign_in_with_apple',
      queryParameters: <String, String>{
        'code': credential.authorizationCode,
        'firstName': credential.givenName,
        'lastName': credential.familyName,
        'useBundleId': Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
        if (credential.state != null) 'state': credential.state,
      },
    );

    final session = await http.Client().post(
      signInWithAppleEndpoint,
    );

    print("Apple session : ${session.statusCode}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            titleSpacing: 0.0,
            centerTitle: false,
            elevation: 0.0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "내 프로필",
                style: TextStyle(
                    color: kTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 27),
              ),
            ),
            floating: true,
            backgroundColor: Colors.white,
          ),
          SliverToBoxAdapter(
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  context.watch<Stock>().userData.profileImgUrl != ''
                      ? Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(110.0),
                            child: Image(
                                fit: BoxFit.cover,
                                width: 110.0,
                                height: 110.0,
                                image: NetworkImage(context
                                    .watch<Stock>()
                                    .userData
                                    .profileImgUrl)),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0.0, 1.0),
                                  color: Colors.grey,
                                  blurRadius: 1.0)
                            ],
                          ),
                        )
                      : Icon(
                          Icons.account_circle,
                          color: kTextColor.withOpacity(0.7),
                          size: 110.0,
                        ),
                  context.watch<Stock>().userData.isSnsLogin
                      ? Container(
                          width: 300,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "안녕하세요 ",
                                style: TextStyle(
                                    color: kTextColor.withOpacity(0.7),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14),
                              ),
                              Text(
                                "${context.watch<Stock>().userData.name}",
                                style: TextStyle(
                                    color: kTextColor.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                              Text(
                                "님!",
                                style: TextStyle(
                                    color: kTextColor.withOpacity(0.7),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        )
                      : FlatButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext bContext) {
                                  return AlertDialog(
                                    title: Text(
                                      "로그인",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kTextColor),
                                    ),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Stack(
                                            children: <Widget>[
                                              Image.asset(
                                                  'images/kakao_login_medium_narrow.png'),
                                              Positioned.fill(
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(bContext)
                                                          .pop();

                                                      _isKakao
                                                          ? _loginInstalled()
                                                          : _loginUninstalled();
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Platform.isIOS
                                              ? Stack(
                                                  children: <Widget>[
                                                    Image.asset(
                                                        'images/apple_login.png'),
                                                    Positioned.fill(
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    bContext)
                                                                .pop();

                                                            _appleLogin();
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : SizedBox(
                                                  height: 10,
                                                ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(bContext).pop();
                                        },
                                        child: Text("뒤로가기"),
                                      ),
                                    ],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                  );
                                });
                          },
                          child: Container(
                            width: 300,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "먼슬리 로그인!",
                                  style: TextStyle(
                                      color: kTextColor.withOpacity(0.7),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),
                                ),
                                Icon(
                                  Icons.navigate_next,
                                  color: kTextColor.withOpacity(0.7),
                                  size: 25.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
              height: 250.0,
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: <Widget>[
                    ProfileButton(
                      text: "정보",
                      icon: Icon(
                        Icons.info,
                        color: Colors.white,
                        size: 22,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileInfo()),
                        );
                      },
                    ),
                    ProfileButton(
                      text: "문의메일",
                      icon: Icon(
                        Icons.mail,
                        color: Colors.white,
                        size: 22,
                      ),
                      onTap: () {
                        _launchURL();
                      },
                    ),
                    ProfileButton(
                      text: "미국주식 매입 통화 설정",
                      icon: Icon(
                        Icons.monetization_on,
                        color: Colors.white,
                        size: 22,
                      ),
                      tailText:
                          "${context.watch<Stock>().isInputAvgDollar ? "달러" : "원화"}",
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext bContext) {
                              for (final stock
                                  in context.read<Stock>().stockList)
                                if (!(stock.ticker.contains(".KS") ||
                                    stock.ticker.contains(".KQ"))) {
                                  return AlertDialog(
                                    title: Text(
                                      "미국주식 매입 통화 설정",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kTextColor),
                                    ),
                                    content: Text(
                                      "입력 통화를 ${context.read<Stock>().isInputAvgDollar ? "달러에서 원화" : "원화에서 달러"}로 변경하시겠습니까? \n\n변경시 평군 매입단가를 전부 다시 입력하셔야 합니다.",
                                      style: TextStyle(color: kTextColor),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(bContext).pop();
                                        },
                                        child: Text("아니요"),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(bContext).pop();

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileModifyInput()),
                                          );
                                        },
                                        child: Text("예"),
                                      )
                                    ],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                  );
                                }

                              //미국 종목이 하나도 없으면
                              return AlertDialog(
                                title: Text(
                                  "미국주식 매입 통화 설정",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kTextColor),
                                ),
                                content: Text(
                                  "입력 통화를 ${context.read<Stock>().isInputAvgDollar ? "달러에서 원화" : "원화에서 달러"}로 변경하시겠습니까?",
                                  style: TextStyle(color: kTextColor),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(bContext).pop();
                                    },
                                    child: Text("아니요"),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      context.read<Stock>().setIsInputAvgDollar(
                                          !(context
                                              .read<Stock>()
                                              .isInputAvgDollar));

                                      Navigator.of(bContext).pop();
                                    },
                                    child: Text("예"),
                                  )
                                ],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                              );
                            });
                      },
                    ),
                    context.watch<Stock>().userData.isSnsLogin
                        ? ProfileButton(
                            text: "로그아웃",
                            icon: SvgPicture.asset(
                              'icons/logout.svg',
                              height: 20.0,
                              color: Colors.white,
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext bContext) {
                                    return AlertDialog(
                                      title: Text(
                                        "로그아웃",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: kTextColor),
                                      ),
                                      content: Text(
                                        "${context.read<Stock>().userData.name}님의 계정에서\n로그아웃 하시겠습니까?",
                                        style: TextStyle(color: kTextColor),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(bContext).pop();
                                          },
                                          child: Text("아니요"),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            _unlink();
                                            Navigator.of(bContext).pop();
                                          },
                                          child: Text("예"),
                                        )
                                      ],
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                    );
                                  });
                            },
                          )
                        : Container(),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: kMainColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final Function onTap;
  final String tailText;

  ProfileButton({Key key, this.text, this.icon, this.onTap, this.tailText = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: this.onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  this.icon,
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "$tailText",
                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
