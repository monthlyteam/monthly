import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monthly/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:monthly/screens/dash_boards_level.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../my_stock.dart';
import '../stock.dart';

class DashBoards extends StatefulWidget {
  @override
  _DashBoardsState createState() => _DashBoardsState();
}

class _DashBoardsState extends State<DashBoards> {
  int barTouchedIndex = DateTime.now().month - 1;
  int piTouchedIndex = 0;
  double avgPoint = 0;

  @override
  void initState() {
    calcPoint();
    super.initState();
  }

  List<BarChartGroupData> showingGroups() => List.generate(12, (i) {
        final isTouched = i == barTouchedIndex;
        final barColor = isTouched ? Color(0xff84BFA4) : Color(0xfff2d49b);
        final barWidth = isTouched ? 12.0 : 10.0;
        final List<int> showTooltips = [isTouched ? 0 : 1];
        final double monthDividends =
            context.watch<Stock>().monthlyDividends[i];
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              y: monthDividends,
              color: barColor,
              width: barWidth,
            ),
          ],
          showingTooltipIndicators: showTooltips,
        );
      });

  List<PieChartSectionData> showingSections() {
    return List.generate(context.watch<Stock>().stockList.length, (i) {
      final isTouched = i == piTouchedIndex;
      final double fontSize = isTouched ? 30 : 20;
      final double radius = isTouched ? 85 : 70;
      MyStock mStock = context.watch<Stock>().stockList[i];
      String title = (context.watch<Stock>().stockList.length > 2 &&
              mStock.percent.round() < 5)
          ? ""
          : "${mStock.percent.round()}%";
      if (isTouched) {
        title = "${mStock.percent.round()}%";
      }
      return PieChartSectionData(
        color: kColorList[i % 20],
        value: mStock.percent,
        title: title,
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );
    });
  }

  List<Row> showingSectionTitle() {
    return List.generate(context.watch<Stock>().stockList.length, (i) {
      final isTouched = i == piTouchedIndex;
      final double marginSize = isTouched ? 0.0 : 2.0;
      final double containerSize = 14.0 - (marginSize * 2.0);
      final FontWeight textFontWeight =
          isTouched ? FontWeight.bold : FontWeight.w400;
      MyStock mStock = context.watch<Stock>().stockList[i];
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: marginSize),
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kColorList[i % 20],
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            "${mStock.percent.round()}% ",
            style: TextStyle(
                fontSize: 12.0,
                fontWeight: textFontWeight,
                color: Color(0xff2c2c2c)),
          ),
          Flexible(
            child: Text(
              '${mStock.ticker} ${mStock.name}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: textFontWeight,
                  color: Color(0xff2c2c2c)),
            ),
          )
        ],
      );
    });
  }

  void calcPoint() {
    double cnt = 0;
    double avg =
        context.read<Stock>().monthlyDividends.reduce((a, b) => a + b) / 12.0;
    while (true) {
      avg /= 10.0;
      cnt++;
      if (avg <= 1.0) {
        if (avg.roundToDouble() == 0.0) {
          cnt--;
          avgPoint = 5 * pow(10, cnt);
        } else {
          avgPoint = pow(10, cnt);
        }
        if (avgPoint * 2 >=
            context.read<Stock>().monthlyDividends.reduce(max)) {
          avgPoint = avgPoint / 2;
        }
        break;
      }
    }
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
                  setState(() {});
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashBoardsLevel()),
                        );
                      },
                      child: Container(
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
                                  fontSize: 25.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "￦${context.watch<Stock>().avgDividend}",
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
                                "${kMonthlyLevel[context.watch<Stock>().level][1]}",
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        height: 240.0,
                        decoration: new BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          image: DecorationImage(
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken),
                            fit: BoxFit.fitWidth,
                            image: AssetImage(
                                '${kMonthlyLevel[context.watch<Stock>().level][2]}'),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 60.0,
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
                                      fontSize: 24.0),
                                ),
                                Text(
                                  "월 배당금",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
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
                    context.watch<Stock>().avgDividend != '0'
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "월 차트",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kTextColor,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              AspectRatio(
                                aspectRatio: 1.7,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: BarChart(
                                    BarChartData(
                                        alignment:
                                            BarChartAlignment.spaceAround,
                                        barTouchData: BarTouchData(
                                          touchTooltipData: BarTouchTooltipData(
                                            tooltipBgColor: Color(0xff84BFA4),
                                            tooltipPadding:
                                                const EdgeInsets.only(
                                                    top: 6.0,
                                                    left: 6.0,
                                                    right: 4.0),
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
                                              if (barTouchResponse.spot !=
                                                      null &&
                                                  barTouchResponse.touchInput
                                                      is! FlPanEnd &&
                                                  barTouchResponse.touchInput
                                                      is! FlLongPressEnd) {
                                                barTouchedIndex =
                                                    barTouchResponse.spot
                                                        .touchedBarGroupIndex;
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
                                              } else if (value == avgPoint) {
                                                return '${NumberFormat.compact().format(avgPoint)}';
                                              } else if (value ==
                                                  2 * avgPoint) {
                                                return '${NumberFormat.compact().format(2 * avgPoint)}';
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
                                              value % avgPoint == 0 &&
                                              value <= 2 * avgPoint,
                                          getDrawingHorizontalLine: (value) =>
                                              FlLine(
                                            color: const Color(0xff2a2747),
                                            strokeWidth: 0.3,
                                          ),
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
                                                startDegreeOffset: -90,
                                                pieTouchData: PieTouchData(
                                                    touchCallback:
                                                        (pieTouchResponse) {
                                                  setState(() {
                                                    if (pieTouchResponse
                                                            .touchedSectionIndex !=
                                                        null) {
                                                      piTouchedIndex =
                                                          pieTouchResponse
                                                              .touchedSectionIndex;
                                                    }
                                                  });
                                                }),
                                                borderData: FlBorderData(
                                                  show: false,
                                                ),
                                                sectionsSpace: 0.0,
                                                centerSpaceRadius: 60.0,
                                                sections: showingSections()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    direction: Axis.horizontal,
                                    spacing: 10.0,
                                    children: showingSectionTitle(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 80.0,
                              ),
                            ],
                          )
                        : Container(),
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
