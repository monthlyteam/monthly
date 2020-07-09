import 'package:flutter/material.dart';
import 'package:monthly/constants.dart';

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
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  Icon(
                    Icons.account_circle,
                    color: kTextColor.withOpacity(0.7),
                    size: 110.0,
                  ),
                  Row(
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
                  SizedBox(
                    height: 250,
                  ),
                  Container(
                    height: 300,
                    color: kMainColor,
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
