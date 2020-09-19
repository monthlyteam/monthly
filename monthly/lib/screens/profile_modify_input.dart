import 'package:flutter/material.dart';
import 'package:monthly/constants.dart';
import 'package:monthly/my_stock.dart';
import 'package:monthly/stock.dart';
import 'package:provider/provider.dart';

class ProfileModifyInput extends StatefulWidget {
  @override
  _ProfileModifyInputState createState() => _ProfileModifyInputState();
}

class _ProfileModifyInputState extends State<ProfileModifyInput> {
  List<MyStock> tempStockList = List<MyStock>();
  List<TextEditingController> controllers;
  List<FocusNode> nodes;
  bool isInputAvgDollar;

  @override
  void initState() {
    super.initState();
    for (final stock in context.read<Stock>().stockList)
      if (!(stock.ticker.contains(".KS") || stock.ticker.contains(".KQ")))
        tempStockList.add(stock);

    controllers = List<TextEditingController>.generate(
        tempStockList.length, (index) => TextEditingController()..text = "0");

    nodes =
        List<FocusNode>.generate(tempStockList.length, (index) => FocusNode());

    isInputAvgDollar = context.read<Stock>().isInputAvgDollar;
  }

  @override
  void dispose() {
    super.dispose();
    controllers.forEach((element) {
      element.dispose();
    });
    nodes.forEach((element) {
      element.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
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
                          for (int i = 0; i < controllers.length; i++) {
                            try {
                              double.parse(controllers[i].text);
                            } catch (e) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext bContext) {
                                    return AlertDialog(
                                      title: Text(
                                        "평균 매입 단가 입력 오류",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: kTextColor),
                                      ),
                                      content: Text(
                                        "입력하신 숫자에 오류가 있습니다.\n값을 다시 한번 확인해 주세요.",
                                        style: TextStyle(color: kTextColor),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(bContext).pop();
                                          },
                                          child: Text("확인"),
                                        ),
                                      ],
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                    );
                                  });
                              FocusScope.of(context).requestFocus(nodes[i]);
                              return;
                            }
                          }

                          showDialog(
                              context: context,
                              builder: (BuildContext bContext) {
                                return AlertDialog(
                                  title: Text(
                                    "입력 통화 설정",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kTextColor),
                                  ),
                                  content: Text(
                                    "입력하신 값으로 변경하시겠습니까?",
                                    style: TextStyle(color: kTextColor),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(bContext).pop();
                                      },
                                      child: Text("취소"),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(bContext).pop();
                                        context
                                            .read<Stock>()
                                            .setIsInputAvgDollar(
                                                !isInputAvgDollar);

                                        for (int i = 0;
                                            i < controllers.length;
                                            i++)
                                          tempStockList[i].editValue(
                                              avg: double.parse(
                                                  controllers[i].text),
                                              amount: tempStockList[i].amount,
                                              isInputAvgDollar:
                                                  (!isInputAvgDollar));

                                        Navigator.pop(context);
                                      },
                                      child: Text("저장"),
                                    ),
                                  ],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                );
                              });
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
                              "${isInputAvgDollar ? "달러" : "원화"}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
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
                              "${isInputAvgDollar ? "원화" : "달러"}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
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
      ),
    );
  }

  List<Widget> getListWidget(BuildContext context) {
    return List.generate(tempStockList.length, (index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            color: Colors.white70,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "티커 / 종목명",
                      style: TextStyle(color: Colors.black, fontSize: 9.0),
                    ),
                    RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: ("${tempStockList[index].ticker}" +
                            " " +
                            "${tempStockList[index].name}"),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      "평균 매입 단가",
                      style: TextStyle(color: Colors.black, fontSize: 9.0),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: ("${isInputAvgDollar ? "\$" : "￦"}" +
                                  " " +
                                  "${tempStockList[index].avg}"),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Icon(Icons.arrow_forward),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Text(
                            "${isInputAvgDollar ? "￦" : "\$"}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              padding: EdgeInsets.all(2.0),
                              height: 24,
                              child: TextField(
                                  maxLength: 10,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(counterText: ""),
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  controller: controllers[index],
                                  autofocus: false,
                                  focusNode: nodes[index],
                                  style: TextStyle(
                                      color: kTextColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                  onSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus())),
                        ),
                      ],
                    )
                  ],
                ))),
      );
    });
  }
}
