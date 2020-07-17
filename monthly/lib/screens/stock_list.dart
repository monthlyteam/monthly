import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monthly/my_stock.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../stock.dart';

class StockList extends StatelessWidget {
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
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: "detail",
                    child: Text('detail'),
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
                onPressed: () {},
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
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0))),
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
                                            IconButton(
                                              iconSize: 24.0,
                                              icon: Icon(
                                                Icons.delete,
                                                color: kTextColor,
                                              ),
                                              onPressed: () {},
                                            ),
                                            IconButton(
                                              iconSize: 24.0,
                                              icon: Icon(
                                                Icons.create,
                                                color: kTextColor,
                                              ),
                                              onPressed: () {},
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
                                              Text(
                                                "￦${myStock.avg.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
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
                                                "보유수량",
                                                style: TextStyle(
                                                    color: kTextColor,
                                                    fontSize: 12.0),
                                              ),
                                              Text(
                                                "${myStock.amount} 주",
                                                style: TextStyle(
                                                    color: kTextColor,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                "${myStock.exDividends.last.datetime.year}년 ${myStock.exDividends.last.datetime.month}월 ${myStock.exDividends.last.datetime.day}일",
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
                              )
                            ],
                          ),
                        ),
                      );
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
