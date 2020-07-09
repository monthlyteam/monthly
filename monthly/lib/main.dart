import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(fontFamily: 'NanumGothic'),
      home: DashBoard(),
    );
  }
}

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              titleSpacing: 0.0,
              centerTitle: false,
              actions: <Widget>[
                PopupMenuButton<String>(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  onSelected: (String sel) {
                    setState(() {
                      print(sel);
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: "detail",
                      child: Text('detail'),
                    ),
                  ],
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.black,
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
                      color: Colors.black,
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
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken),
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
                          color: const Color(0xff19a2b5),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: [
          new BottomNavigationBarItem(
            icon: new SvgPicture.asset(
              'icons/bar_chart.svg',
              height: 24.0,
              color: _selectedIndex == 0 ? Colors.red : Colors.grey[600],
            ),
            title: Text("Dash Board"),
          ),
          new BottomNavigationBarItem(
            icon: new SvgPicture.asset(
              'icons/addchart.svg',
              height: 24.0,
              color: _selectedIndex == 1 ? Colors.red : Colors.grey[600],
            ),
            title: Text("Stock List"),
          ),
          new BottomNavigationBarItem(
            icon: new SvgPicture.asset(
              'icons/calendar.svg',
              height: 24.0,
              color: _selectedIndex == 2 ? Colors.red : Colors.grey[600],
            ),
            title: Text("Calendar"),
          ),
          new BottomNavigationBarItem(
            icon: new SvgPicture.asset(
              'icons/person.svg',
              height: 24.0,
              color: _selectedIndex == 3 ? Colors.red : Colors.grey[600],
            ),
            title: Text("Profile"),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0.0,
        unselectedFontSize: 0.0,
        onTap: _onItemTapped,
      ),
    );
  }
}
