import 'package:flutter/material.dart';
import 'package:monthly/constants.dart';
import 'package:monthly/my_stock.dart';
import 'package:monthly/stock.dart';
import 'package:provider/provider.dart';

class ProfileModifyInput extends StatelessWidget {
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
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  "입력 통화 설정",
                  style: TextStyle(
                      color: kTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              leading: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "취소",
                    style: TextStyle(
                        color: Color(0xFFC72424),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "저장",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
              floating: true,
              backgroundColor: Colors.white,
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        child: Center(
                          child: Text(
                            "${context.watch<Stock>().isInputAvgDollar ? "달러" : "원화"}",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        height: 35,
                        decoration: BoxDecoration(
                            color: kMainColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        child: Center(
                            child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        )),
                        width: 40,
                        height: 35,
                        decoration: BoxDecoration(
                            color: kMainColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Center(
                          child: Text(
                            "${context.watch<Stock>().isInputAvgDollar ? "원화" : "달러"}",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        height: 35,
                        decoration: BoxDecoration(
                            color: kMainColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: getListWidget(context),
              ),
            ]))
          ],
        ),
      ),
    );
  }

  List<Widget> getListWidget(BuildContext context) {
    List<MyStock> tempStockList = List<MyStock>();
    for (final stock in context.watch<Stock>().stockList)
      if (!(stock.ticker.contains(".KS") || stock.ticker.contains(".KQ")))
        tempStockList.add(stock);

    return List.generate(tempStockList.length, (index) {
      return Container(child: Text("${tempStockList[index].name}"));
    });
  }
}
