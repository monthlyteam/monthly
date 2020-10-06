import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monthly/constants.dart';
import 'package:http/http.dart' as http;

class HomeError extends StatefulWidget {
  final String id;
  final String errorText;
  final String statusCode;

  HomeError({this.id, this.errorText, this.statusCode});

  @override
  _HomeErrorState createState() => _HomeErrorState();
}

class _HomeErrorState extends State<HomeError> {
  bool flag = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(
                flex: 3,
              ),
              Image(image: AssetImage('images/grey_Icon.png')),
              Spacer(),
              Container(
                decoration: new BoxDecoration(
                    color: kMainColor.withOpacity(0.15),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "먼슬리 오류",
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: kTextColor),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "먼슬리 앱을 시작하는데 에러가 발생했습니다. 네트워크 연결 상태를 확인해 주시고, 앱을 종료 후 다시 켜주세요.",
                        style: TextStyle(
                            height: 1.3, fontSize: 17, color: kTextColor),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "지속적으로 오류가 발생 한다면",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: kTextColor),
                        ),
                      ),
                      Text(
                        "아래 리포트 보내기를 통해 해당 문제를 알려주시면 확인 후 최대한 빠르게 해결할 수 있도록 노력하겠습니다. 사용에 불편을 드려 죄송합니다.",
                        style: TextStyle(
                            height: 1.3, fontSize: 17, color: kTextColor),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "리포트를 보내면 투자자님의 먼슬리 앱 정보 및 에러 코드가 전송됩니다.",
                              style: TextStyle(fontSize: 12, color: kTextColor),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: flag
                                  ? InkWell(
                                      borderRadius: BorderRadius.circular(18.0),
                                      onTap: () async {
                                        var json = jsonEncode({
                                          'id': widget.id,
                                          'status': widget.statusCode,
                                          'detail': widget.errorText
                                        });
                                        try {
                                          await http.post(
                                            'http://13.125.225.138:5000/error',
                                            headers: {
                                              "content-Type": "application/json"
                                            },
                                            body: json,
                                            encoding:
                                                Encoding.getByName("utf-8"),
                                          );

                                          setState(() {
                                            flag = false;
                                          });
                                        } catch (e) {
                                          print('HomeErrorPage Error:$e');
                                        }
                                      },
                                      child: Container(
                                        width: 120,
                                        height: 40,
                                        decoration: new BoxDecoration(
                                          color: kSubColor.withOpacity(0.7),
                                          borderRadius:
                                              new BorderRadius.circular(10.0),
                                        ),
                                        child: Center(
                                            child: Text(
                                          "리포트 보내기",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: kTextColor),
                                        )),
                                      ),
                                    )
                                  : Container(
                                      width: 120,
                                      height: 40,
                                      decoration: new BoxDecoration(
                                        color: Colors.grey.withOpacity(0.6),
                                        borderRadius:
                                            new BorderRadius.circular(10.0),
                                      ),
                                      child: Center(
                                          child: Text(
                                        "전송 완료",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: kTextColor),
                                      )),
                                    )),
                        ],
                      ),
                      SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
