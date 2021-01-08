import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monthly/my_stock.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../constants.dart';
import '../stock.dart';
import 'stock_list_add.dart';
import 'package:admob_flutter/admob_flutter.dart';

class StockList extends StatefulWidget {
  @override
  _StockListState createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  TextEditingController avgController, amountController;
  String admobBannerId = '';
  var banner;
  bool isEdit = false;
  bool _isUSADraw = false;

  @override
  void initState() {
    admobBannerId = Platform.isIOS
        ? 'ca-app-pub-1325163385377987/9713437057'
        : 'ca-app-pub-1325163385377987/3894134167';
    super.initState();
    getBanner();
  }

  void getBanner() {
    banner = AdmobBanner(
      adUnitId: admobBannerId,
      adSize: AdmobBannerSize.FULL_BANNER,
    );
  }

  void moveToSecondPage() async {
    final information = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StockListAdd()),
    );
    if (information == "-1") {
    } else if (information != null) {
      getBanner();
      var index = context
          .read<Stock>()
          .stockList
          .indexWhere((item) => item.ticker == information);
      print("indexes: $index");
      if (index == -1) {
        print("없다!");
        _showDialog(null, "error");
      } else {
        try {
          isEdit = true;
          bool isUSA = true;
          MyStock myStock = context.read<Stock>().stockList[index];
          if (myStock.ticker.contains(".KS") ||
              myStock.ticker.contains(".KQ")) {
            _showDialog(myStock, "kor");
            isUSA = false;
          }
          _showModal(myStock, isUSA, context, myStock.amount.round() == 0);
        } catch (e) {
          print("stock_list.dart moveToSecondPage(): " + e);
        }
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
            elevation: 0.0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "주식 리스트",
                style: TextStyle(
                    color: kTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 27),
              ),
            ),
            actions: <Widget>[
              PopupMenuButton<String>(
                offset: Offset(0.0, 50.0),
                onSelected: (String sel) {
                  setState(() {
                    switch (sel) {
                      case "ticker":
                        context
                            .read<Stock>()
                            .stockList
                            .sort((a, b) => a.ticker.compareTo(b.ticker));
                        break;
                      case "dividend":
                        context
                            .read<Stock>()
                            .stockList
                            .sort((a, b) => b.wDividend.compareTo(a.wDividend));
                        break;
                      case "evaPrice":
                        context
                            .read<Stock>()
                            .stockList
                            .sort((a, b) => b.wEvaPrice.compareTo(a.wEvaPrice));
                        break;
                      default:
                        break;
                    }
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: "ticker",
                    child: Text('티커'),
                  ),
                  PopupMenuItem<String>(
                    value: "dividend",
                    child: Text('배당금'),
                  ),
                  PopupMenuItem<String>(
                    value: "evaPrice",
                    child: Text('평가금액'),
                  ),
                ],
                icon: Icon(
                  Icons.sort,
                  color: kTextColor,
                  size: 24.0,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: kTextColor,
                ),
                onPressed: () {
                  moveToSecondPage();
                },
              ),
              SizedBox(
                width: 20.0,
              )
            ],
            floating: true,
            backgroundColor: Colors.white,
          ),
          context.watch<Stock>().stockList.length == 0
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage('images/grey_Icon.png')),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        '검색을 통해 주식 종목을 입력해 주세요',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xffDCDCDC),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : SliverPadding(
                  padding: EdgeInsets.all(25.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: getStockList(true),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: getStockList(false),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          color: Colors.white,
                          child: banner,
                        ),
                      ),
                    ]),
                  ),
                )
        ],
      ),
    );
  }

  List<Widget> getStockList(bool isUSA) {
    List<MyStock> tempStockList = List<MyStock>();
    for (final stock in context.watch<Stock>().stockList) {
      if (stock.ticker.contains(".KS") || stock.ticker.contains(".KQ")) {
        if (!isUSA) {
          tempStockList.add(stock);
        }
      } else {
        if (isUSA) {
          _isUSADraw = true;
          tempStockList.add(stock);
        }
      }
    }
    if (tempStockList.length > 0) {
      tempStockList.insert(0, null);
    } else {
      if (isUSA) {
        _isUSADraw = false;
      }
    }
    return List.generate(tempStockList.length, (i) {
      if (i == 0) {
        if (isUSA) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.0, right: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("미국 주식",
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
                ToggleSwitch(
                  minWidth: 35.0,
                  minHeight: 23.0,
                  fontSize: 13.0,
                  initialLabelIndex:
                      context.watch<Stock>().isStockListShowDollar ? 0 : 1,
                  activeBgColor: Color(0xff84BFA4),
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  labels: ['\$', '￦'],
                  onToggle: (index) {
                    context.read<Stock>().setIsStockListShowDollar(index == 0);
                  },
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.only(top: _isUSADraw ? 20.0 : 0.0, bottom: 8.0),
            child: Text("한국 주식",
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
          );
        }
      } else {
        MyStock mStock = tempStockList[i];
        return gestureDetector(mStock, isUSA, context);
      }
    });
  }

  GestureDetector gestureDetector(
      MyStock myStock, bool isUSA, BuildContext context) {
    bool isDollar = isUSA && context.watch<Stock>().isStockListShowDollar;
    return GestureDetector(
      onTap: () {
        isEdit = false;
        _showModal(myStock, isUSA, context, false);
      },
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: myStock.color,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        isUSA ? "티커 / 종목명" : "종목명 / 티커",
                        style: TextStyle(color: Colors.white, fontSize: 9.0),
                      ),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: isUSA
                                    ? ("${myStock.ticker}" +
                                        " " +
                                        "${myStock.name}")
                                    : ("${myStock.name}" +
                                        " " +
                                        "${myStock.ticker}"),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        myStock.frequency == -1
                            ? "연 배당금"
                            : "연 배당금 / 연 ${myStock.frequency}회",
                        style: TextStyle(color: Colors.white, fontSize: 9.0),
                      ),
                      Text(
                        myStock.frequency == -1
                            ? "￦0"
                            : isDollar
                                ? "\$${format(myStock.dividend, 2)}"
                                : "￦${format(myStock.wDividend, 1)}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "평가금액",
                        style: TextStyle(color: Colors.white, fontSize: 9.0),
                      ),
                      Text(
                        isDollar
                            ? "\$${format(myStock.evaPrice, 2)}"
                            : "￦${format(myStock.wEvaPrice, 1)}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        "보유수량",
                        style: TextStyle(color: Colors.white, fontSize: 9.0),
                      ),
                      Text(
                        "${myStock.amount} 주",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  void _showModal(
      MyStock myStock, bool isUSA, BuildContext context, bool isAdd) {
    bool isDollar = isUSA && context.read<Stock>().isStockListShowDollar;
    bool inputDollar = isUSA && context.read<Stock>().isInputAvgDollar;
    avgController = TextEditingController(
        text: inputDollar
            ? "${myStock.dAvg(isInputAvgDollar: true)}"
            : "${myStock.wAvg(isInputAvgDollar: false).round()}");
    avgController.selection = TextSelection.fromPosition(
        TextPosition(offset: avgController.text.length));
    amountController = TextEditingController(text: "${myStock.amount.round()}");
    amountController.selection = TextSelection.fromPosition(
        TextPosition(offset: amountController.text.length));
    var amount = myStock.amount;
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: isEdit ? 240 : 370,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30.0,
                    child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      iconSize: 30,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xffededed),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(54.0),
                                      child: FadeInImage(
                                          fit: BoxFit.contain,
                                          width: 54,
                                          image: myStock.logoURL == ""
                                              ? AssetImage(
                                                  'images/default_logo.png',
                                                )
                                              : NetworkImage(myStock.logoURL),
                                          placeholder: AssetImage(
                                              'images/default_logo.png')),
                                    ),
                                    height: 54,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0.0, 1.0),
                                            color: Colors.grey,
                                            blurRadius: 1.0)
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "${myStock.ticker}",
                                          style: TextStyle(
                                              color: Color(0xff2c2c2c),
                                              fontWeight: FontWeight.w800,
                                              fontSize: 20.0),
                                        ),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                child: RichText(
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                    text: "${myStock.name}",
                                                    style: TextStyle(
                                                        color: kTextColor,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                isEdit
                                    ? Container()
                                    : IconButton(
                                        iconSize: 24.0,
                                        icon: Icon(
                                          Icons.delete,
                                          color: kTextColor,
                                        ),
                                        onPressed: () {
                                          _showDialog(myStock, "del");
                                        },
                                      ),
                                isEdit
                                    ? IconButton(
                                        iconSize: 24.0,
                                        icon: Icon(
                                          Icons.check,
                                          color: kTextColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _showDialog(myStock,
                                                isAdd ? "add" : "edit");
                                          });
                                        },
                                      )
                                    : IconButton(
                                        iconSize: 24.0,
                                        icon: Icon(
                                          Icons.create,
                                          color: kTextColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isEdit = !isEdit;
                                          });
                                        },
                                      ),
                              ],
                            )
                          ],
                        ), //Row of top
                        SizedBox(height: 20.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "평가 금액",
                                    style: TextStyle(
                                        color: kTextColor, fontSize: 12.0),
                                  ),
                                  Text(
                                    isDollar
                                        ? "\$${format(myStock.closingPrice * amount, 2)}"
                                        : "￦${format(myStock.wClosingPrice * amount, 1)}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: kTextColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    myStock.frequency == -1
                                        ? "연 배당금"
                                        : "연 배당금 / 연 ${myStock.frequency}회",
                                    style: TextStyle(
                                        color: kTextColor, fontSize: 12.0),
                                  ),
                                  Text(
                                    myStock.frequency == -1
                                        ? "￦0"
                                        : isDollar
                                            ? "\$${format(myStock.yearlyDividend * amount, 2)}"
                                            : "￦${format(myStock.wYearlyDividend * amount, 1)}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: kTextColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "평균 매입 단가",
                                    style: TextStyle(
                                        color: kTextColor, fontSize: 12.0),
                                  ),
                                  isEdit
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              inputDollar ? "\$" : "￦",
                                              style: TextStyle(
                                                  color: kTextColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0),
                                            ),
                                            Expanded(
                                              child: Container(
                                                  padding: EdgeInsets.all(2.0),
                                                  height: 24.0,
                                                  child: TextField(
                                                      maxLength: 10,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                              counterText: ""),
                                                      keyboardType: TextInputType
                                                          .numberWithOptions(
                                                              decimal: true),
                                                      controller: avgController,
                                                      autofocus: true,
                                                      style: TextStyle(
                                                          color: kTextColor,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      onSubmitted: (_) =>
                                                          FocusScope.of(context)
                                                              .nextFocus())),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          isDollar
                                              ? "\$${format(myStock.dAvg(isInputAvgDollar: context.watch<Stock>().isInputAvgDollar), 2)}"
                                              : "￦${format(myStock.wAvg(isInputAvgDollar: context.watch<Stock>().isInputAvgDollar), 1)}",
                                          style: TextStyle(
                                              color: kTextColor,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                  SizedBox(
                                    height: isEdit ? 13.0 : 20.0,
                                  ),
                                  Text(
                                    "보유수량",
                                    style: TextStyle(
                                        color: kTextColor, fontSize: 12.0),
                                  ),
                                  isEdit
                                      ? Container(
                                          padding: EdgeInsets.all(2.0),
                                          height: 24.0,
                                          child: TextField(
                                              maxLength: 10,
                                              textInputAction:
                                                  TextInputAction.done,
                                              decoration: InputDecoration(
                                                  counterText: ""),
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              autofocus: true,
                                              controller: amountController,
                                              style: TextStyle(
                                                  color: kTextColor,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                              onSubmitted: (_) =>
                                                  FocusScope.of(context)
                                                      .unfocus(),
                                              onChanged: (text) {
                                                setState(() {
                                                  if (text != null) {
                                                    amount = double.parse(text);
                                                  }
                                                  print("amount : $text");
                                                });
                                              }))
                                      : Text(
                                          "${myStock.amount} 주",
                                          style: TextStyle(
                                              color: kTextColor,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  isEdit
                      ? Container()
                      : Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: myStock.color,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0))),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, left: 25.0, right: 25.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "전일 종가",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0),
                                        ),
                                        Text(
                                          isDollar
                                              ? "\$${format(myStock.closingPrice, 2)}"
                                              : "￦${format(myStock.wClosingPrice, 1)}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        Text(
                                          "예상 배당률",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0),
                                        ),
                                        Text(
                                          "${myStock.divPercent.toStringAsFixed(1)}%",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        Text(
                                          "배당금 비율",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0),
                                        ),
                                        Text(
                                          "${(myStock.totalDivPercent).toStringAsFixed(1)}%",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "평가 손익",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              "${myStock.wEvaProfit >= 0 ? "+" : "-"}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Flexible(
                                              child: Text(
                                                isDollar
                                                    ? "\$${format(myStock.evaProfit.abs(), 2)}"
                                                    : "￦${format(myStock.wEvaProfit.abs(), 1)}",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        Text(
                                          "평가 손익률",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0),
                                        ),
                                        Text(
                                          "${myStock.evaProfitPercent.toStringAsFixed(1)}%",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        Text(
                                          "자산 보유비율",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0),
                                        ),
                                        Text(
                                          "${(myStock.percent).toStringAsFixed(1)}%",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                ],
              ),
            );
          });
        });
  }

  void _showDialog(MyStock myStock, String mode) {
    String title = "";
    switch (mode) {
      case "add":
        title = "해당 종목을 추가하시겠습니까?";
        break;
      case "del":
        title = "해당 종목을 삭제하시겠습니까?";
        break;
      case "edit":
        title = "해당 종목을 수정하시겠습니까?";
        break;
      case "kor":
        title = "국내 주식은 부정확할 수 있습니다.\n정확한 서비스를 위해 노력하겠습니다.";
        break;
      case "error":
        title = "정확한 서비스를 위해 노력하겠습니다.";
        break;
      default:
        title = "서버에서 정보를 불러오는데 실패했습니다.";
        break;
    }
    showDialog(
        context: context,
        builder: (BuildContext bContext) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(8.0),
            title: myStock != null
                ? Text(
                    "${myStock.name}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: kTextColor),
                  )
                : Text(
                    "해당 주식 정보가 없습니다.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: kTextColor),
                  ),
            content: Text(
              title,
              style: TextStyle(color: kTextColor),
            ),
            actions: <Widget>[
              mode == "kor" || mode == "error"
                  ? Container()
                  : FlatButton(
                      onPressed: () {
                        Navigator.of(bContext).pop();
                      },
                      child: Text("아니요"),
                    ),
              FlatButton(
                onPressed: () {
                  if (mode == "add") {
                    context.read<Stock>().modifyStock(
                        ticker: myStock.ticker,
                        avg: double.parse(avgController.text),
                        amount: double.parse(amountController.text));
                    Navigator.of(bContext).pop();
                    Navigator.of(context).pop();
                  } else if (mode == "del") {
                    Navigator.of(bContext).pop();
                    Navigator.of(context).pop();
                    context.read<Stock>().deleteStock(ticker: myStock.ticker);
                  } else if (mode == "edit") {
                    isEdit = !isEdit;
                    context.read<Stock>().modifyStock(
                        ticker: myStock.ticker,
                        avg: double.parse(avgController.text),
                        amount: double.parse(amountController.text));
                    Navigator.of(bContext).pop();
                  } else {
                    Navigator.of(bContext).pop();
                  }
                },
                child: Text("예"),
              )
            ],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
          );
        });
  }

  String format(double num, int fixed) {
    return num.toStringAsFixed(fixed).replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}
