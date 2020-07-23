import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monthly/constants.dart';
import 'package:http/http.dart' as http;

class StockListAdd extends StatefulWidget {
  @override
  _StockListAddState createState() => _StockListAddState();
}

class _StockListAddState extends State<StockListAdd> {
  var _controller = TextEditingController();
  var data;

  Future<void> search(String input) async {
    if (input != "") {
      final response =
          await http.get('http://13.125.225.138:5000/search/$input');
      print("res : ${response.body}");
      if (response.body != "[]") {
        data = jsonDecode(response.body);
        print("response: ${data[0]}");
      } else {
        data = null;
      }
    } else {
      data = null;
    }
  }

  _buildRow(int index) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 25.0, top: 6.0, bottom: 6.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 24.0,
            width: 24.0,
            child: IconButton(
              padding: EdgeInsets.all(0.0),
              iconSize: 24.0,
              icon: Icon(
                Icons.search,
                color: kTextColor,
              ),
              onPressed: () {},
            ),
          ),
          SizedBox(
            width: 12.0,
          ),
          RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: '${data[index]['ticker']} ${data[index]['name']}',
              style: TextStyle(
                  fontSize: 12.0,
                  color: kTextColor,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 25.0, top: 6.0, bottom: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 24.0,
                    width: 24.0,
                    child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      iconSize: 24.0,
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: kTextColor,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                    child: Container(
                      height: 30.0,
                      child: TextField(
                          cursorColor: kTextColor,
                          controller: _controller,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: kTextColor,
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 12.0),
                              filled: true,
                              fillColor: Color(0xffE5E6EB),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              suffixIcon: Container(
                                height: 20.0,
                                width: 20.0,
                                child: IconButton(
                                    padding: EdgeInsets.all(0.0),
                                    iconSize: 20.0,
                                    icon: Icon(
                                      Icons.clear,
                                      color: kTextColor,
                                    ),
                                    onPressed: () => _controller.clear()),
                              )),
                          onChanged: (text) {
                            setState(() async {
                              await search(text);
                            });
                            print(text);
                          }),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: kTextColor,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (context, index) {
                  if (data != null) {
                    return this._buildRow(index);
                  }
                  return Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
