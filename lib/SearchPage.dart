import 'dart:convert';

import 'package:animate_icons/animate_icons.dart';
import 'package:backoffice/components/BackNavigationButton.dart';
import 'package:backoffice/model/WatchListSearchModel.dart';
import 'package:backoffice/services/ApiService.dart';
import 'package:backoffice/services/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

import '../services/globals.dart' as globals;
import 'AppColor.dart';
import 'components/IconView.dart';
import 'components/InputTextField.dart';
import 'components/LabelTextField.dart';
import 'components/Picker.dart';
import 'components/DropDown.dart';
import 'model/ClientListModel.dart';
import 'model/WatchListSearchItemModel.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  int segmentedControlValue = 0;
  AnimateIconController controller = AnimateIconController();
  TextEditingController searchController = TextEditingController();
  Map<String, dynamic> dataMap = new Map<String, dynamic>();
  Response response = Response('', 200);
  ClientListModel singleClient = new ClientListModel();
  List<WatchListSearchItemModel> watchList = [];
  int pageIndex = 0;
  WatchListSearchModel watchListSearchModel =
      new WatchListSearchModel(content: []);
  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    singleClient = globals.clientList[globals.codeIndex];

    scrollController
      ..addListener(() {
        if (scrollController.offset >=
                scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          if (!(watchListSearchModel.last ?? false)) {
            pageIndex++;
            getSearchWatchList(searchController.text);
          }
        }
        if (scrollController.offset <=
                scrollController.position.minScrollExtent &&
            !scrollController.position.outOfRange) {
          setState(() {
            //   message = "reach the top";
          });
        }
      });
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: BackNavigationButton(
                          label: 'Search',
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
                                    }),
                                  }
                              });
                        },
                        child: Picker(singleClient.clientCode ?? ''),
                      ),
                    ],
                  ),
                ),
                new Container(
                  child: new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: InputTextField(
                      onChanged: (text) {
                        onSearchTextChanged(text);
                      },
                      labelText: 'Search',
                      textFieldController: searchController,
                      radius: 10.0,
                      icon: IconView(
                        icon: Icons.search,
                        size: 20,
                        color: AppColor.primaryHintColor,
                      ),
                      autoFocus: true,
                    ),
                  ),
                ),
                Expanded(
                  child: new ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      itemCount: watchList.length,
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        WatchListSearchItemModel rate = watchList[index];
                        return Row(
                          children: [
                            Expanded(
                                child: new Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              shadowColor: AppColor.primaryTextColor,
                              child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      new LabelTextField(
                                        label: rate.symbol == null
                                            ? rate.token
                                                .toString()
                                                .replaceAll("_", " ")
                                            : rate.symbol.toString(),
                                        textColor: AppColor.secondaryTextColor,
                                        textSize: 18.0,
                                        fontFamily: 'Bold',
                                      ),
                                      Row(
                                        children: [
                                          new LabelTextField(
                                            label: rate.name ?? '',
                                            textColor:
                                                AppColor.secondaryTextColor,
                                          ),
                                          Flexible(
                                            child: new LabelTextField(
                                              overflow: TextOverflow.ellipsis,
                                              label:
                                                  ' - ${(rate.type ?? '').contains('NSE') ? 'NSE' : 'BSE'} ${rate.series ?? ''}',
                                              textColor:
                                                  AppColor.secondaryTextColor,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                            )),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  getAddWatchList(rate);
                                });
                              },
                              child: IconView(
                                icon: Icons.add,
                                size: 35,
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ],
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getSearchWatchList(String text) async {
    Map<String, String> headerParam = {
      'Authorization': globals.accessToken,
    };
    await ApiService.getMethod(
      '${Constants.middleWareBaseUrl}/api/v1/security/$text?sort=ordered,name&page=$pageIndex',
      context,
      headerParam: headerParam,
    ).then((result) => {
          response = result,
          if (response.statusCode == 200) dataMap = jsonDecode(response.body),
          {
            setState(() {
              // watchList = WatchListSearchModel.fromJson(dataMap).content;
              watchListSearchModel =
                  WatchListSearchModel.fromJson(jsonDecode(response.body));
              if (pageIndex == 0)
                watchList = watchListSearchModel.content;
              else
                watchList.addAll(watchListSearchModel.content);
            })
          }
        });
  }

  onSearchTextChanged(String text) async {
    setState(() {
      pageIndex = 0;
    });
    if (text.isNotEmpty) getSearchWatchList(text);
  }

  getAddWatchList(WatchListSearchItemModel singleWatchList) async {
    Map<String, String> headerParam = {
      'Authorization': globals.accessToken,
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var bodyParam = {
      'type': singleWatchList.type,
      'token': singleWatchList.token,
      'symbol': singleWatchList.symbol,
      'series': singleWatchList.series,
      'name': singleWatchList.name,
      'isinNumber': singleWatchList.isinNumber,
    };
    await ApiService.getPutMethod(
      '${Constants.middleWareBaseUrl}/api/v1/client/watchList/${globals.wlTabSelected}/${singleClient.clientCode}',
      context,
      bodyParam: jsonEncode(bodyParam),
      headerParam: headerParam,
    ).then((result) => {
          response = result,
          if (response.statusCode == 200)
            {
              setState(() {
                watchList.clear();
                Navigator.pop(context);
              })
            }
        });
  }
}
