import 'package:flutter/material.dart';
import 'package:monthly/constants.dart';
import 'package:monthly/stock.dart';
import 'package:provider/provider.dart';

class DashBoardsLevel extends StatelessWidget {
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
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  "내 먼슬리 레벨",
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
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: 25,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        index == 0
                            ? SizedBox()
                            : Icon(
                                Icons.arrow_drop_up,
                                size: 40,
                              ),
                        Container(
                          height: 240.0,
                          decoration: new BoxDecoration(
                            border: index == 1
                                ? Border.all(
                                    color: Color(0xffF25B7F),
                                    width: 5.0,
                                  )
                                : null,
                            color: Colors.grey.withOpacity(0.1),
                            image: DecorationImage(
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.3),
                                  BlendMode.darken),
                              fit: BoxFit.fitWidth,
                              image: AssetImage(
                                '${context.watch<Stock>().levelCard[index][2]}',
                              ),
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 25.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "월 평균 배당금",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20.0,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "￦${(context.watch<Stock>().levelCard[index][0]).toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}~",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 40.0,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Text(
                                  "${context.watch<Stock>().levelCard[index][1]}",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  childCount: context.watch<Stock>().levelCard.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
