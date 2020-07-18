import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:monthly/constants.dart';

class ProfileLogin extends StatefulWidget {
  @override
  _ProfileLoginState createState() => _ProfileLoginState();
}

class _ProfileLoginState extends State<ProfileLogin> {
  bool _isKakao = false;

  @override
  void initState() {
    super.initState();
    _isKakaoInstalled();
  }

  void _isKakaoInstalled() async {
    final installed = await isKakaoTalkInstalled();
    setState(() {
      _isKakao = installed;
    });
  }

  _accessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
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
      print(code.toString());
    } catch (e) {
      print(e);
    }
  }

  _userData() async {
    try {
      User user = await UserApi.instance.me();
      print('user.toString() ${user.toString()}');
      print('user.hassignedup ${user.hasSignedUp}');
      print('user.id ${user.id}');
      print('user.groupUserToken ${user.groupUserToken}');
    } catch (e) {
      print('UserData method Error : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              titleSpacing: 0.0,
              elevation: 0.0,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  "로그인",
                  style: TextStyle(
                      color: kTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              leading: IconButton(
                  icon: Icon(
                    Icons.navigate_before,
                    color: kTextColor,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              floating: true,
              backgroundColor: Colors.white,
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: <Widget>[
                  Center(
                    child: Container(
                      color: Colors.yellow,
                      child: FlatButton(
                        onPressed: () {
                          _isKakao ? _loginInstalled() : _loginUninstalled();
                        },
                        child: Text("KaKaoLogin"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      color: Colors.yellow,
                      child: FlatButton(
                        onPressed: () {
                          _userData();
                        },
                        child: Text("User"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      color: Colors.yellow,
                      child: FlatButton(
                        onPressed: () {
                          _logout();
                        },
                        child: Text("Logout"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      color: Colors.yellow,
                      child: FlatButton(
                        onPressed: () {
                          _unlink();
                        },
                        child: Text("unlink"),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
