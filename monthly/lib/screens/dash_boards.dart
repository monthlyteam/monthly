import 'package:flutter/material.dart';
import 'package:monthly/constants.dart';
import 'package:fl_chart/fl_chart.dart';

class DashBoards extends StatefulWidget {
  @override
  _DashBoardsState createState() => _DashBoardsState();
}

class _DashBoardsState extends State<DashBoards> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            titleSpacing: 0.0,
            centerTitle: false,
            actions: <Widget>[
              PopupMenuButton<String>(
                offset: Offset(0.0, 50.0),
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                onSelected: (String sel) {
                  setState(() {
                    print(sel);
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: "detail",
                    child: Text('detail'),
                  ),
                ],
                icon: Icon(
                  Icons.more_vert,
                  color: kTextColor,
                  size: 24.0,
                ),
              ),
            ],
            elevation: 0.0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "대시보드",
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
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              "월 평균 배당금",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "￦ 4,830",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 50.0,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              " 매월 배당금으로 초밥 한조각!",
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      height: 180.0,
                      decoration: new BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        image: DecorationImage(
                          colorFilter: new ColorFilter.mode(
                              Colors.black.withOpacity(0.3), BlendMode.darken),
                          fit: BoxFit.fitWidth,
                          image: NetworkImage(
                              'https://images.unsplash.com/photo-1562436260-126d541901e0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60'),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 50.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "7",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      fontSize: 20.0),
                                ),
                                Text(
                                  "월 배당금",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15.0),
                                ),
                              ],
                            ),
                            Text(
                              "￦ 4,830",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  fontSize: 20.0),
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
                      height: 40.0,
                    ),
                    Text(
                      "월 차트",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kTextColor,
                          fontSize: 17),
                    ),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                    Text("lala", style: TextStyle(fontSize: 200.0)),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
