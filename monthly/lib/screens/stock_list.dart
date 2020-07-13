import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../my_stock.dart';
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
    context.watch<Stock>().addStock(
        newStock: MyStock(
            ticker: "SBUX",
            name: "Starbucks",
            amount: 40.0,
            avg: 50000.0,
            color: Color(0xffF25B7F),
            frequency: "분기",
            evaPrice: 81532.1,
            dividend: 82231.5,
            percent: 40.0,
            logoURL: "https:\/\/logo.clearbit.com\/starbucks.com"));
    context.watch<Stock>().addStock(
        newStock: MyStock(
            ticker: "005930",
            name: "삼성전자",
            amount: 30.0,
            avg: 50000.0,
            color: Color(0xff88B14B),
            frequency: "연",
            evaPrice: 52300.1,
            dividend: 45750.2,
            percent: 30.0,
            exDividends: [
              ExDividend(datetime: DateTime.now(), price: 4600.0),
              ExDividend(
                  datetime: DateTime.parse("1969-07-20 20:18:04Z"),
                  price: 4500.0)
            ],
            logoURL: "https:\/\/logo.clearbit.com\/samsung.com"));
    context.watch<Stock>().addStock(
        newStock: MyStock(
            ticker: "AAPL",
            name: "Apple",
            amount: 15.0,
            avg: 50000.0,
            color: Color(0xffF09797),
            frequency: "월",
            evaPrice: 3251500.1,
            dividend: 41250.2,
            percent: 15.0,
            exDividends: [
              ExDividend(datetime: DateTime.now(), price: 4600.0),
              ExDividend(
                  datetime: DateTime.parse("1969-07-20 20:18:04Z"),
                  price: 4500.0)
            ],
            logoURL: "https:\/\/logo.clearbit.com\/apple.com"));
    context.watch<Stock>().addStock(
        newStock: MyStock(
            ticker: "T",
            name: "AT&T",
            amount: 15.0,
            avg: 50000.0,
            color: Color(0xffE8B447),
            frequency: "분기",
            evaPrice: 417320.1,
            dividend: 9250.2,
            percent: 15.0,
            exDividends: [
              ExDividend(datetime: DateTime.now(), price: 4600.0),
              ExDividend(
                  datetime: DateTime.parse("1969-07-20 20:18:04Z"),
                  price: 4500.0)
            ],
            logoURL: "https:\/\/logo.clearbit.com\/att.com"));
    context.watch<Stock>().addStock(
        newStock: MyStock(
            ticker: "T",
            name: "AT&T",
            amount: 15.0,
            avg: 50000.0,
            color: Color(0xffE8B447),
            frequency: "분기",
            evaPrice: 417320.1,
            dividend: 9250.2,
            exDividends: [
              ExDividend(datetime: DateTime.now(), price: 4600.0),
              ExDividend(
                  datetime: DateTime.parse("1969-07-20 20:18:04Z"),
                  price: 4500.0)
            ],
            logoURL:
                "https://www.att.com/ecms/dam/att/consumer/global/logos/att_globe_500x500.jpg"));
    context.watch<Stock>().addStock(
        newStock: MyStock(
            ticker: "T",
            name: "AT&T",
            amount: 15.0,
            avg: 50000.0,
            color: Color(0xffE8B447),
            frequency: "분기",
            evaPrice: 417320.1,
            dividend: 9250.2,
            exDividends: [
              ExDividend(datetime: DateTime.now(), price: 4600.0),
              ExDividend(
                  datetime: DateTime.parse("1969-07-20 20:18:04Z"),
                  price: 4500.0)
            ],
            logoURL:
                "https://www.att.com/ecms/dam/att/consumer/global/logos/att_globe_500x500.jpg"));

    return SliverPadding(
      padding: EdgeInsets.all(25.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 440.0,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40.0),
                                  topRight: Radius.circular(40.0))),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 30.0,
                                child: IconButton(
                                  padding: EdgeInsets.all(0.0),
                                  iconSize: 30,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xff707070),
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
                                      children: <Widget>[
                                        Container(
                                          child: SizedBox(
                                            width: 54,
                                          ),
                                          height: 54,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.contain,
                                                  image: NetworkImage(context
                                                      .watch<Stock>()
                                                      .stockList[index]
                                                      .logoURL))),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Column(
                                          children: <Widget>[],
                                        )
                                      ],
                                    ),
                                  ],
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
                  color: context.watch<Stock>().stockList[index].color,
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
                                "${context.watch<Stock>().stockList[index].ticker}" +
                                    " " +
                                    "${context.watch<Stock>().stockList[index].name}",
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
                                "￦${context.watch<Stock>().stockList[index].dividend.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}" +
                                    " "
                                        "${context.watch<Stock>().stockList[index].frequency}",
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
                                "￦${context.watch<Stock>().stockList[index].evaPrice.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}" +
                                    " / "
                                        "${context.watch<Stock>().stockList[index].percent}%",
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
                                "${context.watch<Stock>().stockList[index].amount} 주",
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
