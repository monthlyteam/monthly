import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monthly/my_stock.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../stock.dart';
import 'stock_list_add.dart';
import 'package:admob_flutter/admob_flutter.dart';

class StockList extends StatefulWidget {
  @override
  _StockListState createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  String admobBannerId = '';
  var banner;

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
      print("stockList: ${context.read<Stock>().stockList}");

      MyStock myStock = context.read<Stock>().stockList[index];
      final avgController =
          TextEditingController(text: "${myStock.avg.round()}");
      avgController.selection = TextSelection.fromPosition(
          TextPosition(offset: avgController.text.length));
      final amountController =
          TextEditingController(text: "${myStock.amount.round()}");
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
                height: 240,
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
                                        borderRadius:
                                            BorderRadius.circular(54.0),
                                        child: FadeInImage(
                                            fit: BoxFit.contain,
                                            width: 54,
                                            image: myStock.logoURL == ""
                                                ? AssetImage(
                                                    'images/default_logo.png')
                                                : NetworkImage(myStock.logoURL),
                                            placeholder: AssetImage(
                                                'images/default_logo.png')),
                                      ),
                                      height: 54,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
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
                                                fontSize: 25.0),
                                          ),
                                          Container(
                                            height: 20.0,
                                            child: Row(
                                              children: <Widget>[
                                                Flexible(
                                                  child: RichText(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                      text: "${myStock.name}",
                                                      style: TextStyle(
                                                          color: kTextColor,
                                                          fontSize: 16.0,
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
                                  IconButton(
                                    iconSize: 24.0,
                                    icon: Icon(
                                      Icons.check,
                                      color: kTextColor,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext bContext) {
                                            return AlertDialog(
                                              title: Text(
                                                "${myStock.name}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: kTextColor),
                                              ),
                                              content: Text(
                                                myStock.amount.round() == 0
                                                    ? "해당 종목을 추가하시겠습니까?"
                                                    : "해당 종목을 수정하시겠습니까?",
                                                style: TextStyle(
                                                    color: kTextColor),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(bContext)
                                                        .pop();
                                                  },
                                                  child: Text("아니요"),
                                                ),
                                                FlatButton(
                                                  onPressed: () {
                                                    context
                                                        .read<Stock>()
                                                        .modifyStock(
                                                            ticker:
                                                                myStock.ticker,
                                                            avg: double.parse(
                                                                avgController
                                                                    .text),
                                                            amount: double.parse(
                                                                amountController
                                                                    .text));
                                                    Navigator.of(bContext)
                                                        .pop();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("예"),
                                                )
                                              ],
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0))),
                                            );
                                          });
                                    },
                                  ),
                                ],
                              )
                            ],
                          ), //Row of top
                          SizedBox(height: 20.0),
                          Row(
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
                                      "￦${(myStock.wClosingPrice * amount).toStringAsFixed(1).replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
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
                                          : "￦${(myStock.wYearlyDividend * amount).toStringAsFixed(1).replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
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
                                      "평균 매입 단가(￦)",
                                      style: TextStyle(
                                          color: kTextColor, fontSize: 12.0),
                                    ),
                                    Container(
                                        padding: EdgeInsets.all(2.0),
                                        height: 24.0,
                                        child: TextField(
                                            maxLength: 10,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                                counterText: ""),
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true),
                                            controller: avgController,
                                            autofocus: true,
                                            style: TextStyle(
                                                color: kTextColor,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                            onSubmitted: (_) =>
                                                FocusScope.of(context)
                                                    .nextFocus())),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Text(
                                      "보유수량",
                                      style: TextStyle(
                                          color: kTextColor, fontSize: 12.0),
                                    ),
                                    Container(
                                        padding: EdgeInsets.all(2.0),
                                        height: 24.0,
                                        child: TextField(
                                            maxLength: 10,
                                            textInputAction:
                                                TextInputAction.done,
                                            decoration: InputDecoration(
                                                counterText: ""),
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true),
                                            autofocus: true,
                                            controller: amountController,
                                            style: TextStyle(
                                                color: kTextColor,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                            onChanged: (text) {
                                              setState(() {
                                                if (text != null) {
                                                  amount = double.parse(text);
                                                }
                                                print("amount : $text");
                                              });
                                            })),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              );
            });
          });
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
              : _getSlivers(context),
        ],
      ),
    );
  }

  SliverPadding _getSlivers(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(25.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            MyStock myStock = context.watch<Stock>().stockList[index];
            if (index != 0 &&
                (index + 1) == context.watch<Stock>().stockList.length) {
              print("on");
              return Column(
                children: <Widget>[
                  gestureDetector(myStock, context),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      color: Colors.white,
                      child: banner,
                    ),
                  ),
                ],
              );
            } else {
              return gestureDetector(myStock, context);
            }
          },
          childCount: context.watch<Stock>().stockList.length,
        ),
      ),
    );
  }

  GestureDetector gestureDetector(MyStock myStock, BuildContext context) {
    return GestureDetector(
      onTap: () {
        bool isEdit = false;
        final avgController =
            TextEditingController(text: "${myStock.avg.round()}");
        avgController.selection = TextSelection.fromPosition(
            TextPosition(offset: avgController.text.length));
        final amountController =
            TextEditingController(text: "${myStock.amount.round()}");
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
                                          borderRadius:
                                              BorderRadius.circular(54.0),
                                          child: FadeInImage(
                                              fit: BoxFit.contain,
                                              width: 54,
                                              image: myStock.logoURL == ""
                                                  ? AssetImage(
                                                      'images/default_logo.png',
                                                    )
                                                  : NetworkImage(
                                                      myStock.logoURL),
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
                                                  fontSize: 25.0),
                                            ),
                                            Container(
                                              height: 20.0,
                                              child: Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    child: RichText(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      text: TextSpan(
                                                        text: "${myStock.name}",
                                                        style: TextStyle(
                                                            color: kTextColor,
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                    Visibility(
                                      maintainState: isEdit ? false : true,
                                      maintainAnimation: isEdit ? false : true,
                                      maintainSize: isEdit ? false : true,
                                      visible: isEdit ? false : true,
                                      child: IconButton(
                                        iconSize: 24.0,
                                        icon: Icon(
                                          Icons.delete,
                                          color: kTextColor,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext bContext) {
                                                return AlertDialog(
                                                  title: Text(
                                                    "${myStock.name}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: kTextColor),
                                                  ),
                                                  content: Text(
                                                    "해당 종목을 삭제하시겠습니까?",
                                                    style: TextStyle(
                                                        color: kTextColor),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(bContext)
                                                            .pop();
                                                      },
                                                      child: Text("아니요"),
                                                    ),
                                                    FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(bContext)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                        context
                                                            .read<Stock>()
                                                            .deleteStock(
                                                                ticker: myStock
                                                                    .ticker);
                                                      },
                                                      child: Text("예"),
                                                    )
                                                  ],
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0))),
                                                );
                                              });
                                        },
                                      ),
                                    ),
                                    Visibility(
                                      maintainState: isEdit ? false : true,
                                      maintainAnimation: isEdit ? false : true,
                                      maintainSize: isEdit ? false : true,
                                      visible: isEdit ? false : true,
                                      child: IconButton(
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
                                    ),
                                    Visibility(
                                      maintainState: isEdit ? true : false,
                                      maintainAnimation: isEdit ? true : false,
                                      maintainSize: isEdit ? true : false,
                                      visible: isEdit ? true : false,
                                      child: IconButton(
                                        iconSize: 24.0,
                                        icon: Icon(
                                          Icons.check,
                                          color: kTextColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext bContext) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      "${myStock.name}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: kTextColor),
                                                    ),
                                                    content: Text(
                                                      "해당 종목을 수정하시겠습니까?",
                                                      style: TextStyle(
                                                          color: kTextColor),
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        onPressed: () {
                                                          Navigator.of(bContext)
                                                              .pop();
                                                        },
                                                        child: Text("아니요"),
                                                      ),
                                                      FlatButton(
                                                        onPressed: () {
                                                          isEdit = !isEdit;
                                                          context.read<Stock>().modifyStock(
                                                              ticker: myStock
                                                                  .ticker,
                                                              avg: double.parse(
                                                                  avgController
                                                                      .text),
                                                              amount: double.parse(
                                                                  amountController
                                                                      .text));
                                                          Navigator.of(bContext)
                                                              .pop();
                                                        },
                                                        child: Text("예"),
                                                      )
                                                    ],
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0))),
                                                  );
                                                });
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ), //Row of top
                            SizedBox(height: 20.0),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "평가 금액",
                                        style: TextStyle(
                                            color: kTextColor, fontSize: 12.0),
                                      ),
                                      Text(
                                        "￦${(myStock.wClosingPrice * amount).toStringAsFixed(1).replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
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
                                            : "￦${(myStock.wYearlyDividend * amount).toStringAsFixed(1).replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        isEdit ? "평균 매입 단가(￦)" : "평균 매입 단가",
                                        style: TextStyle(
                                            color: kTextColor, fontSize: 12.0),
                                      ),
                                      Visibility(
                                        maintainState: isEdit ? true : false,
                                        maintainAnimation:
                                            isEdit ? true : false,
                                        maintainSize: isEdit ? true : false,
                                        visible: isEdit ? true : false,
                                        child: Container(
                                            padding: EdgeInsets.all(2.0),
                                            height: 24.0,
                                            child: TextField(
                                                maxLength: 10,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
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
                                      Visibility(
                                        maintainState: isEdit ? false : true,
                                        maintainAnimation:
                                            isEdit ? false : true,
                                        maintainSize: isEdit ? false : true,
                                        visible: isEdit ? false : true,
                                        child: Text(
                                          "￦${myStock.avg.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                          style: TextStyle(
                                              color: kTextColor,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Text(
                                        "보유수량",
                                        style: TextStyle(
                                            color: kTextColor, fontSize: 12.0),
                                      ),
                                      Visibility(
                                        maintainState: isEdit ? true : false,
                                        maintainAnimation:
                                            isEdit ? true : false,
                                        maintainSize: isEdit ? true : false,
                                        visible: isEdit ? true : false,
                                        child: Container(
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                                onSubmitted: (_) =>
                                                    FocusScope.of(context)
                                                        .unfocus(),
                                                onChanged: (text) {
                                                  setState(() {
                                                    if (text != null) {
                                                      amount =
                                                          double.parse(text);
                                                    }
                                                    print("amount : $text");
                                                  });
                                                })),
                                      ),
                                      Visibility(
                                        maintainState: isEdit ? false : true,
                                        maintainAnimation:
                                            isEdit ? false : true,
                                        maintainSize: isEdit ? false : true,
                                        visible: isEdit ? false : true,
                                        child: Text(
                                          "${myStock.amount} 주",
                                          style: TextStyle(
                                              color: kTextColor,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
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
                      Expanded(
                        child: Visibility(
                          maintainState: isEdit ? false : true,
                          maintainAnimation: isEdit ? false : true,
                          maintainSize: isEdit ? false : true,
                          visible: isEdit ? false : true,
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
                                          "￦${myStock.wClosingPrice.toStringAsFixed(1).replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
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
                                                "￦${myStock.wEvaProfit.abs().toStringAsFixed(1).replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
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
                        ),
                      )
                    ],
                  ),
                );
              });
            });
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
                        "티커 / 종목명",
                        style: TextStyle(color: Colors.white, fontSize: 9.0),
                      ),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: "${myStock.ticker}" +
                                    " " +
                                    "${myStock.name}",
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
                            : "￦${myStock.wDividend.toStringAsFixed(1).replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
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
                        "￦${myStock.wEvaPrice.toStringAsFixed(1).replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
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
}
