import 'package:flutter/material.dart';
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
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(0.0, 1.0),
                                                    color: Colors.grey,
                                                    blurRadius: 1.0)
                                              ],
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
