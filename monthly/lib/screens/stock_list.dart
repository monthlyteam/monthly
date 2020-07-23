import 'package:flutter/material.dart';
import 'package:monthly/my_stock.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../stock.dart';
import 'stock_list_add.dart';

class StockList extends StatefulWidget {
  @override
  _StockListState createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  void moveToSecondPage() async {
    final information = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StockListAdd()),
    );
    print("ticker $information");
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
                  print(sel);
                  setState(() {
                    switch (sel) {
                      case "ticker":
                        print("티커");
                        context
                            .read<Stock>()
                            .stockList
                            .sort((a, b) => a.ticker.compareTo(b.ticker));
                        break;
                      case "dividend":
                        print("배당금");
                        context
                            .read<Stock>()
                            .stockList
                            .sort((a, b) => b.dividend.compareTo(a.dividend));
                        break;
                      case "evaPrice":
                        print("평가금액");
                        context
                            .read<Stock>()
                            .stockList
                            .sort((a, b) => b.evaPrice.compareTo(a.evaPrice));
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
          _getSlivers(context)
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
            return GestureDetector(
              onTap: () {
                bool isEdit = false;
                final avgController = TextEditingController();
                final amountController = TextEditingController();
                showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0))),
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              child: SizedBox(
                                                width: 54,
                                              ),
                                              height: 54,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        offset:
                                                            Offset(0.0, 1.0),
                                                        color: Colors.grey,
                                                        blurRadius: 1.0)
                                                  ],
                                                  image: DecorationImage(
                                                      fit: BoxFit.contain,
                                                      image: NetworkImage(
                                                          myStock.logoURL))),
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "${myStock.ticker}",
                                                  style: TextStyle(
                                                      color: Color(0xff2c2c2c),
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 25.0),
                                                ),
                                                Text(
                                                  "${myStock.name}",
                                                  style: TextStyle(
                                                      color: Color(0xff2c2c2c),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Visibility(
                                              maintainState:
                                                  isEdit ? false : true,
                                              maintainAnimation:
                                                  isEdit ? false : true,
                                              maintainSize:
                                                  isEdit ? false : true,
                                              visible: isEdit ? false : true,
                                              child: IconButton(
                                                iconSize: 24.0,
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: kTextColor,
                                                ),
                                                onPressed: () {
                                                  print("삭제");
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          bContext) {
                                                        return AlertDialog(
                                                          title: Text(
                                                            "${myStock.name}",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    kTextColor),
                                                          ),
                                                          content: Text(
                                                            "해당 종목을 삭제하시겠습니까?",
                                                            style: TextStyle(
                                                                color:
                                                                    kTextColor),
                                                          ),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        bContext)
                                                                    .pop();
                                                              },
                                                              child:
                                                                  Text("아니요"),
                                                            ),
                                                            FlatButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        bContext)
                                                                    .pop();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                context
                                                                    .read<
                                                                        Stock>()
                                                                    .deleteStock(
                                                                        ticker:
                                                                            myStock.ticker);
                                                              },
                                                              child: Text("예"),
                                                            )
                                                          ],
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10.0))),
                                                        );
                                                      });
                                                },
                                              ),
                                            ),
                                            Visibility(
                                              maintainState:
                                                  isEdit ? false : true,
                                              maintainAnimation:
                                                  isEdit ? false : true,
                                              maintainSize:
                                                  isEdit ? false : true,
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
                                              maintainState:
                                                  isEdit ? true : false,
                                              maintainAnimation:
                                                  isEdit ? true : false,
                                              maintainSize:
                                                  isEdit ? true : false,
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
                                                        builder: (BuildContext
                                                            bContext) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              "${myStock.name}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      kTextColor),
                                                            ),
                                                            content: Text(
                                                              "해당 종목을 수정하시겠습니까?",
                                                              style: TextStyle(
                                                                  color:
                                                                      kTextColor),
                                                            ),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          bContext)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    Text("아니요"),
                                                              ),
                                                              FlatButton(
                                                                onPressed: () {
                                                                  isEdit =
                                                                      !isEdit;
                                                                  print(double.parse(
                                                                      avgController
                                                                          .text));
                                                                  print(double.parse(
                                                                      amountController
                                                                          .text));
                                                                  context.read<Stock>().modifyStock(
                                                                      ticker: myStock
                                                                          .ticker,
                                                                      avg: double.parse(
                                                                          avgController
                                                                              .text),
                                                                      amount: double.parse(
                                                                          amountController
                                                                              .text));
                                                                  Navigator.of(
                                                                          bContext)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    Text("예"),
                                                              )
                                                            ],
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
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
                                                    color: kTextColor,
                                                    fontSize: 12.0),
                                              ),
                                              Text(
                                                "￦${myStock.evaPrice.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                                style: TextStyle(
                                                    color: kTextColor,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 20.0,
                                              ),
                                              Text(
                                                "총 배당금 / 주기",
                                                style: TextStyle(
                                                    color: kTextColor,
                                                    fontSize: 12.0),
                                              ),
                                              Text(
                                                "￦${myStock.dividend.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}" +
                                                    " "
                                                        "${myStock.frequency}",
                                                style: TextStyle(
                                                    color: kTextColor,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                "평균 매입 단가",
                                                style: TextStyle(
                                                    color: kTextColor,
                                                    fontSize: 12.0),
                                              ),
                                              Visibility(
                                                maintainState:
                                                    isEdit ? true : false,
                                                maintainAnimation:
                                                    isEdit ? true : false,
                                                maintainSize:
                                                    isEdit ? true : false,
                                                visible: isEdit ? true : false,
                                                child: Container(
                                                    padding:
                                                        EdgeInsets.all(2.0),
                                                    height: 24.0,
                                                    child: TextField(
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller:
                                                            avgController,
                                                        autofocus: true,
                                                        style: TextStyle(
                                                            color: kTextColor,
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        onSubmitted: (_) =>
                                                            FocusScope.of(
                                                                    context)
                                                                .nextFocus())),
                                              ),
                                              Visibility(
                                                maintainState:
                                                    isEdit ? false : true,
                                                maintainAnimation:
                                                    isEdit ? false : true,
                                                maintainSize:
                                                    isEdit ? false : true,
                                                visible: isEdit ? false : true,
                                                child: Text(
                                                  "￦${myStock.avg.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                                  style: TextStyle(
                                                      color: kTextColor,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20.0,
                                              ),
                                              Text(
                                                "보유수량",
                                                style: TextStyle(
                                                    color: kTextColor,
                                                    fontSize: 12.0),
                                              ),
                                              Visibility(
                                                maintainState:
                                                    isEdit ? true : false,
                                                maintainAnimation:
                                                    isEdit ? true : false,
                                                maintainSize:
                                                    isEdit ? true : false,
                                                visible: isEdit ? true : false,
                                                child: Container(
                                                    padding:
                                                        EdgeInsets.all(2.0),
                                                    height: 24.0,
                                                    child: TextField(
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        autofocus: true,
                                                        controller:
                                                            amountController,
                                                        style: TextStyle(
                                                            color: kTextColor,
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        onSubmitted: (_) =>
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus())),
                                              ),
                                              Visibility(
                                                maintainState:
                                                    isEdit ? false : true,
                                                maintainAnimation:
                                                    isEdit ? false : true,
                                                maintainSize:
                                                    isEdit ? false : true,
                                                visible: isEdit ? false : true,
                                                child: Text(
                                                  "${myStock.amount} 주",
                                                  style: TextStyle(
                                                      color: kTextColor,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                  "￦${myStock.closingPrice.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                  "${myStock.divPercent}%",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 12.0,
                                                ),
                                                Text(
                                                  "최근 배당락일",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.0),
                                                ),
                                                Text(
                                                  "${DateTime.parse(myStock.exDividends.last['datetime']).year}년 ${DateTime.parse(myStock.exDividends.last['datetime']).month}월 ${DateTime.parse(myStock.exDividends.last['datetime']).day}일",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: <Widget>[
                                                    Text(
                                                      "￦+${myStock.evaProfit.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "(${myStock.evaProfitPercent}%)",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
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
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                      fontWeight:
                                                          FontWeight.bold),
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: myStock.color,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "티커 / 종목명",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 9.0),
                              ),
                              Text(
                                "${myStock.ticker}" + " " + "${myStock.name}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              Text(
                                "총 배당금 / 주기",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 9.0),
                              ),
                              Text(
                                "￦${myStock.dividend.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}" +
                                    " "
                                        "${myStock.frequency}",
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
                                "평가금액 / 비율",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 9.0),
                              ),
                              Text(
                                "￦${myStock.evaPrice.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}" +
                                    " / "
                                        "${(myStock.percent).toStringAsFixed(1)}%",
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 9.0),
                              ),
                              Text(
                                "${myStock.amount} 주",
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
          },
          childCount: context.watch<Stock>().stockList.length,
        ),
      ),
    );
  }
}
/*
Widget _myListView(BuildContext context) {
  return ListView.builder(
    padding: EdgeInsets.all(20.0),
    itemCount: myStocks.length,
    itemBuilder: (context, index) {
      return
    },
  );
}

 */
