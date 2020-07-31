import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monthly/constants.dart';
import 'package:monthly/stock.dart';
import 'profile_info.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

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
      query: 'subject=먼슬리 문의 메일 &body=문의 내용을 아래에 써서 보내주시면 최대한 빠르게 응답하겠습니다!\n >',
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
    try {
      var code = await UserApi.instance.unlink();
      context.read<Stock>().logoutKakao();
      print(code.toString());
    } catch (e) {
      print(e);
    }
  }

  _getUserKakaoName() async {
    try {
      User user = await UserApi.instance.me();
      print("user : ${user.properties}");
      context.read<Stock>().addKakaoProfile(
          name: user.properties['nickname'],
          kakaoId: user.id,
          profileImgUrl: user.properties['profile_image']);
    } catch (e) {
      context.read<Stock>().logoutKakao();
      print('UserData method Error : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print("url : ${context.watch<Stock>().userData.profileImgUrl}");
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
                                fit: BoxFit.fitWidth,
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
                  context.watch<Stock>().userData.isKakaoLogin
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
                            _isKakao ? _loginInstalled() : _loginUninstalled();
                          },
                          child: Container(
                            width: 300,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "카카오 아이디로 먼슬리 로그인!",
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
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileInfo()),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Icons.info,
                                color: Colors.white,
                                size: 22,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "정보",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _launchURL();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Icons.mail,
                                color: Colors.white,
                                size: 22,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "문의메일",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    context.watch<Stock>().userData.isKakaoLogin
                        ? Material(
                            color: Colors.transparent,
                            child: InkWell(
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
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(12.0),
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 15,
                                    ),
                                    SvgPicture.asset(
                                      'icons/logout.svg',
                                      height: 20.0,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      "로그아웃",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
