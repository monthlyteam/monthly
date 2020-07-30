import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monthly/constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../stock.dart';

class StockListAdd extends StatefulWidget {
  @override
  _StockListAddState createState() => _StockListAddState();
}

class _StockListAddState extends State<StockListAdd> {
  var _controller = TextEditingController();
  var data;
  bool _isLoading = false;

  Future<void> search(String input) async {
    if (input != "") {
      final response =
          await http.get('http://13.125.225.138:5000/search/$input');
      print("res : ${response.body}");
      if (response.body != "[]") {
        data = jsonDecode(response.body);
        print("response: ${data[0]}");
      } else {
        print("서버에서 이상한거 받아옴");
        data = null;
      }
    } else {
      print("입력값이 없음");
      data = null;
    }
    setState(() {});
  }

  _buildRow(int index) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          _isLoading = true;
        });

        print(
            "ticker : ${data[index]['ticker']}, name : ${data[index]['name']}");

        await context.read<Stock>().addStock(ticker: data[index]['ticker']);

        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context, data[index]['ticker']);
      },
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, right: 25.0, top: 6.0, bottom: 6.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 24.0,
              width: 24.0,
              child: IconButton(
                padding: EdgeInsets.all(0.0),
                iconSize: 20.0,
                icon: Icon(
                  Icons.search,
                  color: kTextColor.withOpacity(0.8),
                ),
                onPressed: () {},
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Flexible(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  text: '${data[index]['ticker']} - ${data[index]['name']}',
                  style: TextStyle(
                      fontSize: 12.0,
                      color: kTextColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 25.0, top: 16.0, bottom: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30.0,
                        width: 30.0,
                        child: IconButton(
                          padding: EdgeInsets.all(0.0),
                          iconSize: 30.0,
                          icon: Icon(
                            Icons.navigate_before,
                            color: kTextColor,
                          ),
                          onPressed: () {
                            Navigator.pop(context, "-1");
                          },
                        ),
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      Expanded(
                        child: Container(
                          height: 36.0,
                          child: TextField(
                              cursorColor: kTextColor,
                              controller: _controller,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: kTextColor,
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                  hintText: "티커 또는 주식명을 입력해 주세요.",
                                  hintStyle: TextStyle(fontSize: 12.0),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 12.0),
                                  filled: true,
                                  fillColor: Color(0xffE5E6EB),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  suffixIcon: Container(
                                      height: 22.0,
                                      width: 22.0,
                                      child: IconButton(
                                        padding: EdgeInsets.all(0.0),
                                        iconSize: 20.0,
                                        icon: Icon(
                                          Icons.clear,
                                          color: kTextColor.withOpacity(0.7),
                                        ),
                                        onPressed: () {
                                          _controller.clear();
                                          setState(() {
                                            data = null;
                                          });
                                        },
                                      ))),
                              onChanged: (text) {
                                search(text);
                                print("input : $text");
                              }),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  color: kTextColor.withOpacity(0.3),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: data == null ? 0 : data.length,
                    itemBuilder: (context, index) {
                      if (data != null) {
                        return this._buildRow(index);
                      } else {
                        return Container();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          Positioned(
            child: _isLoading
                ? Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "주식정보를 불러오는 중입니다.",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    color: Colors.black.withOpacity(0.5),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
