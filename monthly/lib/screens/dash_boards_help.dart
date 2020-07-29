import 'package:flutter/material.dart';
import 'package:monthly/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DashBoardsHelp extends StatefulWidget {
  final String type;
  final int len;

  DashBoardsHelp({this.type, this.len});
  @override
  _DashBoardsHelpState createState() =>
      _DashBoardsHelpState(type: type, len: len);
}

class _DashBoardsHelpState extends State<DashBoardsHelp> {
  CarouselController carController = CarouselController();
  double height;
  String type;
  int len;
  List<int> imgList;
  _DashBoardsHelpState({this.type, this.len}) {
    imgList = new List<int>.generate(len, (i) => i + 1);
  }
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(
          height: 28.0,
          width: 28.0,
          child: IconButton(
            padding: EdgeInsets.all(0.0),
            iconSize: 28.0,
            icon: Icon(
              Icons.arrow_back_ios,
              color: kTextColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        titleSpacing: 0.0,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            offset: Offset(0.0, 50.0),
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            onSelected: (String sel) {
              setState(() {
                carController.jumpToPage(0);
                switch (sel) {
                  case "add":
                    type = "add";
                    len = 7;
                    break;
                  case "edit":
                    type = "edit";
                    len = 5;
                    break;
                  case "cal":
                    type = "cal";
                    len = 3;
                    break;
                  case "kakao":
                    type = "kakao";
                    len = 3;
                    break;
                  default:
                    break;
                }
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: "add",
                child: Text('주식 추가'),
              ),
              const PopupMenuItem<String>(
                value: "edit",
                child: Text('주식 수정'),
              ),
              const PopupMenuItem<String>(
                value: "cal",
                child: Text('달력'),
              ),
              const PopupMenuItem<String>(
                value: "kakao",
                child: Text('데이터 백업'),
              ),
            ],
            icon: Icon(
              Icons.help_outline,
              color: Colors.grey,
              size: 28.0,
            ),
          ),
        ],
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(
            "도움말",
            style: TextStyle(
                color: kTextColor, fontWeight: FontWeight.bold, fontSize: 27),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: CarouselSlider.builder(
            carouselController: carController,
            itemCount: len,
            itemBuilder: (BuildContext context, int index) => Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.asset(
                    'images/help/$type${index + 1}.png',
                    fit: BoxFit.cover,
                    height: height,
                  ),
                ),
              ),
            ),
            options: CarouselOptions(
              initialPage: 0,
              height: height,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              // autoPlay: false,
            ),
          ),
        ),
      ),
    );
  }
}
