import 'package:flutter/material.dart';
import 'package:monthly/constants.dart';
import 'package:monthly/screens/profile_info_license.dart';
import 'package:monthly/stock.dart';
import 'package:provider/provider.dart';

class ProfileInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              titleSpacing: 0.0,
              elevation: 0.0,
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  "정보",
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
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "달러 환율",
                          style: TextStyle(
                              fontSize: 18,
                              color: kTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${context.watch<Stock>().dollar}',
                          style: TextStyle(fontSize: 18, color: kTextColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "배당 소득세",
                          style: TextStyle(
                              fontSize: 18,
                              color: kTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '0%',
                          style: TextStyle(fontSize: 18, color: kTextColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.maxFinite,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Text(
                                '"달러 환율은 실시간 매매기준율을 사용 하며, 증권사 환율과 다를 수 있습니다."',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    height: 1.4,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Text(
                                '"부정확한 주식(특히 한국 주식 관련) 정보가 있을 수 있습니다. 해당 문제는 메일 문의 주시면 빠른 시일 안에 해결하겠습니다."',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    height: 1.4,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Text(
                                '"예상 배당금 차트는 배당 지급일이 아닌 배당락일 정보를 기준으로 계산되었습니다. 추후 주식 정보량을 늘려 계선하겠습니다."',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    height: 1.4,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Text(
                                '"기타 문의  ( youngthly@gmail.com )"',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    height: 1.4,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      decoration: new BoxDecoration(
                        color: kMainColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileInfoLicense()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "License Information",
                            style: TextStyle(
                                color: kTextColor.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                          Icon(
                            Icons.navigate_next,
                            color: kTextColor.withOpacity(0.6),
                            size: 25.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ]))
          ],
        ),
      ),
    );
  }
}
