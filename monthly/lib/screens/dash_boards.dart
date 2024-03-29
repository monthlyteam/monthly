import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monthly/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:monthly/screens/dash_boards_level.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:admob_flutter/admob_flutter.dart';

import '../my_stock.dart';
import '../stock.dart';
import 'dash_boards_help.dart';

class DashBoards extends StatefulWidget {
  @override
  _DashBoardsState createState() => _DashBoardsState();
}

class _DashBoardsState extends State<DashBoards> {
  int barTouchedIndex = DateTime.now().month - 1;
  int piTouchedIndex = 0;
  int piDivTouchedIndex = 0;
  double avgPoint = 0;
  String admobBannerId = '';
  var banner;

  @override
  void initState() {
    super.initState();
    admobBannerId = Platform.isIOS
        ? 'ca-app-pub-1325163385377987/9713437057'
        : 'ca-app-pub-1325163385377987/3894134167';
    banner = AdmobBanner(
      adUnitId: admobBannerId,
      adSize: AdmobBannerSize.FULL_BANNER,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (context.read<Stock>().notionVersion == "1.0.4") {
        //1.0.5에서 1.0.4 입력 통화 꼬임 문제 있는 사람 확인 & 조치를 위한 구문
        showDialog(
            context: context,
            builder: (BuildContext bContext) {
              return AlertDialog(
                insetPadding: EdgeInsets.all(8.0),
                title: Text(
                  "먼슬리 공지 사항",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: kTextColor),
                ),
                content: Text(
                  "미국주식 매입 통화 설정을 하신적이 있나요?\n현재 설정 중인 입력 통화 단위를 선택해주세요.\n\n선택한 값을 통해 분석되며, 추후 변경은 내 프로필 - 미국주식 매입 통화 설정을 통해 변경해주세요.",
                  style: TextStyle(color: kTextColor),
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(bContext).pop();

                      context.read<Stock>().setIsInputAvgDollar(false);
                    },
                    child: Text("원화(￦)"),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(bContext).pop();

                      context.read<Stock>().setIsInputAvgDollar(true);
                    },
                    child: Text("달러(\$)"),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(bContext).pop();

                      context.read<Stock>().setIsInputAvgDollar(false);
                    },
                    child: Text("설정안함"),
                  ),
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
              );
            });
      }
      context.read<Stock>().setNotionVersion("1.0.5");
    });
  }

  List<BarChartGroupData> showingGroups() => List.generate(12, (i) {
        final isTouched = i == barTouchedIndex;
        final barColor = isTouched ? kMainColor : Color(0xfff2d49b);
        final barWidth = isTouched ? 12.0 : 10.0;
        final double monthDividends =
            context.watch<Stock>().monthlyDividends[i];
        final List<int> showTooltips = [
          isTouched && monthDividends != 0 ? 0 : 1
        ];
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
        color: kColorList[i % kColorList.length],
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

  List<PieChartSectionData> showingDivSections() {
    return List.generate(context.watch<Stock>().stockList.length, (i) {
      final isTouched = i == piDivTouchedIndex;
      final double fontSize = isTouched ? 30 : 20;
      final double radius = isTouched ? 85 : 70;
      MyStock mStock = context.watch<Stock>().stockList[i];
      String title = (context.watch<Stock>().stockList.length > 2 &&
              mStock.totalDivPercent.round() < 5)
          ? ""
          : "${mStock.totalDivPercent.round()}%";
      if (isTouched) {
        title = "${mStock.totalDivPercent.round()}%";
      }
      return PieChartSectionData(
        color: kColorList[kColorList.length - 1 - (i % kColorList.length)],
        value: mStock.totalDivPercent,
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
              color: kColorList[i % kColorList.length],
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

  List<Row> showingDivSectionTitle() {
    return List.generate(context.watch<Stock>().stockList.length, (i) {
      final isTouched = i == piDivTouchedIndex;
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
              color:
                  kColorList[kColorList.length - 1 - (i % kColorList.length)],
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            "${mStock.totalDivPercent.round()}% ",
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
        if (avg.round() == 0) {
          cnt--;
          avgPoint = 5 * pow(10, cnt);
          if (avg < 0.25) {
            avgPoint = pow(10, cnt);
          }
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
                  switch (sel) {
                    case "add":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashBoardsHelp(
                                  type: "add",
                                  len: 7,
                                )),
                      );
                      break;
                    case "edit":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashBoardsHelp(
                                  type: "edit",
                                  len: 5,
                                )),
                      );
                      break;
                    case "cal":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashBoardsHelp(
                                  type: "cal",
                                  len: 3,
                                )),
                      );
                      break;
                    case "kakao":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashBoardsHelp(
                                  type: "kakao",
                                  len: 2,
                                )),
                      );
                      break;
                    default:
                      break;
                  }
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
                  const PopupMenuItem<String>(
                    value: "kakao",
                    child: Text('데이터 백업 방법'),
                  ),
                ],
                icon: Icon(
                  Icons.help_outline,
                  color: Colors.black.withOpacity(0.3),
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
                                overflow: TextOverflow.ellipsis,
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
                            Expanded(
                              child: Container(
                                width: 175,
                                child: Text(
                                  "￦${context.watch<Stock>().thisMonthDividend}",
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      fontSize: 20.0),
                                ),
                              ),
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
                      height: 20.0,
                    ),
                    Container(
                      height: 130.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "투자 금액",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                                Container(
                                  width: 190,
                                  child: Text(
                                    "￦${context.watch<Stock>().totalInvestPrice}",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        fontSize: 20.0),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "평가 금액",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                                Container(
                                  width: 190,
                                  child: Text(
                                    "￦${context.watch<Stock>().totalEvaPrice}",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        fontSize: 20.0),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "평가 손익",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                                Container(
                                  width: 190,
                                  child: Text(
                                    "￦${context.watch<Stock>().totalEvaProfit}",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        fontSize: 20.0),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "(${context.watch<Stock>().totalEvaProfitPercent}%)",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  fontSize: 15.0),
                            ),
                          ],
                        ),
                      ),
                      decoration: new BoxDecoration(
                        color: kSubColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    // ignore: unrelated_type_equality_checks
                    context.watch<Stock>().stockList.length != 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              context.watch<Stock>().avgDividend != "0"
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "예상 배당금 차트",
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
                                                  alignment: BarChartAlignment
                                                      .spaceAround,
                                                  barTouchData: BarTouchData(
                                                    touchTooltipData:
                                                        BarTouchTooltipData(
                                                      tooltipBgColor:
                                                          kMainColor,
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
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.0),
                                                        );
                                                      },
                                                    ),
                                                    touchCallback:
                                                        (barTouchResponse) {
                                                      setState(() {
                                                        if (barTouchResponse
                                                                    .spot !=
                                                                null &&
                                                            barTouchResponse
                                                                    .touchInput
                                                                is! FlPanEnd &&
                                                            barTouchResponse
                                                                    .touchInput
                                                                is! FlLongPressEnd) {
                                                          barTouchedIndex =
                                                              barTouchResponse
                                                                  .spot
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
                                                          color: kTextColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12),
                                                      margin: 10,
                                                      getTitles:
                                                          (double value) {
                                                        return '${(value).toInt() + 1}';
                                                      },
                                                    ),
                                                    leftTitles: SideTitles(
                                                      showTitles: true,
                                                      textStyle: TextStyle(
                                                          color: kTextColor,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      margin: 15.0,
                                                      getTitles: (value) {
                                                        calcPoint();
                                                        if (value == 0) {
                                                          return '0';
                                                        } else if (value ==
                                                            avgPoint) {
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
                                                    checkToShowHorizontalLine:
                                                        (value) =>
                                                            value % avgPoint ==
                                                                0 &&
                                                            value <=
                                                                2 * avgPoint,
                                                    getDrawingHorizontalLine:
                                                        (value) => FlLine(
                                                      color: const Color(
                                                          0xff2a2747),
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
                                      ],
                                    )
                                  : Container(),
                              context.watch<Stock>().totalEvaPrice != "0"
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "평가 자산 비율",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: kTextColor,
                                              fontSize: 20),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        AspectRatio(
                                          aspectRatio: 1.1,
                                          child: Card(
                                            elevation: 0.0,
                                            color: Colors.white,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: PieChart(
                                                      PieChartData(
                                                          startDegreeOffset:
                                                              -90,
                                                          pieTouchData:
                                                              PieTouchData(
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
                                                          borderData:
                                                              FlBorderData(
                                                            show: false,
                                                          ),
                                                          sectionsSpace: 0.0,
                                                          centerSpaceRadius:
                                                              60.0,
                                                          sections:
                                                              showingSections()),
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
                                          height: 60.0,
                                        ),
                                      ],
                                    )
                                  : Container(),
                              context.watch<Stock>().avgDividend != "0"
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "배당금 비율",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: kTextColor,
                                              fontSize: 20),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        AspectRatio(
                                          aspectRatio: 1.1,
                                          child: Card(
                                            elevation: 0.0,
                                            color: Colors.white,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: PieChart(
                                                      PieChartData(
                                                          startDegreeOffset:
                                                              -90,
                                                          pieTouchData:
                                                              PieTouchData(
                                                                  touchCallback:
                                                                      (pieTouchResponse) {
                                                            setState(() {
                                                              if (pieTouchResponse
                                                                      .touchedSectionIndex !=
                                                                  null) {
                                                                piDivTouchedIndex =
                                                                    pieTouchResponse
                                                                        .touchedSectionIndex;
                                                              }
                                                            });
                                                          }),
                                                          borderData:
                                                              FlBorderData(
                                                            show: false,
                                                          ),
                                                          sectionsSpace: 0.0,
                                                          centerSpaceRadius:
                                                              60.0,
                                                          sections:
                                                              showingDivSections()),
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
                                              children:
                                                  showingDivSectionTitle(),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 40.0,
                                        ),
                                        Container(
                                          color: Colors.white,
                                          margin: EdgeInsets.only(bottom: 20.0),
                                          child: banner,
                                        ),
                                      ],
                                    )
                                  : Container(),
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
