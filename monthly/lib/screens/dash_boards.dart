import 'dart:math';

import 'package:flutter/material.dart';
import 'package:monthly/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../stock.dart';

class DashBoards extends StatefulWidget {
  @override
  _DashBoardsState createState() => _DashBoardsState();
}

class _DashBoardsState extends State<DashBoards> {
  int barTouchedIndex = DateTime.now().month - 1;
  int piTouchedIndex = 0;

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = const Color(0xfff2d49b),
    double width = 10.0,
  }) {
    List<int> showTooltips = [isTouched ? 0 : 1];
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          color: isTouched ? Color(0xff84BFA4) : barColor,
          width: isTouched ? width + 2 : width,
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(12, (i) {
        print(context.watch<Stock>().monthlyDividends.reduce(max));
        switch (i) {
          case 0:
            return makeGroupData(0, 20.32, isTouched: i == barTouchedIndex);
          case 1:
            return makeGroupData(1, 0, isTouched: i == barTouchedIndex);
          case 2:
            return makeGroupData(2, 16.62, isTouched: i == barTouchedIndex);
          case 3:
            return makeGroupData(3, 10.34, isTouched: i == barTouchedIndex);
          case 4:
            return makeGroupData(4, 12.62, isTouched: i == barTouchedIndex);
          case 5:
            return makeGroupData(5, 13.22, isTouched: i == barTouchedIndex);
          case 6:
            return makeGroupData(6, 9.66, isTouched: i == barTouchedIndex);
          case 7:
            return makeGroupData(7, 10.32, isTouched: i == barTouchedIndex);
          case 8:
            return makeGroupData(8, 12.54, isTouched: i == barTouchedIndex);
          case 9:
            return makeGroupData(9, 13.74, isTouched: i == barTouchedIndex);
          case 10:
            return makeGroupData(10, 11.66, isTouched: i == barTouchedIndex);
          case 11:
            return makeGroupData(11, 16.54, isTouched: i == barTouchedIndex);
          default:
            return null;
        }
      });

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == piTouchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 70 : 60;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }

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
                              "￦ ${context.watch<Stock>().avgDividend}",
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
                                  "${DateTime.now().month}",
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
                              "￦ ${context.watch<Stock>().thisMonthDividend}",
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
                          fontSize: 20),
                    ),
                    AspectRatio(
                      aspectRatio: 1.7,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BarChart(
                          BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 30,
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor: Color(0xff84BFA4),
                                  tooltipPadding: const EdgeInsets.only(
                                      top: 6.0, left: 6.0, right: 4.0),
                                  tooltipBottomMargin: 4,
                                  getTooltipItem: (
                                    BarChartGroupData group,
                                    int groupIndex,
                                    BarChartRodData rod,
                                    int rodIndex,
                                  ) {
                                    return BarTooltipItem(
                                      "${context.read<Stock>().monthlyDividends[barTouchedIndex].round().toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                      TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0),
                                    );
                                  },
                                ),
                                touchCallback: (barTouchResponse) {
                                  setState(() {
                                    if (barTouchResponse.spot != null &&
                                        barTouchResponse.touchInput
                                            is! FlPanEnd &&
                                        barTouchResponse.touchInput
                                            is! FlLongPressEnd) {
                                      barTouchedIndex = barTouchResponse
                                          .spot.touchedBarGroupIndex;
                                    }
                                  });
                                },
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: SideTitles(
                                  showTitles: true,
                                  textStyle: TextStyle(
                                      color: const Color(0xff2C2C2C),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                  margin: 10,
                                  getTitles: (double value) {
                                    return '${(value).toInt() + 1}';
                                  },
                                ),
                                leftTitles: SideTitles(
                                  showTitles: true,
                                  textStyle: TextStyle(
                                      color: const Color(0xff2c2c2c),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                  margin: 15.0,
                                  getTitles: (value) {
                                    if (value == 0) {
                                      return '0';
                                    } else if (value == 10) {
                                      return '5k';
                                    } else if (value == 20) {
                                      return '10k';
                                    } else {
                                      return '';
                                    }
                                  },
                                ),
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              gridData: FlGridData(
                                show: true,
                                checkToShowHorizontalLine: (value) =>
                                    value % 10 == 0,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: const Color(0xff2a2747),
                                    strokeWidth: 0.3,
                                  );
                                },
                              ),
                              barGroups: showingGroups()),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Text(
                      "종목 비율",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kTextColor,
                          fontSize: 20),
                    ),
                    AspectRatio(
                      aspectRatio: 1.1,
                      child: Card(
                        elevation: 0.0,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: PieChart(
                                  PieChartData(
                                      pieTouchData: PieTouchData(
                                          touchCallback: (pieTouchResponse) {
                                        setState(() {
                                          if (pieTouchResponse
                                                  .touchedSectionIndex !=
                                              null) {
                                            piTouchedIndex = pieTouchResponse
                                                .touchedSectionIndex;
                                          }
                                          print(piTouchedIndex);
                                        });
                                      }),
                                      borderData: FlBorderData(
                                        show: false,
                                      ),
                                      sectionsSpace: 0.0,
                                      centerSpaceRadius: 40.0,
                                      sections: showingSections()),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  direction: Axis.horizontal,
                                  spacing: 10.0,
                                  children: <Widget>[
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: piTouchedIndex == 0
                                                  ? 0.0
                                                  : 2.0),
                                          width:
                                              piTouchedIndex == 0 ? 14.0 : 10.0,
                                          height:
                                              piTouchedIndex == 0 ? 14.0 : 10.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xff0293ee),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          '005930 삼성전자',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: piTouchedIndex == 0
                                                  ? FontWeight.bold
                                                  : FontWeight.w400,
                                              color: Color(0xff2c2c2c)),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: piTouchedIndex == 1
                                                  ? 0.0
                                                  : 2.0),
                                          width:
                                              piTouchedIndex == 1 ? 14.0 : 10.0,
                                          height:
                                              piTouchedIndex == 1 ? 14.0 : 10.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xfff8b250),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          'SBUX Starbucks',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: piTouchedIndex == 1
                                                  ? FontWeight.bold
                                                  : FontWeight.w400,
                                              color: Color(0xff2c2c2c)),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: piTouchedIndex == 2
                                                  ? 0.0
                                                  : 2.0),
                                          width:
                                              piTouchedIndex == 2 ? 14.0 : 10.0,
                                          height:
                                              piTouchedIndex == 2 ? 14.0 : 10.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xff845bef),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          'AAPL Appdddle',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: piTouchedIndex == 2
                                                  ? FontWeight.bold
                                                  : FontWeight.w400,
                                              color: Color(0xff2c2c2c)),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: piTouchedIndex == 3
                                                  ? 0.0
                                                  : 2.0),
                                          width:
                                              piTouchedIndex == 3 ? 14.0 : 10.0,
                                          height:
                                              piTouchedIndex == 3 ? 14.0 : 10.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xff13d38e),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          'T AT&T',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: piTouchedIndex == 3
                                                  ? FontWeight.bold
                                                  : FontWeight.w400,
                                              color: Color(0xff2c2c2c)),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
