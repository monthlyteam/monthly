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
  String type, title;
  int len;
  List<int> imgList;
  _DashBoardsHelpState({this.type, this.len}) {
    imgList = new List<int>.generate(len, (i) => i + 1);
    setTitle();
  }
  void setTitle() {
    switch (type) {
      case "add":
        title = "도움말(주식 추가)";
        break;
      case "edit":
        title = "도움말(주식 수정)";
        break;
      case "cal":
        title = "도움말(달력 이용)";
        break;
      case "kakao":
        title = "도움말(데이터 백업)";
        break;
      default:
        title = "도움말";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        leading: SizedBox(
          height: 28.0,
          width: 28.0,
          child: IconButton(
            padding: EdgeInsets.all(0.0),
            icon: Icon(
              Icons.navigate_before,
              color: kTextColor,
              size: 30,
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
                    title = "도움말(주식 추가)";
                    break;
                  case "edit":
                    type = "edit";
                    len = 5;
                    title = "도움말(주식 수정)";
                    break;
                  case "cal":
                    type = "cal";
                    len = 3;
                    title = "도움말(달력 이용)";
                    break;
                  case "kakao":
                    type = "kakao";
                    len = 3;
                    title = "도움말(데이터 백업)";
                    break;
                  default:
                    title = "도움말";
                    break;
                }
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: "add",
                child: Text('주식 추가 방법'),
              ),
              const PopupMenuItem<String>(
                value: "edit",
                child: Text('주식 수정 방법'),
              ),
              const PopupMenuItem<String>(
                value: "cal",
                child: Text('달력 이용 방법'),
              ),
              // TODO: KAKAO DISABLED
              // const PopupMenuItem<String>(
              //   value: "kakao",
              //   child: Text('데이터 백업 방법'),
              // ),
            ],
            icon: Icon(
              Icons.help_outline,
              color: Colors.black.withOpacity(0.3),
              size: 24.0,
            ),
          ),
        ],
        elevation: 0.0,
        title: Text(
          title,
          style: TextStyle(
              color: kTextColor, fontWeight: FontWeight.bold, fontSize: 20),
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
              enableInfiniteScroll: false,
              // autoPlay: false,
            ),
          ),
        ),
      ),
    );
  }
}
