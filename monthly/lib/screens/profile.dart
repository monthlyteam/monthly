import 'package:flutter/material.dart';
import 'package:monthly/constants.dart';
import 'profile_login.dart';
import 'profile_question.dart';
import 'profile_settings.dart';

class Profile extends StatelessWidget {
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
                  Icon(
                    Icons.account_circle,
                    color: kTextColor.withOpacity(0.7),
                    size: 110.0,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileLogin()),
                      );
                    },
                    child: Container(
                      width: 140,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "지금 먼슬리 로그인",
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
                                builder: (context) => ProfileSettings()),
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
                                Icons.settings,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "환경설정",
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileQuestion()),
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
                                Icons.help,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "문의",
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
