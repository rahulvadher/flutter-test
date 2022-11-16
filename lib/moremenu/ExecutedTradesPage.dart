import 'dart:convert';

import 'package:backoffice/AppColor.dart';
import 'package:backoffice/components/BackNavigationButton.dart';
import 'package:backoffice/components/DefaultPlaceHolder.dart';
import 'package:backoffice/components/DropDown.dart';
import 'package:backoffice/components/IconView.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Picker.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/model/TradeExpandListModel.dart';
import 'package:backoffice/model/TradeListModel.dart';
import 'package:backoffice/model/TradeModel.dart';
import 'package:backoffice/services/ApiService.dart';
import 'package:backoffice/services/Constants.dart';
import 'package:backoffice/services/Helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

import '../services/globals.dart' as globals;

class ExecutedTradesPage extends StatefulWidget {
  bool isHeaderVisible = false;

  ExecutedTradesPage({this.isHeaderVisible = false});

  @override
  State<StatefulWidget> createState() => ExecutedTradesPageState();
}

class ExecutedTradesPageState extends State<ExecutedTradesPage> {
  ClientListModel singleClient = new ClientListModel();
  List<TradeModel> nseCMList = [],
      nseFOList = [],
      nseCDList = [],
      bseCMList = [],
      bseFOList = [],
      bseCDList = [];
  List<TradeExpandListModel> tradeList = [];
  bool isNSECM = false,
      isNSEFO = false,
      isNSECD = false,
      isBSECM = false,
      isBSEFO = false,
      isBSECD = false;
  int rowIndex = -1;
  Map<String, dynamic> dataMap = new Map<String, dynamic>();
  Response response = Response('', 200);
  String selectedDate = Helpers.currentDate(isFrom: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    singleClient = globals.clientList[globals.codeIndex];
    setTrade();
  }

  void setTrade() {
    tradeList.clear();
    getTrade('nse/cm');
    getTrade('nse/fo');
    getTrade('nse/cd');
    getTrade('bse/cm');
    /* getTrade('bse/fo');
    getTrade('bse/cd');*/
  }

  getTrade(String trade) async {
    Map<String, String> headerParam = {
      'Authorization': globals.accessToken,
    };
    await ApiService.getMethod(
      '${Constants.middleWareBaseUrl}/api/v1/trades/$trade/${singleClient.clientCode}?date=${Helpers.changeDateFormat(selectedDate, 'dd-MM-yyyy', 'yyyy-MM-dd')}',
      context,
      headerParam: headerParam,
    ).then((result) => {
          response = result,
          if (response.statusCode == 200)
            {
              if (mounted)
                setState(() {
                  if (trade == 'nse/cm') {
                    nseCMList = (json.decode(response.body) as List)
                        .map((i) => TradeModel.fromJson(i))
                        .toList();
                    if (nseCMList.isNotEmpty) {
                      tradeList.add(TradeExpandListModel(nseCMList,
                          "NSE Capital Market", calculateM2M(nseCMList)));
                    }
                  } else if (trade == 'nse/fo') {
                    nseFOList = (json.decode(response.body) as List)
                        .map((i) => TradeModel.fromJson(i))
                        .toList();
                    if (nseFOList.isNotEmpty)
                      tradeList.add(TradeExpandListModel(nseFOList,
                          "NSE Derivative Market", calculateM2M(nseFOList)));
                  } else if (trade == 'nse/cd') {
                    nseCDList = (json.decode(response.body) as List)
                        .map((i) => TradeModel.fromJson(i))
                        .toList();
                    if (nseCDList.isNotEmpty)
                      tradeList.add(TradeExpandListModel(nseCDList,
                          "NSE Currency Market", calculateM2M(nseCDList)));
                  } else if (trade == 'bse/cm') {
                    bseCMList = (json.decode(response.body) as List)
                        .map((i) => TradeModel.fromJson(i))
                        .toList();

                    if (bseCMList.isNotEmpty) {
                      tradeList.add(TradeExpandListModel(bseCMList,
                          "BSE Capital Market", calculateM2M(bseCMList)));
                    }
                  }
                })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.isHeaderVisible)
                        Flexible(
                          child: BackNavigationButton(
                            label: 'Executed Trades',
                            isBackVisible: true,
                          ),
                        ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return DropDown(pickerData: globals.clientList);
                              }).then((value) => {
                                if (value != null)
                                  {
                                    setState(() {
                                      singleClient = value;
                                      setTrade();
                                    }),
                                  }
                              });
                        },
                        child: Picker(singleClient.clientCode ?? ''),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await Helpers.selectDate(
                            context,
                            DateTime.now().subtract(Duration(days: 30)),
                            DateTime.now().add(Duration(minutes: 1)),
                          ).then((value) => selectedDate = value);
                          setState(() {
                            setTrade();
                          });
                        },
                        child: Row(
                          children: [
                            LabelTextField(
                              label: selectedDate,
                              textColor: AppColor.primaryColor,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: IconView(
                                icon: Icons.date_range_outlined,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                tradeList.isNotEmpty
                    ? Flexible(
                        child: SingleChildScrollView(
                          child: Flex(
                            direction: Axis.vertical,
                            children: [
                              /* if (nseCMList.isNotEmpty) nseCM(),
                        if (nseFOList.isNotEmpty) nseFO(),
                        if (nseCDList.isNotEmpty) nseCD(),
                        if (bseCMList.isNotEmpty) bseCM(),
                        if (bseFOList.isNotEmpty) bseFO(),
                        if (bseCDList.isNotEmpty) bseCD()*/
                              testTrade()
                            ],
                          ),
                        ),
                      )
                    : Expanded(child: DefaultPlaceHolder())
              ],
            ),
          ),
        ),
      ),
    );
  }

  String calculateM2M(List<TradeModel> itemList) {
    if (itemList.isNotEmpty)
      return itemList
          .map((item) => item.profitLose)
          .reduce((a, b) => a + b)
          .toStringAsFixed(2);
    else
      return '0.0';
  }

  Widget nseCM() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isNSECM = isNSECM ? false : true;
            });
          },
          child: Card(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            shadowColor: AppColor.primaryTextColor,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LabelTextField(
                        label: 'NSE Capital Market',
                        fontFamily: "SemiBold",
                        textSize: 16.0,
                      ),
                      Row(
                        children: [
                          new LabelTextField(
                            label: 'M2M ${calculateM2M(nseCMList)}',
                            fontFamily: 'SemiBold',
                            textColor: double.parse(calculateM2M(nseCMList)) < 0
                                ? AppColor.primaryAlertColor
                                : double.parse(calculateM2M(nseCMList)) > 0
                                    ? AppColor.primaryGreenColor
                                    : AppColor.secondaryTextColor,
                          ),
                          IconView(
                              icon: isNSECM
                                  ? Icons.keyboard_arrow_up_outlined
                                  : Icons.keyboard_arrow_down)
                        ],
                      )
                    ],
                  ),
                ),
                if (isNSECM)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 2,
                          child: new LabelTextField(
                            label: 'Symbol',
                            fontFamily: 'SemiBold',
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: new LabelTextField(
                            alignment: Alignment.topRight,
                            label: 'Net Qty',
                            fontFamily: 'SemiBold',
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              new LabelTextField(
                                label: 'Gain',
                                textColor: AppColor.primaryGreenColor,
                                fontFamily: 'SemiBold',
                              ),
                              new LabelTextField(
                                label: '/',
                              ),
                              new LabelTextField(
                                label: 'Loss',
                                textColor: AppColor.primaryAlertColor,
                                fontFamily: 'SemiBold',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (isNSECM)
                  Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: nseCMList.length,
                        itemBuilder: (context, index) {
                          TradeModel singleItem = nseCMList[index];

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  final tile = nseCMList.firstWhere(
                                      (item) => item.isVisible == true,
                                      orElse: () => new TradeModel(
                                          trades: singleItem.trades));

                                  if (tile.symbol != singleItem.symbol)
                                    setState(() => tile.isVisible = false);
                                  setState(() {
                                    singleItem.isVisible =
                                        singleItem.isVisible ? false : true;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(
                                          nseCMList.length - 1 == index
                                              ? 10
                                              : 0),
                                      bottomLeft: Radius.circular(
                                          nseCMList.length - 1 == index
                                              ? 10
                                              : 0),
                                    ),
                                    color: index % 2 == 0
                                        ? AppColor.primaryColor
                                            .withOpacity(0.30)
                                        : AppColor.primaryTextColor,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: Row(
                                            children: [
                                              singleItem.isVisible
                                                  ? IconView(
                                                      color: AppColor
                                                          .primaryHintColor,
                                                      icon: Icons
                                                          .keyboard_arrow_up_outlined,
                                                    )
                                                  : IconView(
                                                      color: AppColor
                                                          .primaryHintColor,
                                                      icon: Icons
                                                          .keyboard_arrow_down,
                                                    ),
                                              new LabelTextField(
                                                label: singleItem.symbol,
                                                fontFamily: 'SemiBold',
                                                textColor:
                                                    AppColor.primaryHintColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: new LabelTextField(
                                            alignment: Alignment.topRight,
                                            label:
                                                '${singleItem.buyQty - singleItem.saleQty}',
                                            textColor:
                                                AppColor.primaryHintColor,
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: new LabelTextField(
                                            alignment: Alignment.topRight,
                                            label:
                                                '${singleItem.profitLose == 0.0 ? 'N/A' : singleItem.profitLose}',
                                            textColor: singleItem.profitLose < 0
                                                ? AppColor.primaryAlertColor
                                                : singleItem.profitLose > 0
                                                    ? AppColor.primaryGreenColor
                                                    : AppColor
                                                        .secondaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (singleItem.isVisible)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 20.0, top: 10.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: AppColor.primaryColor
                                                    .withOpacity(0.30),
                                                spreadRadius: 0,
                                                blurRadius: 0),
                                          ],
                                        ),
                                        padding: EdgeInsets.all(5.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: new LabelTextField(
                                                alignment: Alignment.center,
                                                label: 'Buy Qty',
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: new LabelTextField(
                                                alignment: Alignment.center,
                                                label: 'Sell Qty',
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: new LabelTextField(
                                                alignment: Alignment.center,
                                                label: 'Price',
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: new LabelTextField(
                                                alignment: Alignment.center,
                                                label: 'Time',
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: new LabelTextField(
                                                alignment: Alignment.center,
                                                label: 'Number',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: singleItem.trades.length,
                                          itemBuilder: (context, index) {
                                            TradeListModel singleTrade =
                                                singleItem.trades[index];
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft: Radius.circular(
                                                        singleItem.trades
                                                                        .length -
                                                                    1 ==
                                                                index
                                                            ? 10.0
                                                            : 0)),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: index % 2 == 0
                                                          ? AppColor
                                                              .primaryTextColor
                                                              .withOpacity(0.1)
                                                          : AppColor
                                                              .primaryHintColor
                                                              .withOpacity(0.1),
                                                      spreadRadius: 0,
                                                      blurRadius: 0),
                                                ],
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 1,
                                                    child: new LabelTextField(
                                                      textSize: 12.0,
                                                      alignment:
                                                          Alignment.center,
                                                      label:
                                                          singleTrade.buy == '1'
                                                              ? singleTrade.qty
                                                                  .toString()
                                                              : 0.toString(),
                                                      textColor: AppColor
                                                          .primaryHintColor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: new LabelTextField(
                                                      textSize: 12.0,
                                                      alignment:
                                                          Alignment.center,
                                                      label:
                                                          singleTrade.buy == '2'
                                                              ? singleTrade.qty
                                                                  .toString()
                                                              : 0.toString(),
                                                      textColor: AppColor
                                                          .primaryHintColor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: new LabelTextField(
                                                      textSize: 12.0,
                                                      alignment:
                                                          Alignment.center,
                                                      label: singleTrade.price
                                                          .toString(),
                                                      textColor: AppColor
                                                          .primaryHintColor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: new LabelTextField(
                                                      textSize: 12.0,
                                                      alignment:
                                                          Alignment.center,
                                                      label: singleTrade
                                                          .tradeTime
                                                          .toString(),
                                                      textColor: AppColor
                                                          .primaryHintColor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: new LabelTextField(
                                                      textSize: 12.0,
                                                      alignment:
                                                          Alignment.center,
                                                      label: singleTrade.tradeNo
                                                          .toString()
                                                          .substring(
                                                              9,
                                                              singleTrade
                                                                  .tradeNo
                                                                  .toString()
                                                                  .length),
                                                      textColor: AppColor
                                                          .primaryHintColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                )
                            ],
                          );
                        }),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget nseFO() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isNSEFO = isNSEFO ? false : true;
            });
          },
          child: Card(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            shadowColor: AppColor.primaryTextColor,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LabelTextField(
                        label: 'NSE Derivative Market',
                        fontFamily: "SemiBold",
                        textSize: 16.0,
                      ),
                      Row(
                        children: [
                          new LabelTextField(
                            label: 'M2M ${calculateM2M(nseFOList)}',
                            fontFamily: 'SemiBold',
                            textColor: double.parse(calculateM2M(nseFOList)) < 0
                                ? AppColor.primaryAlertColor
                                : double.parse(calculateM2M(nseFOList)) > 0
                                    ? AppColor.primaryGreenColor
                                    : AppColor.secondaryTextColor,
                          ),
                          IconView(
                              icon: isNSEFO
                                  ? Icons.keyboard_arrow_up_outlined
                                  : Icons.keyboard_arrow_down)
                        ],
                      )
                    ],
                  ),
                ),
                if (isNSEFO)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 2,
                          child: new LabelTextField(
                            label: 'Symbol',
                            fontFamily: 'SemiBold',
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: new LabelTextField(
                            alignment: Alignment.topRight,
                            label: 'Net Qty',
                            fontFamily: 'SemiBold',
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              new LabelTextField(
                                label: 'Gain',
                                textColor: AppColor.primaryGreenColor,
                                fontFamily: 'SemiBold',
                              ),
                              new LabelTextField(
                                label: '/',
                              ),
                              new LabelTextField(
                                label: 'Loss',
                                textColor: AppColor.primaryAlertColor,
                                fontFamily: 'SemiBold',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (isNSEFO)
                  Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: nseFOList.length,
                        itemBuilder: (context, index) {
                          TradeModel singleItem = nseFOList[index];

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  final tile = nseFOList.firstWhere(
                                      (item) => item.isVisible == true,
                                      orElse: () => new TradeModel(
                                          trades: singleItem.trades));

                                  if (tile.symbol != singleItem.symbol)
                                    setState(() => tile.isVisible = false);
                                  setState(() {
                                    singleItem.isVisible =
                                        singleItem.isVisible ? false : true;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(
                                          nseFOList.length - 1 == index
                                              ? 10
                                              : 0),
                                      bottomLeft: Radius.circular(
                                          nseFOList.length - 1 == index
                                              ? 10
                                              : 0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                          color: index % 2 == 0
                                              ? AppColor.primaryColor
                                                  .withOpacity(0.30)
                                              : AppColor.primaryTextColor,
                                          spreadRadius: 0,
                                          blurRadius: 0),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: Row(
                                            children: [
                                              singleItem.isVisible
                                                  ? IconView(
                                                      color: AppColor
                                                          .primaryHintColor,
                                                      icon: Icons
                                                          .keyboard_arrow_up_outlined,
                                                    )
                                                  : IconView(
                                                      color: AppColor
                                                          .primaryHintColor,
                                                      icon: Icons
                                                          .keyboard_arrow_down,
                                                    ),
                                              new LabelTextField(
                                                label: singleItem.symbol,
                                                fontFamily: 'SemiBold',
                                                textColor:
                                                    AppColor.primaryHintColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: new LabelTextField(
                                            alignment: Alignment.topRight,
                                            label:
                                                '${singleItem.buyQty - singleItem.saleQty}',
                                            textColor:
                                                AppColor.primaryHintColor,
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: new LabelTextField(
                                            alignment: Alignment.topRight,
                                            label:
                                                '${singleItem.profitLose == 0.0 ? 'N/A' : singleItem.profitLose}',
                                            textColor: singleItem.profitLose < 0
                                                ? AppColor.primaryAlertColor
                                                : singleItem.profitLose > 0
                                                    ? AppColor.primaryGreenColor
                                                    : AppColor
                                                        .secondaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (singleItem.isVisible)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 20.0, top: 10.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: AppColor.primaryColor
                                                    .withOpacity(0.30),
                                                spreadRadius: 0,
                                                blurRadius: 0),
                                          ],
                                        ),
                                        padding: EdgeInsets.all(5.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: new LabelTextField(
                                                alignment: Alignment.center,
                                                label: 'Buy Qty',
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: new LabelTextField(
                                                alignment: Alignment.center,
                                                label: 'Sell Qty',
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: new LabelTextField(
                                                alignment: Alignment.center,
                                                label: 'Price',
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: new LabelTextField(
                                                alignment: Alignment.center,
                                                label: 'Time',
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: new LabelTextField(
                                                alignment: Alignment.center,
                                                label: 'Number',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: singleItem.trades.length,
                                          itemBuilder: (context, index) {
                                            TradeListModel singleTrade =
                                                singleItem.trades[index];
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft: Radius.circular(
                                                        singleItem.trades
                                                                        .length -
                                                                    1 ==
                                                                index
                                                            ? 10.0
                                                            : 0)),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: index % 2 == 0
                                                          ? AppColor
                                                              .primaryTextColor
                                                              .withOpacity(0.1)
                                                          : AppColor
                                                              .primaryHintColor
                                                              .withOpacity(0.1),
                                                      spreadRadius: 0,
                                                      blurRadius: 0),
                                                ],
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 1,
                                                    child: new LabelTextField(
                                                      textSize: 12.0,
                                                      alignment:
                                                          Alignment.center,
                                                      label:
                                                          singleTrade.buy == '1'
                                                              ? singleTrade.qty
                                                                  .toString()
                                                              : 0.toString(),
                                                      textColor: AppColor
                                                          .primaryHintColor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: new LabelTextField(
                                                      textSize: 12.0,
                                                      alignment:
                                                          Alignment.center,
                                                      label:
                                                          singleTrade.buy == '2'
                                                              ? singleTrade.qty
                                                                  .toString()
                                                              : 0.toString(),
                                                      textColor: AppColor
                                                          .primaryHintColor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: new LabelTextField(
                                                      textSize: 12.0,
                                                      alignment:
                                                          Alignment.center,
                                                      label: singleTrade.price
                                                          .toString(),
                                                      textColor: AppColor
                                                          .primaryHintColor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: new LabelTextField(
                                                      textSize: 12.0,
                                                      alignment:
                                                          Alignment.center,
                                                      label: singleTrade
                                                          .tradeTime
                                                          .toString(),
                                                      textColor: AppColor
                                                          .primaryHintColor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: new LabelTextField(
                                                      textSize: 12.0,
                                                      alignment:
                                                          Alignment.center,
                                                      label: singleTrade.tradeNo
                                                          .toString(),
                                                      textColor: AppColor
                                                          .primaryHintColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                )
                            ],
                          );
                        }),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget nseCD() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isNSECD = isNSECD ? false : true;
            });
          },
          child: Card(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            shadowColor: AppColor.primaryTextColor,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LabelTextField(
                        label: 'NSE Currency Market',
                        fontFamily: "SemiBold",
                        textSize: 18.0,
                      ),
                      Row(
                        children: [
                          new LabelTextField(
                            label: 'M2M ${calculateM2M(nseCDList)}',
                            fontFamily: 'SemiBold',
                            textColor: double.parse(calculateM2M(nseCDList)) < 0
                                ? AppColor.primaryAlertColor
                                : double.parse(calculateM2M(nseCDList)) > 0
                                    ? AppColor.primaryGreenColor
                                    : AppColor.secondaryTextColor,
                          ),
                          IconView(
                              icon: isNSECD
                                  ? Icons.keyboard_arrow_up_outlined
                                  : Icons.keyboard_arrow_down)
                        ],
                      )
                    ],
                  ),
                ),
                if (isNSECD)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 2,
                          child: new LabelTextField(
                            label: 'Symbol',
                            fontFamily: 'SemiBold',
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: new LabelTextField(
                            alignment: Alignment.topRight,
                            label: 'Net Qty',
                            fontFamily: 'SemiBold',
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              new LabelTextField(
                                label: 'Gain',
                                textColor: AppColor.primaryGreenColor,
                                fontFamily: 'SemiBold',
                              ),
                              new LabelTextField(
                                label: '/',
                              ),
                              new LabelTextField(
                                label: 'Loss',
                                textColor: AppColor.primaryAlertColor,
                                fontFamily: 'SemiBold',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (isNSECD)
                  Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: nseCDList.length,
                        itemBuilder: (context, index) {
                          TradeModel singleItem = nseCDList[index];

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  final tile = nseCDList.firstWhere(
                                      (item) => item.isVisible == true,
                                      orElse: () => new TradeModel(
                                          trades: singleItem.trades));

                                  if (tile.symbol != singleItem.symbol)
                                    setState(() => tile.isVisible = false);
                                  setState(() {
                                    singleItem.isVisible =
                                        singleItem.isVisible ? false : true;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(
                                          nseCDList.length - 1 == index
                                              ? 10
                                              : 0),
                                      bottomLeft: Radius.circular(
                                          nseCDList.length - 1 == index
                                              ? 10
                                              : 0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                          color: index % 2 == 0
                                              ? AppColor.primaryColor
                                                  .withOpacity(0.30)
                                              : AppColor.primaryTextColor,
                                          spreadRadius: 0,
                                          blurRadius: 0),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: Row(
                                            children: [
                                              singleItem.isVisible
                                                  ? IconView(
                                                      color: AppColor
                                                          .primaryHintColor,
                                                      icon: Icons
                                                          .keyboard_arrow_up_outlined,
                                                    )
                                                  : IconView(
                                                      color: AppColor
                                                          .primaryHintColor,
                                                      icon: Icons
                                                          .keyboard_arrow_down,
                                                    ),
                                              new LabelTextField(
                                                label: singleItem.symbol,
                                                fontFamily: 'SemiBold',
                                                textColor:
                                                    AppColor.primaryHintColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: new LabelTextField(
                                            alignment: Alignment.topRight,
                                            label:
                                                '${singleItem.buyQty - singleItem.saleQty}',
                                            textColor:
                                                AppColor.primaryHintColor,
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: new LabelTextField(
                                            alignment: Alignment.topRight,
                                            label:
                                                '${singleItem.profitLose == 0.0 ? 'N/A' : singleItem.profitLose}',
                                            textColor: singleItem.profitLose < 0
                                                ? AppColor.primaryAlertColor
                                                : singleItem.profitLose > 0
                                                    ? AppColor.primaryGreenColor
                                                    : AppColor
                                                        .secondaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (singleItem.isVisible)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 40.0, top: 10.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: AppColor.primaryColor
                                                    .withOpacity(0.30),
                                                spreadRadius: 0,
                                                blurRadius: 0),
                                          ],
                                        ),
                                        padding: EdgeInsets.all(5.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: new LabelTextField(
                                                alignment: Alignment.center,
                                                label: 'Buy Qty',
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: new LabelTextField(
                                                alignment: Alignment.center,
                                                label: 'Sell Qty',
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: new LabelTextField(
                                                alignment: Alignment.center,
                                                label: 'Price',
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: new LabelTextField(
                                                alignment: Alignment.center,
                                                label: 'Time',
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: new LabelTextField(
                                                alignment: Alignment.center,
                                                label: 'Number',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: singleItem.trades.length,
                                          itemBuilder: (context, index) {
                                            TradeListModel singleTrade =
                                                singleItem.trades[index];
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft: Radius.circular(
                                                        singleItem.trades
                                                                        .length -
                                                                    1 ==
                                                                index
                                                            ? 10.0
                                                            : 0)),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: index % 2 == 0
                                                          ? AppColor
                                                              .primaryTextColor
                                                              .withOpacity(0.1)
                                                          : AppColor
                                                              .primaryHintColor
                                                              .withOpacity(0.1),
                                                      spreadRadius: 0,
                                                      blurRadius: 0),
                                                ],
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 1,
                                                    child: new LabelTextField(
                                                      textSize: 12.0,
                                                      alignment:
                                                          Alignment.center,
                                                      label:
                                                          singleTrade.buy == '1'
                                                              ? singleTrade.qty
                                                                  .toString()
                                                              : 0.toString(),
                                                      textColor: AppColor
                                                          .primaryHintColor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: new LabelTextField(
                                                      textSize: 12.0,
                                                      alignment:
                                                          Alignment.center,
                                                      label:
                                                          singleTrade.buy == '2'
                                                              ? singleTrade.qty
                                                                  .toString()
                                                              : 0.toString(),
                                                      textColor: AppColor
                                                          .primaryHintColor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: new LabelTextField(
                                                      textSize: 12.0,
                                                      alignment:
                                                          Alignment.center,
                                                      label: singleTrade.price
                                                          .toString(),
                                                      textColor: AppColor
                                                          .primaryHintColor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: new LabelTextField(
                                                      textSize: 12.0,
                                                      alignment:
                                                          Alignment.center,
                                                      label: singleTrade
                                                          .tradeTime
                                                          .toString(),
                                                      textColor: AppColor
                                                          .primaryHintColor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: new LabelTextField(
                                                      textSize: 12.0,
                                                      alignment:
                                                          Alignment.center,
                                                      label: singleTrade.tradeNo
                                                          .toString(),
                                                      textColor: AppColor
                                                          .primaryHintColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                )
                            ],
                          );
                        }),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bseCM() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isBSECM = isBSECM ? false : true;
            });
          },
          child: Card(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            shadowColor: AppColor.primaryTextColor,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LabelTextField(
                        label: 'BSE CM',
                        fontFamily: "SemiBold",
                        textSize: 18.0,
                      ),
                      IconView(
                          icon: isBSECM
                              ? Icons.keyboard_arrow_up_outlined
                              : Icons.keyboard_arrow_down)
                    ],
                  ),
                ),
                if (isBSECM)
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: bseCMList.length,
                      itemBuilder: (context, index) {
                        TradeModel singleItem = bseCMList[index];

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (singleItem.isVisible)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: new LabelTextField(
                                        label: 'Symbol',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: new LabelTextField(
                                        alignment: Alignment.topRight,
                                        label: 'Net Qty',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          new LabelTextField(
                                            label: 'Gain',
                                            textColor:
                                                AppColor.primaryGreenColor,
                                            fontFamily: 'SemiBold',
                                          ),
                                          new LabelTextField(
                                            label: '/',
                                          ),
                                          new LabelTextField(
                                            label: 'Lose',
                                            textColor:
                                                AppColor.primaryAlertColor,
                                            fontFamily: 'SemiBold',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            GestureDetector(
                              onTap: () {
                                final tile = bseCMList.firstWhere(
                                    (item) => item.isVisible == true,
                                    orElse: () => new TradeModel(
                                        trades: singleItem.trades));

                                if (tile.symbol != singleItem.symbol)
                                  setState(() => tile.isVisible = false);
                                setState(() {
                                  singleItem.isVisible =
                                      singleItem.isVisible ? false : true;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(
                                        bseCMList.length - 1 == index ? 20 : 0),
                                    bottomLeft: Radius.circular(
                                        bseCMList.length - 1 == index ? 20 : 0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: index % 2 == 0
                                            ? AppColor.primaryColor
                                                .withOpacity(0.30)
                                            : AppColor.primaryTextColor,
                                        spreadRadius: 0,
                                        blurRadius: 0),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            singleItem.isVisible
                                                ? IconView(
                                                    color: AppColor
                                                        .primaryHintColor,
                                                    icon: Icons
                                                        .keyboard_arrow_up_outlined,
                                                  )
                                                : IconView(
                                                    color: AppColor
                                                        .primaryHintColor,
                                                    icon: Icons
                                                        .keyboard_arrow_down,
                                                  ),
                                            new LabelTextField(
                                              label: singleItem.symbol,
                                              fontFamily: 'SemiBold',
                                              textColor:
                                                  AppColor.primaryHintColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: new LabelTextField(
                                          alignment: Alignment.topRight,
                                          label:
                                              '${singleItem.saleQty + singleItem.buyQty}',
                                          textColor: AppColor.primaryHintColor,
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: new LabelTextField(
                                          alignment: Alignment.topRight,
                                          label: 'N/A',
                                          textColor: AppColor.primaryHintColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (singleItem.isVisible)
                              Padding(
                                padding: EdgeInsets.only(left: 40.0, top: 10.0),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppColor.primaryColor
                                                  .withOpacity(0.30),
                                              spreadRadius: 0,
                                              blurRadius: 0),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(5.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: new LabelTextField(
                                              alignment: Alignment.center,
                                              label: 'Buy Qty',
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: new LabelTextField(
                                              alignment: Alignment.center,
                                              label: 'Sell Qty',
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: new LabelTextField(
                                              alignment: Alignment.center,
                                              label: 'Price',
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: new LabelTextField(
                                              alignment: Alignment.center,
                                              label: 'Time',
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: new LabelTextField(
                                              alignment: Alignment.center,
                                              label: 'Number',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: singleItem.trades.length,
                                        itemBuilder: (context, index) {
                                          TradeListModel singleTrade =
                                              singleItem.trades[index];
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                      singleItem.trades.length -
                                                                  1 ==
                                                              index
                                                          ? 10.0
                                                          : 0)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: index % 2 == 0
                                                        ? AppColor
                                                            .primaryTextColor
                                                            .withOpacity(0.1)
                                                        : AppColor
                                                            .primaryHintColor
                                                            .withOpacity(0.1),
                                                    spreadRadius: 0,
                                                    blurRadius: 0),
                                              ],
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child: new LabelTextField(
                                                    textSize: 12.0,
                                                    alignment: Alignment.center,
                                                    label:
                                                        singleTrade.buy == '1'
                                                            ? singleTrade.qty
                                                                .toString()
                                                            : 0.toString(),
                                                    textColor: AppColor
                                                        .primaryHintColor,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: new LabelTextField(
                                                    textSize: 12.0,
                                                    alignment: Alignment.center,
                                                    label:
                                                        singleTrade.buy == '1'
                                                            ? singleTrade.qty
                                                                .toString()
                                                            : 0.toString(),
                                                    textColor: AppColor
                                                        .primaryHintColor,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: new LabelTextField(
                                                    textSize: 12.0,
                                                    alignment: Alignment.center,
                                                    label: singleTrade.price
                                                        .toString(),
                                                    textColor: AppColor
                                                        .primaryHintColor,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: new LabelTextField(
                                                    textSize: 12.0,
                                                    alignment: Alignment.center,
                                                    label: singleTrade.tradeTime
                                                        .toString(),
                                                    textColor: AppColor
                                                        .primaryHintColor,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: new LabelTextField(
                                                    textSize: 12.0,
                                                    alignment: Alignment.center,
                                                    label: singleTrade.tradeNo
                                                        .toString(),
                                                    textColor: AppColor
                                                        .primaryHintColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              )
                          ],
                        );
                      })
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bseFO() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isBSEFO = isBSEFO ? false : true;
            });
          },
          child: Card(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            shadowColor: AppColor.primaryTextColor,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LabelTextField(
                        label: 'BSE FO',
                        fontFamily: "SemiBold",
                        textSize: 18.0,
                      ),
                      IconView(
                          icon: isBSEFO
                              ? Icons.keyboard_arrow_up_outlined
                              : Icons.keyboard_arrow_down)
                    ],
                  ),
                ),
                if (isBSEFO)
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: bseFOList.length,
                      itemBuilder: (context, index) {
                        TradeModel singleItem = bseFOList[index];

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (singleItem.isVisible)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: new LabelTextField(
                                        label: 'Symbol',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: new LabelTextField(
                                        alignment: Alignment.topRight,
                                        label: 'Net Qty',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          new LabelTextField(
                                            label: 'Gain',
                                            textColor:
                                                AppColor.primaryGreenColor,
                                            fontFamily: 'SemiBold',
                                          ),
                                          new LabelTextField(
                                            label: '/',
                                          ),
                                          new LabelTextField(
                                            label: 'Lose',
                                            textColor:
                                                AppColor.primaryAlertColor,
                                            fontFamily: 'SemiBold',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            GestureDetector(
                              onTap: () {
                                final tile = bseFOList.firstWhere(
                                    (item) => item.isVisible == true,
                                    orElse: () => new TradeModel(
                                        trades: singleItem.trades));

                                if (tile.symbol != singleItem.symbol)
                                  setState(() => tile.isVisible = false);
                                setState(() {
                                  singleItem.isVisible =
                                      singleItem.isVisible ? false : true;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(
                                        bseFOList.length - 1 == index ? 20 : 0),
                                    bottomLeft: Radius.circular(
                                        bseFOList.length - 1 == index ? 20 : 0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: index % 2 == 0
                                            ? AppColor.primaryColor
                                                .withOpacity(0.30)
                                            : AppColor.primaryTextColor,
                                        spreadRadius: 0,
                                        blurRadius: 0),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            singleItem.isVisible
                                                ? IconView(
                                                    color: AppColor
                                                        .primaryHintColor,
                                                    icon: Icons
                                                        .keyboard_arrow_up_outlined,
                                                  )
                                                : IconView(
                                                    color: AppColor
                                                        .primaryHintColor,
                                                    icon: Icons
                                                        .keyboard_arrow_down,
                                                  ),
                                            new LabelTextField(
                                              label: singleItem.symbol,
                                              fontFamily: 'SemiBold',
                                              textColor:
                                                  AppColor.primaryHintColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: new LabelTextField(
                                          alignment: Alignment.topRight,
                                          label:
                                              '${singleItem.saleQty + singleItem.buyQty}',
                                          textColor: AppColor.primaryHintColor,
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: new LabelTextField(
                                          alignment: Alignment.topRight,
                                          label: 'N/A',
                                          textColor: AppColor.primaryHintColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (singleItem.isVisible)
                              Padding(
                                padding: EdgeInsets.only(left: 40.0, top: 10.0),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppColor.primaryColor
                                                  .withOpacity(0.30),
                                              spreadRadius: 0,
                                              blurRadius: 0),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(5.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: new LabelTextField(
                                              alignment: Alignment.center,
                                              label: 'Buy Qty',
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: new LabelTextField(
                                              alignment: Alignment.center,
                                              label: 'Sell Qty',
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: new LabelTextField(
                                              alignment: Alignment.center,
                                              label: 'Price',
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: new LabelTextField(
                                              alignment: Alignment.center,
                                              label: 'Time',
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: new LabelTextField(
                                              alignment: Alignment.center,
                                              label: 'Number',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: singleItem.trades.length,
                                        itemBuilder: (context, index) {
                                          TradeListModel singleTrade =
                                              singleItem.trades[index];
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                      singleItem.trades.length -
                                                                  1 ==
                                                              index
                                                          ? 10.0
                                                          : 0)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: index % 2 == 0
                                                        ? AppColor
                                                            .primaryTextColor
                                                            .withOpacity(0.1)
                                                        : AppColor
                                                            .primaryHintColor
                                                            .withOpacity(0.1),
                                                    spreadRadius: 0,
                                                    blurRadius: 0),
                                              ],
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child: new LabelTextField(
                                                    textSize: 12.0,
                                                    alignment: Alignment.center,
                                                    label:
                                                        singleTrade.buy == '1'
                                                            ? singleTrade.qty
                                                                .toString()
                                                            : 0.toString(),
                                                    textColor: AppColor
                                                        .primaryHintColor,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: new LabelTextField(
                                                    textSize: 12.0,
                                                    alignment: Alignment.center,
                                                    label:
                                                        singleTrade.buy == '1'
                                                            ? singleTrade.qty
                                                                .toString()
                                                            : 0.toString(),
                                                    textColor: AppColor
                                                        .primaryHintColor,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: new LabelTextField(
                                                    textSize: 12.0,
                                                    alignment: Alignment.center,
                                                    label: singleTrade.price
                                                        .toString(),
                                                    textColor: AppColor
                                                        .primaryHintColor,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: new LabelTextField(
                                                    textSize: 12.0,
                                                    alignment: Alignment.center,
                                                    label: singleTrade.tradeTime
                                                        .toString(),
                                                    textColor: AppColor
                                                        .primaryHintColor,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: new LabelTextField(
                                                    textSize: 12.0,
                                                    alignment: Alignment.center,
                                                    label: singleTrade.tradeNo
                                                        .toString(),
                                                    textColor: AppColor
                                                        .primaryHintColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              )
                          ],
                        );
                      })
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bseCD() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isBSECD = isBSECD ? false : true;
            });
          },
          child: Card(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            shadowColor: AppColor.primaryTextColor,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LabelTextField(
                        label: 'BSE CD',
                        fontFamily: "SemiBold",
                        textSize: 18.0,
                      ),
                      IconView(
                          icon: isBSECD
                              ? Icons.keyboard_arrow_up_outlined
                              : Icons.keyboard_arrow_down)
                    ],
                  ),
                ),
                if (isBSECD)
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: bseCDList.length,
                      itemBuilder: (context, index) {
                        TradeModel singleItem = bseCDList[index];

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (singleItem.isVisible)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: new LabelTextField(
                                        label: 'Symbol',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: new LabelTextField(
                                        alignment: Alignment.topRight,
                                        label: 'Net Qty',
                                        fontFamily: 'SemiBold',
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          new LabelTextField(
                                            label: 'Gain',
                                            textColor:
                                                AppColor.primaryGreenColor,
                                            fontFamily: 'SemiBold',
                                          ),
                                          new LabelTextField(
                                            label: '/',
                                          ),
                                          new LabelTextField(
                                            label: 'Lose',
                                            textColor:
                                                AppColor.primaryAlertColor,
                                            fontFamily: 'SemiBold',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            GestureDetector(
                              onTap: () {
                                final tile = bseCDList.firstWhere(
                                    (item) => item.isVisible == true,
                                    orElse: () => new TradeModel(
                                        trades: singleItem.trades));

                                if (tile.symbol != singleItem.symbol)
                                  setState(() => tile.isVisible = false);
                                setState(() {
                                  singleItem.isVisible =
                                      singleItem.isVisible ? false : true;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(
                                        bseCDList.length - 1 == index ? 20 : 0),
                                    bottomLeft: Radius.circular(
                                        bseCDList.length - 1 == index ? 20 : 0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: index % 2 == 0
                                            ? AppColor.primaryColor
                                                .withOpacity(0.30)
                                            : AppColor.primaryTextColor,
                                        spreadRadius: 0,
                                        blurRadius: 0),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            singleItem.isVisible
                                                ? IconView(
                                                    color: AppColor
                                                        .primaryHintColor,
                                                    icon: Icons
                                                        .keyboard_arrow_up_outlined,
                                                  )
                                                : IconView(
                                                    color: AppColor
                                                        .primaryHintColor,
                                                    icon: Icons
                                                        .keyboard_arrow_down,
                                                  ),
                                            new LabelTextField(
                                              label: singleItem.symbol,
                                              fontFamily: 'SemiBold',
                                              textColor:
                                                  AppColor.primaryHintColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: new LabelTextField(
                                          alignment: Alignment.topRight,
                                          label:
                                              '${singleItem.saleQty + singleItem.buyQty}',
                                          textColor: AppColor.primaryHintColor,
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: new LabelTextField(
                                          alignment: Alignment.topRight,
                                          label: 'N/A',
                                          textColor: AppColor.primaryHintColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (singleItem.isVisible)
                              Padding(
                                padding: EdgeInsets.only(left: 40.0, top: 10.0),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppColor.primaryColor
                                                  .withOpacity(0.30),
                                              spreadRadius: 0,
                                              blurRadius: 0),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(5.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: new LabelTextField(
                                              alignment: Alignment.center,
                                              label: 'Buy Qty',
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: new LabelTextField(
                                              alignment: Alignment.center,
                                              label: 'Sell Qty',
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: new LabelTextField(
                                              alignment: Alignment.center,
                                              label: 'Price',
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: new LabelTextField(
                                              alignment: Alignment.center,
                                              label: 'Time',
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: new LabelTextField(
                                              alignment: Alignment.center,
                                              label: 'Number',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: singleItem.trades.length,
                                        itemBuilder: (context, index) {
                                          TradeListModel singleTrade =
                                              singleItem.trades[index];
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                      singleItem.trades.length -
                                                                  1 ==
                                                              index
                                                          ? 10.0
                                                          : 0)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: index % 2 == 0
                                                        ? AppColor
                                                            .primaryTextColor
                                                            .withOpacity(0.1)
                                                        : AppColor
                                                            .primaryHintColor
                                                            .withOpacity(0.1),
                                                    spreadRadius: 0,
                                                    blurRadius: 0),
                                              ],
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child: new LabelTextField(
                                                    textSize: 12.0,
                                                    alignment: Alignment.center,
                                                    label:
                                                        singleTrade.buy == '1'
                                                            ? singleTrade.qty
                                                                .toString()
                                                            : 0.toString(),
                                                    textColor: AppColor
                                                        .primaryHintColor,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: new LabelTextField(
                                                    textSize: 12.0,
                                                    alignment: Alignment.center,
                                                    label:
                                                        singleTrade.buy == '1'
                                                            ? singleTrade.qty
                                                                .toString()
                                                            : 0.toString(),
                                                    textColor: AppColor
                                                        .primaryHintColor,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: new LabelTextField(
                                                    textSize: 12.0,
                                                    alignment: Alignment.center,
                                                    label: singleTrade.price
                                                        .toString(),
                                                    textColor: AppColor
                                                        .primaryHintColor,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: new LabelTextField(
                                                    textSize: 12.0,
                                                    alignment: Alignment.center,
                                                    label: singleTrade.tradeTime
                                                        .toString(),
                                                    textColor: AppColor
                                                        .primaryHintColor,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: new LabelTextField(
                                                    textSize: 12.0,
                                                    alignment: Alignment.center,
                                                    label: singleTrade.tradeNo
                                                        .toString(),
                                                    textColor: AppColor
                                                        .primaryHintColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              )
                          ],
                        );
                      })
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget testTrade() {
    return ListView.builder(
        primary: false,
        padding: EdgeInsets.symmetric(vertical: 10.0),
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: tradeList.length,
        itemBuilder: (context, index) {
          TradeExpandListModel singleExpandItem = tradeList[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                if (singleExpandItem.isVisible) {
                  rowIndex = -1;
                } else {
                  if (rowIndex != -1) {
                    tradeList[rowIndex].isVisible = false;
                  }
                  rowIndex = index;
                }
                singleExpandItem.isVisible = !singleExpandItem.isVisible;
              });
            },
            child: Card(
                elevation: 5.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                shadowColor: AppColor.primaryTextColor,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LabelTextField(
                            label: singleExpandItem.tradeName,
                            fontFamily: "SemiBold",
                            textSize: 16.0,
                          ),
                          Row(
                            children: [
                              new LabelTextField(
                                label: 'M2M ${singleExpandItem.m2m}',
                                fontFamily: 'SemiBold',
                                textColor:
                                    double.parse(singleExpandItem.m2m) < 0
                                        ? AppColor.primaryAlertColor
                                        : double.parse(singleExpandItem.m2m) > 0
                                            ? AppColor.primaryGreenColor
                                            : AppColor.secondaryTextColor,
                              ),
                              IconView(
                                  icon: singleExpandItem.isVisible
                                      ? Icons.keyboard_arrow_up_outlined
                                      : Icons.keyboard_arrow_down)
                            ],
                          )
                        ],
                      ),
                    ),
                    if (singleExpandItem.isVisible)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 2,
                              child: new LabelTextField(
                                label: 'Symbol',
                                fontFamily: 'SemiBold',
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: new LabelTextField(
                                alignment: Alignment.topRight,
                                label: 'Net Qty',
                                fontFamily: 'SemiBold',
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  new LabelTextField(
                                    label: 'Gain',
                                    textColor: AppColor.primaryGreenColor,
                                    fontFamily: 'SemiBold',
                                  ),
                                  new LabelTextField(
                                    label: '/',
                                  ),
                                  new LabelTextField(
                                    label: 'Loss',
                                    textColor: AppColor.primaryAlertColor,
                                    fontFamily: 'SemiBold',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (singleExpandItem.isVisible)
                      Container(
                        height: MediaQuery.of(context).size.height / 2,
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: singleExpandItem.trades.length,
                            itemBuilder: (context, index) {
                              TradeModel singleItem =
                                  singleExpandItem.trades[index];

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      final tile = singleExpandItem.trades
                                          .firstWhere(
                                              (item) => item.isVisible == true,
                                              orElse: () => new TradeModel(
                                                  trades: singleItem.trades));

                                      if (tile.symbol != singleItem.symbol)
                                        setState(() => tile.isVisible = false);
                                      setState(() {
                                        singleItem.isVisible =
                                            singleItem.isVisible ? false : true;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(
                                              singleExpandItem.trades.length -
                                                          1 ==
                                                      index
                                                  ? 10
                                                  : 0),
                                          bottomLeft: Radius.circular(
                                              singleExpandItem.trades.length -
                                                          1 ==
                                                      index
                                                  ? 10
                                                  : 0),
                                        ),
                                        color: index % 2 == 0
                                            ? AppColor.primaryColor
                                                .withOpacity(0.30)
                                            : AppColor.primaryTextColor,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              flex: 2,
                                              child: Row(
                                                children: [
                                                  singleItem.isVisible
                                                      ? IconView(
                                                          color: AppColor
                                                              .primaryHintColor,
                                                          icon: Icons
                                                              .keyboard_arrow_up_outlined,
                                                        )
                                                      : IconView(
                                                          color: AppColor
                                                              .primaryHintColor,
                                                          icon: Icons
                                                              .keyboard_arrow_down,
                                                        ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    new LabelTextField(
                                                      label: singleItem.symbol,
                                                      fontFamily: 'SemiBold',
                                                      textColor: AppColor
                                                          .primaryHintColor,
                                                    ),
                                                    if(singleItem.optionType!=null)
                                                    new LabelTextField(
                                                      label: calculateStrikeExpiry(singleItem),
                                                      textColor: AppColor.secondaryTextColor,
                                                      textSize: 10.0,
                                                    ),
                                                  ],
                                                )
                                                ],
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: new LabelTextField(
                                                alignment: Alignment.topRight,
                                                label:
                                                    '${singleItem.buyQty - singleItem.saleQty}',
                                                textColor:
                                                    AppColor.primaryHintColor,
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: new LabelTextField(
                                                alignment: Alignment.topRight,
                                                label:
                                                    '${singleItem.profitLose == 0.0 ? 'N/A' : singleItem.profitLose}',
                                                textColor: singleItem
                                                            .profitLose <
                                                        0
                                                    ? AppColor.primaryAlertColor
                                                    : singleItem.profitLose > 0
                                                        ? AppColor
                                                            .primaryGreenColor
                                                        : AppColor
                                                            .secondaryTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (singleItem.isVisible)
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.0, top: 10.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: AppColor.primaryColor
                                                        .withOpacity(0.30),
                                                    spreadRadius: 0,
                                                    blurRadius: 0),
                                              ],
                                            ),
                                            padding: EdgeInsets.all(5.0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child: new LabelTextField(
                                                    alignment: Alignment.center,
                                                    label: 'Buy Qty',
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: new LabelTextField(
                                                    alignment: Alignment.center,
                                                    label: 'Sell Qty',
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: new LabelTextField(
                                                    alignment: Alignment.center,
                                                    label: 'Price',
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: new LabelTextField(
                                                    alignment: Alignment.center,
                                                    label: 'Time',
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: new LabelTextField(
                                                    alignment: Alignment.center,
                                                    label: 'Number',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount:
                                                  singleItem.trades.length,
                                              itemBuilder: (context, index) {
                                                TradeListModel singleTrade =
                                                    singleItem.trades[index];
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                        bottomLeft: Radius
                                                            .circular(singleItem
                                                                            .trades
                                                                            .length -
                                                                        1 ==
                                                                    index
                                                                ? 10.0
                                                                : 0)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: index % 2 == 0
                                                              ? AppColor
                                                                  .primaryTextColor
                                                                  .withOpacity(
                                                                      0.1)
                                                              : AppColor
                                                                  .primaryHintColor
                                                                  .withOpacity(
                                                                      0.1),
                                                          spreadRadius: 0,
                                                          blurRadius: 0),
                                                    ],
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex: 1,
                                                        child:
                                                            new LabelTextField(
                                                          textSize: 12.0,
                                                          alignment:
                                                              Alignment.center,
                                                          label: singleTrade
                                                                      .buy ==
                                                                  '1'
                                                              ? singleTrade.qty
                                                                  .toString()
                                                              : 0.toString(),
                                                          textColor: AppColor
                                                              .primaryHintColor,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child:
                                                            new LabelTextField(
                                                          textSize: 12.0,
                                                          alignment:
                                                              Alignment.center,
                                                          label: singleTrade
                                                                      .buy ==
                                                                  '2'
                                                              ? singleTrade.qty
                                                                  .toString()
                                                              : 0.toString(),
                                                          textColor: AppColor
                                                              .primaryHintColor,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child:
                                                            new LabelTextField(
                                                          textSize: 12.0,
                                                          alignment:
                                                              Alignment.center,
                                                          label: singleTrade
                                                              .price
                                                              .toString(),
                                                          textColor: AppColor
                                                              .primaryHintColor,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child:
                                                            new LabelTextField(
                                                          textSize: 12.0,
                                                          alignment:
                                                              Alignment.center,
                                                          label: singleTrade
                                                              .tradeTime
                                                              .toString(),
                                                          textColor: AppColor
                                                              .primaryHintColor,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child:
                                                            new LabelTextField(
                                                          textSize: 12.0,
                                                          alignment:
                                                              Alignment.center,
                                                          label: singleExpandItem
                                                                      .tradeName ==
                                                                  'NSE Capital Market'
                                                              ? singleTrade
                                                                  .tradeNo
                                                                  .toString()
                                                                  .substring(
                                                                      9,
                                                                      singleTrade
                                                                          .tradeNo
                                                                          .toString()
                                                                          .length)
                                                              : singleTrade
                                                                  .tradeNo
                                                                  .toString(),
                                                          textColor: AppColor
                                                              .primaryHintColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                        ],
                                      ),
                                    )
                                ],
                              );
                            }),
                      )
                  ],
                )),
          );
        });
  }
  String calculateStrikeExpiry( TradeModel singleItem){

    String item=Helpers.changeDateFormat(singleItem.expiry, "yyyy-MM-dd'T'hh:mm:ss", 'ddMMMyyyy');
    if(singleItem.eqFutOpt.contains("FUT")){
      item=item+'-FUT';
    }else{

      item=item+'-'+singleItem.optionType;
      item=item+"-"+singleItem.strikePrice.toString();
    }
    
    return item;
  }
}
