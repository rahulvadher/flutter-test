import 'dart:convert';

import 'package:backoffice/SearchPage.dart';
import 'package:backoffice/components/DefaultPlaceHolder.dart';
import 'package:backoffice/components/FundDialog.dart';
import 'package:backoffice/components/IconView.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Picker.dart';
import 'package:backoffice/components/DropDown.dart';
import 'package:backoffice/components/SubmitButton.dart';
import 'package:backoffice/components/WithdrawFundDialog.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/model/LTPModel.dart';
import 'package:backoffice/model/LedgerStockValueModel.dart';
import 'package:backoffice/model/WatchListModel.dart';
import 'package:backoffice/services/ApiService.dart';
import 'package:backoffice/services/Constants.dart';
import 'package:backoffice/services/Helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../AppColor.dart';
import '../services/globals.dart' as globals;

class HomeMenuPage extends StatefulWidget {
  State<StatefulWidget> createState() => HomeMenuPageState();
}

class HomeMenuPageState extends State<HomeMenuPage>
    with SingleTickerProviderStateMixin {
  bool positionIsVisible = false, isDeleteVisible = false;
  List<WatchListModel> watchList = [];
  WatchListModel ltpNifty = new WatchListModel();
  WatchListModel ltpSensex = new WatchListModel();
  ClientListModel singleClient = new ClientListModel();
  LedgerStockValueModel singleValue = new LedgerStockValueModel();
  int rowIndex = -1;
  TextEditingController numberController = TextEditingController();
  TextEditingController controller = new TextEditingController();
  Map<String, dynamic> dataMap = new Map<String, dynamic>();
  Response response = Response('', 200);
  late TabController _tabController;
  int wlTabSelected = 0;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    if (globals.stompClient != null && !globals.stompClient!.isDisconnected) {
      callSensexNifty();
    }
    super.initState();
    _tabController =
        new TabController(vsync: this, length: 5, initialIndex: wlTabSelected);
    _tabController.addListener(() {
      setState(() {
        wlTabSelected = _tabController.index;
        globals.wlTabSelected = wlTabSelected;
        getWatchList();
      });
    });
    Helpers.getStringSF('accessToken').then((value) => {
          if (value != null)
            {
              globals.accessToken = 'Bearer $value',
              globals.token = value,
              getClient(),
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Card(

            shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
            ),
            shadowColor: AppColor.primaryTextColor,
            margin: EdgeInsets.zero,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DropDown(
                                        pickerData: globals.clientList);
                                  }).then((value) => {
                                    if (value != null)
                                      {
                                        setState(() {
                                          singleClient = value;
                                          getWatchList();
                                          getLegerStockValue();
                                        }),
                                      }
                                  });
                            },
                            child: Picker(singleClient.clientCode ?? '')),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              positionIsVisible =
                                  positionIsVisible ? false : true;
                            });
                          },
                          child: IconView(
                            icon: positionIsVisible
                                ? Icons.close
                                : Icons.arrow_drop_down_sharp,
                            size: 40,
                          ),
                        )
                      ],
                    ),
                    sensexnifty(),
                    if (positionIsVisible)
                      Column(
                        children: [
                          Container(
                            width: width / 2,
                            height: 1.0,
                            color: AppColor.primaryColor,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    LabelTextField(
                                      label: 'Ledger Balance',
                                      fontFamily: 'SemiBold',
                                      textSize: 18.0,
                                    ),
                                    LabelTextField(
                                      label:
                                          '₹ ${singleValue.ledger?.balance.toString() ?? '0.0'}',
                                      fontFamily: 'Bold',
                                      textSize: 18.0,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    LabelTextField(
                                      label: 'Stock Value',
                                      fontFamily: 'SemiBold',
                                      textSize: 18.0,
                                    ),
                                    LabelTextField(
                                      label:
                                          '₹ ${singleValue.stock?.balance.toString() ?? '0.0'}',
                                      fontFamily: 'Bold',
                                      textSize: 18.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: SubmitButton(
                                    backGroundColor: AppColor.primaryGreenColor,
                                    borderWidth: 0.0,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return FundDialog();
                                        },
                                      );
                                    },
                                    shadowColors: AppColor.primaryGreenColor,
                                    label: 'Add Funds',
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: SubmitButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return WithdrawFundDialog();
                                        },
                                      );
                                    },
                                    label: 'Withdraw',
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SearchPage()))
                  .then((value) => {getWatchList()});
            },
            child: new Container(
              child: new Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new LabelTextField(
                        label: 'Watchlist',
                        textColor: AppColor.primaryColor,
                        textSize: 22.0,
                        fontFamily: 'Bold',
                      ),
                      IconView(
                        icon: Icons.add,
                        size: 30,
                        color: AppColor.primaryColor,
                      )
                    ],
                  )),
            ),
          ),
          TabBar(
              labelColor: AppColor.primaryColor,
              indicatorColor: AppColor.primaryColor,
              controller: _tabController,
              tabs: const <Widget>[
                Tab(
                  text: "WL 1",
                ),
                Tab(
                  text: "WL 2",
                ),
                Tab(
                  text: "WL 3",
                ),
                Tab(
                  text: "WL 4",
                ),
                Tab(
                  text: "WL 5",
                ),
              ]),
          watchList.isNotEmpty
              ? watchListView()
              : Expanded(child: DefaultPlaceHolder()),
        ],
      ),
    );
  }

  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = watchList.removeAt(oldindex);
      watchList.insert(newindex, items);
    });
  }

  double closingDifference(WatchListModel rate) {
    return double.parse(rate.newLTP?.price.toString() ??
            (rate.closingPrice ?? 0).toString()) -
        double.parse(rate.previousClosePrice?.toString() ?? "0.0");
  }

  double closingPR(WatchListModel rate) {
    return closingDifference(rate).abs() *
        100 /
        double.parse(rate.previousClosePrice?.toString() ?? "0.0");
  }

  Widget watchListView() {
    return Flexible(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: ReorderableListView(
          proxyDecorator:
              (Widget child, int index, Animation<double> animation) {
            return Material(
              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 10.0,
                shadowColor: AppColor.primaryColor,
                color: AppColor.primaryColor,
                child: child,
              ),
            );
          },
          children: <Widget>[
            for (int i = 0; i < watchList.length; i++)
              Row(
                key: Key('${watchList[i].id}'),
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (watchList[i].isVisible) {
                            rowIndex = -1;
                          } else {
                            if (rowIndex != -1) {
                              watchList[rowIndex].isVisible = false;
                            }
                            rowIndex = i;
                          }
                          watchList[i].isVisible = !watchList[i].isVisible;
                        });
                      },
                      child: new Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),

                        shadowColor: AppColor.primaryTextColor,
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Wrap(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        new LabelTextField(
                                          label: watchList[i].symbol == null
                                              ? watchList[i]
                                                  .token
                                                  .toString()
                                                  .replaceAll("_", " ")
                                              : watchList[i].symbol.toString(),
                                          textColor:
                                              AppColor.secondaryTextColor,
                                          textSize: 18.0,
                                          fontFamily: 'Bold',
                                        ),
                                        new LabelTextField(
                                          label: watchList[i].subTitle ?? '',
                                          textColor:
                                              AppColor.secondaryTextColor,
                                          textSize: 12.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: new LabelTextField(
                                            label: watchList[i]
                                                    .newLTP
                                                    ?.price!
                                                    .toStringAsFixed(2) ??
                                                (watchList[i].price ?? 0)
                                                    .toStringAsFixed(2)
                                                    .toString(),
                                            textColor: (watchList[i]
                                                            .newLTP
                                                            ?.price ??
                                                        0.0) ==
                                                    (watchList[i]
                                                            .oldLTP
                                                            ?.price ??
                                                        0.0)
                                                ? AppColor.secondaryTextColor
                                                : ((watchList[i]
                                                                .newLTP
                                                                ?.price ??
                                                            0.0) <
                                                        (watchList[i]
                                                                .oldLTP
                                                                ?.price ??
                                                            0.0)
                                                    ? AppColor.primaryAlertColor
                                                    : AppColor
                                                        .primaryGreenColor),
                                            fontFamily: 'SemiBold',
                                            textSize: 22.0,
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            new LabelTextField(
                                              label: closingDifference(
                                                      watchList[i])
                                                  .toStringAsFixed(2),
                                              fontFamily: 'SemiBold',
                                              textColor: closingDifference(
                                                          watchList[i]) ==
                                                      0
                                                  ? AppColor.secondaryTextColor
                                                  : (closingDifference(
                                                              watchList[i]) <
                                                          0
                                                      ? AppColor
                                                          .primaryAlertColor
                                                      : AppColor
                                                          .primaryGreenColor),
                                            ),
                                            new LabelTextField(
                                              label:
                                                  '${closingPR(watchList[i]).isNaN ? 0.0 : closingPR(watchList[i]).isInfinite ? 0.0 : closingPR(watchList[i]).toStringAsFixed(2)}%',
                                              fontFamily: 'SemiBold',
                                              textColor: closingDifference(
                                                          watchList[i]) ==
                                                      0
                                                  ? AppColor.secondaryTextColor
                                                  : (closingDifference(
                                                              watchList[i]) <
                                                          0
                                                      ? AppColor
                                                          .primaryAlertColor
                                                      : AppColor
                                                          .primaryGreenColor),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (double.parse((watchList[i].newLTP?.openPrice ?? watchList[i].openPrice ?? 0).toStringAsFixed(2))>0&&watchList[i].isVisible)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        new LabelTextField(
                                          label: 'O:',
                                          textColor: AppColor.primaryColor,
                                          fontFamily: "Bold",
                                        ),
                                        new LabelTextField(
                                          label:
                                              '${(watchList[i].newLTP?.openPrice ?? watchList[i].openPrice ?? 0).toStringAsFixed(2)}',
                                          textColor:
                                              AppColor.secondaryTextColor,
                                          textSize: 12.0,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        new LabelTextField(
                                          label: 'H:',
                                          textColor: AppColor.primaryColor,
                                          fontFamily: "Bold",
                                        ),
                                        new LabelTextField(
                                          label:
                                              '${(watchList[i].newLTP?.highPrice ?? watchList[i].highPrice ?? 0).toStringAsFixed(2)}',
                                          textColor:
                                              AppColor.secondaryTextColor,
                                          textSize: 12.0,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        new LabelTextField(
                                          label: 'L:',
                                          textColor: AppColor.primaryColor,
                                          fontFamily: "Bold",
                                        ),
                                        new LabelTextField(
                                          label:
                                              '${(watchList[i].newLTP?.lowPrice ?? watchList[i].lowPrice ?? 0).toStringAsFixed(2)}',
                                          textColor:
                                              AppColor.secondaryTextColor,
                                          textSize: 12.0,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        new LabelTextField(
                                          label: 'C:',
                                          textColor: AppColor.primaryColor,
                                          fontFamily: "Bold",
                                        ),
                                        new LabelTextField(
                                          label:
                                              '${(watchList[i].newLTP?.closingPrice ?? watchList[i].closingPrice ?? 0).toStringAsFixed(2)}',
                                          textColor:
                                              AppColor.secondaryTextColor,
                                          textSize: 12.0,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: watchList[i].isVisible,
                    child: GestureDetector(
                      onTap: () {
                        getDeleteWatchList(watchList[i]);
                      },
                      child: IconView(
                        icon: Icons.delete_outline,
                        size: 25,
                        color: AppColor.primaryAlertColor,
                      ),
                    ),
                  ),
                ],
              )
          ],
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              watchList.insert(newIndex, watchList.removeAt(oldIndex));
              callReorderWatchList();
            });
          },
        ),
      ),
    );
  }

  callReorderWatchList() async {
    Map<String, String> headerParam = {
      'Authorization': globals.accessToken,
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    await ApiService.getPutMethod(
      '${Constants.middleWareBaseUrl}/api/v1/client/watchList/${globals.wlTabSelected}/${singleClient.clientCode}/order',
      context,
      bodyParam: jsonEncode(watchList),
      headerParam: headerParam,
    ).then((result) => {
          response = result,
          if (response.statusCode == 200)
            {
              setState(() {
                callUnSubscribe();
                watchList = (json.decode(response.body) as List)
                    .map((i) => WatchListModel.fromJson(i))
                    .toList();
                callStomp();
              })
            }
        });
  }

  Widget sensexnifty() {
    double closingDifferenceSensex = double.parse(
            ltpSensex.newLTP?.price.toString() ??
                (ltpSensex.closingPrice ?? 0).toString()) -
        double.parse(ltpSensex.previousClosePrice?.toString() ?? "0.0");
    double closingPRSensex = closingDifferenceSensex.abs() *
        100 /
        double.parse(ltpSensex.previousClosePrice?.toString() ?? "0.0");

    double closingDifferenceNifty = double.parse(
            ltpNifty.newLTP?.price.toString() ??
                (ltpNifty.closingPrice ?? 0).toString()) -
        double.parse(ltpNifty.previousClosePrice?.toString() ?? "0.0");
    double closingPRNifty = closingDifferenceNifty.abs() *
        100 /
        double.parse(ltpNifty.previousClosePrice?.toString() ?? "0.0");
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 2,
            child: new Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        new LabelTextField(
                          label: 'SENSEX',
                          fontFamily: 'Bold',
                          textSize: 20.0,
                        ),
                        LabelTextField(
                          label: ltpSensex.newLTP?.price!.toStringAsFixed(2) ??
                              (ltpSensex.closingPrice ?? 0).toStringAsFixed(2),
                          textColor: (ltpSensex.newLTP?.price ?? 0.0) ==
                                  (ltpSensex.oldLTP?.price ?? 0.0)
                              ? AppColor.secondaryTextColor
                              : ((ltpSensex.newLTP?.price ?? 0.0) <
                                      (ltpSensex.oldLTP?.price ?? 0.0)
                                  ? AppColor.primaryAlertColor
                                  : AppColor.primaryGreenColor),
                          fontFamily: 'Bold',
                          textSize: 24.0,
                        ),
                        Row(
                          children: [
                            IconView(
                              icon: closingDifferenceSensex < 0
                                  ? Icons.arrow_drop_down_sharp
                                  : closingDifferenceSensex > 0
                                      ? Icons.arrow_drop_up_outlined
                                      : Icons.arrow_drop_down_sharp,
                              size: 30,
                              color: closingDifferenceSensex < 0
                                  ? AppColor.primaryAlertColor
                                  : closingDifferenceSensex > 0
                                      ? AppColor.primaryGreenColor
                                      : AppColor.secondaryTextColor,
                            ),
                            new LabelTextField(
                              label: closingDifferenceSensex
                                  .toStringAsFixed(2)
                                  .toString(),
                              textColor: closingDifferenceSensex < 0
                                  ? AppColor.primaryAlertColor
                                  : closingDifferenceSensex > 0
                                      ? AppColor.primaryGreenColor
                                      : AppColor.secondaryTextColor,
                            ),
                            new LabelTextField(
                              label:
                                  '(${closingPRSensex.isNaN ? 0.0 : closingPRSensex.isInfinite ? 0.0 : closingPRSensex.toStringAsFixed(2)}%)',
                              textColor: closingDifferenceSensex < 0
                                  ? AppColor.primaryAlertColor
                                  : closingDifferenceSensex > 0
                                      ? AppColor.primaryGreenColor
                                      : AppColor.secondaryTextColor,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                )
              ],
            )),
          ),
          Expanded(
            flex: 0,
            child: Container(
              width: 1.0,
              height: 60.0,
              color: AppColor.primaryColor,
            ),
          ),
          Expanded(
            flex: 2,
            child: new Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        new LabelTextField(
                          label: 'NIFTY',
                          fontFamily: 'Bold',
                          textSize: 20.0,
                        ),
                        new LabelTextField(
                          label: ltpNifty.newLTP?.price!.toStringAsFixed(2) ??
                              (ltpNifty.closingPrice ?? 0).toStringAsFixed(2),
                          textColor: (ltpNifty.newLTP?.price ?? 0.0) ==
                                  (ltpNifty.oldLTP?.price ?? 0.0)
                              ? AppColor.secondaryTextColor
                              : ((ltpNifty.newLTP?.price ?? 0.0) <
                                      (ltpNifty.oldLTP?.price ?? 0.0)
                                  ? AppColor.primaryAlertColor
                                  : AppColor.primaryGreenColor),
                          fontFamily: 'Bold',
                          textSize: 24.0,
                        ),
                        Row(
                          children: [
                            IconView(
                              icon: closingDifferenceSensex < 0
                                  ? Icons.arrow_drop_down_sharp
                                  : closingDifferenceSensex > 0
                                      ? Icons.arrow_drop_up_outlined
                                      : Icons.arrow_drop_down_sharp,
                              size: 30,
                              color: closingDifferenceSensex < 0
                                  ? AppColor.primaryAlertColor
                                  : closingDifferenceSensex > 0
                                      ? AppColor.primaryGreenColor
                                      : AppColor.secondaryTextColor,
                            ),
                            new LabelTextField(
                              label: closingDifferenceNifty
                                  .toStringAsFixed(2)
                                  .toString(),
                              textColor: closingDifferenceNifty < 0
                                  ? AppColor.primaryAlertColor
                                  : closingDifferenceNifty > 0
                                      ? AppColor.primaryGreenColor
                                      : AppColor.secondaryTextColor,
                            ),
                            new LabelTextField(
                              label:
                                  '(${closingPRNifty.isNaN ? 0.0 : closingPRNifty.isInfinite ? 0.0 : closingPRNifty.toStringAsFixed(2)}%)',
                              textColor: closingDifferenceNifty < 0
                                  ? AppColor.primaryAlertColor
                                  : closingDifferenceNifty > 0
                                      ? AppColor.primaryGreenColor
                                      : AppColor.secondaryTextColor,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                )
              ],
            )),
          ),
        ],
      ),
    );
  }

  getClient() async {
    Map<String, String> headerParam = {
      'Authorization': globals.accessToken,
    };
    await ApiService.getMethod(
      '${Constants.middleWareBaseUrl}/api/v1/client/',
      context,
      headerParam: headerParam,
    ).then((result) => {
          response = result,
          if (response.statusCode == 200)
            {
              setState(() {
                List<ClientListModel> clientList =
                    (json.decode(response.body) as List)
                        .map((i) => ClientListModel.fromJson(i))
                        .toList();
                globals.clientList = clientList;
                singleClient = globals.clientList[globals.codeIndex];
                getLegerStockValue();
                getWatchList();
              })
            }
        });
  }

  getLegerStockValue() async {
    Map<String, String> headerParam = {
      'Authorization': globals.accessToken,
    };
    await ApiService.getMethod(
      '${Constants.middleWareBaseUrl}/api/v1/client/values/${singleClient.clientCode}',
      context,
      headerParam: headerParam,
    ).then((result) => {
          response = result,
          if (response.statusCode == 200)
            {
              setState(() {
                singleValue =
                    LedgerStockValueModel.fromJson(jsonDecode(response.body));
                globals.singleValue = singleValue;
              })
            }
        });
  }

  getWatchList() async {
    Map<String, String> headerParam = {
      'Authorization': globals.accessToken,
    };
    await ApiService.getMethod(
      '${Constants.middleWareBaseUrl}/api/v1/client/watchList/$wlTabSelected/${singleClient.clientCode}',
      context,
      headerParam: headerParam,
    ).then((result) => {
          response = result,
          if (response.statusCode == 200)
            {
              setState(() {
                callUnSubscribe();
                watchList = (json.decode(response.body) as List)
                    .map((i) => WatchListModel.fromJson(i))
                    .toList();
                callStomp();
              })
            }
        });
  }

  getDeleteWatchList(WatchListModel watchListModel) async {
    if (globals.stompClient != null)
      globals.stompClient!.unsubscribe(watchListModel.token.toString());
    Map<String, String> headerParam = {
      'Authorization': globals.accessToken,
    };
    await ApiService.getDeleteMethod(
      '${Constants.middleWareBaseUrl}/api/v1/client/watchList/$wlTabSelected/${singleClient.clientCode}/${watchListModel.id}',
      context,
      headerParam: headerParam,
    ).then((result) => {
          response = result,
          if (response.statusCode == 200)
            {
              setState(() {
                watchList = (json.decode(response.body) as List)
                    .map((i) => WatchListModel.fromJson(i))
                    .toList();
                rowIndex = -1;
                getWatchList();
              })
            }
        });
  }

  Future<void> callStomp() async {
    if (globals.stompClient != null) {
      for (int i = 0; i < watchList.length; i++) {
        globals.stompClient!.subscribeString(
            '${watchList[i].type.toString()}/${watchList[i].token.toString()}',
            '${Constants.ltpTopic}/${watchList[i].type.toString()}/${watchList[i].token.toString()}',
            (Map<String, String> headers, String message) {
          Map<String, dynamic> dataMap = jsonDecode(message);
          LTPModel temp = LTPModel.fromJson(dataMap);
          if (this.mounted)
            setState(() {
              if (watchList[i].newLTP?.price != temp.price) {
                watchList[i].oldLTP = watchList[i].newLTP;
                watchList[i].newLTP = temp;
              }
            });
        });
      }
      globals.stompClient!
          .subscribeString('security', '${Constants.ltpTopicSecurity}',
              (Map<String, String> headers, String message) {
        Map<String, dynamic> dataMap = jsonDecode(message);
        WatchListModel temp = WatchListModel.fromJson(dataMap);

        if (this.mounted)
          setState(() {
            if (temp.token == 'Nifty_50') {
              ltpNifty = temp;
            } else if (temp.token == 'SENSEX') {
              ltpSensex = temp;
            }
          });
      });
    }
  }

  void callSensexNifty() {
    if (globals.stompClient != null) {
      globals.stompClient!.subscribeString(
          'NSE_CM/Nifty_50', '${Constants.ltpTopic}/NSE_CM/Nifty_50',
          (Map<String, String> headers, String message) {
        Map<String, dynamic> dataMap = jsonDecode(message);
        LTPModel temp = LTPModel.fromJson(dataMap);

        setState(() {
          if (ltpNifty.newLTP?.price != temp.price) {
            ltpNifty.oldLTP = ltpNifty.newLTP;
            ltpNifty.newLTP = temp;
          }
        });
      });
      globals.stompClient!.subscribeString(
          'BSE_CM/SENSEX', '${Constants.ltpTopic}/BSE_CM/SENSEX',
          (Map<String, String> headers, String message) {
        Map<String, dynamic> dataMap = jsonDecode(message);
        LTPModel temp = LTPModel.fromJson(dataMap);

        setState(() {
          if (ltpSensex.newLTP?.price != temp.price) {
            ltpSensex.oldLTP = ltpSensex.newLTP;
            ltpSensex.newLTP = temp;
          }
        });
      });
      globals.stompClient!
          .subscribeString('security', '${Constants.ltpTopicSecurity}',
              (Map<String, String> headers, String message) {
        Map<String, dynamic> dataMap = jsonDecode(message);
        WatchListModel temp = WatchListModel.fromJson(dataMap);
        if (this.mounted)
          setState(() {
            if (temp.token == 'Nifty_50') {
              ltpNifty = temp;
            } else if (temp.token == 'SENSEX') {
              ltpSensex = temp;
            }
          });
      });

      globals.stompClient!
          .sendString('${Constants.ltpSend}/NSE_CM/Nifty_50', '');
      globals.stompClient!.sendString('${Constants.ltpSend}/BSE_CM/SENSEX', '');
    }
  }

  void callUnSubscribe() {
    if (globals.stompClient != null && !globals.stompClient!.isDisconnected) {
      globals.stompClient!.unsubscribe('security');
      for (int i = 0; i < watchList.length; i++) {
        globals.stompClient!.unsubscribe(
            '${watchList[i].type.toString()}/${watchList[i].token.toString()}');
      }

      /// globals.stompClient.disconnect();
    }
  }

  @override
  void dispose() {
    if (globals.stompClient != null && !globals.stompClient!.isDisconnected) {
      globals.stompClient!.unsubscribe('NSE_CM/Nifty_50');
      globals.stompClient!.unsubscribe('BSE_CM/SENSEX');
      callUnSubscribe();
    }
    super.dispose();
  }
}
