import 'dart:convert';
import 'dart:ui';

import 'package:backoffice/components/DefaultPlaceHolder.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/model/HoldingModel.dart';
import 'package:backoffice/services/ApiService.dart';
import 'package:backoffice/services/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

import '../AppColor.dart';
import '../services/globals.dart' as globals;

class StockCusaHoldingPage extends StatefulWidget {
  const StockCusaHoldingPage({Key? key}) : super(key: key);

  State<StatefulWidget> createState() => StockCusaHoldingPageState();
}

class StockCusaHoldingPageState extends State<StockCusaHoldingPage> {
  ClientListModel singleClient = new ClientListModel();
  Response response = Response('', 200);
  List<HoldingModel> holdingList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      singleClient = globals.clientList[globals.codeIndex];
      getCusaHolding();
    });


  }
  @override
  void setState(VoidCallback fn) {
    if(mounted)
    super.setState(fn);

  }


  @override
  Widget build(BuildContext context) {
    return holdingList.isEmpty
        ? Center(child: DefaultPlaceHolder())
        : SingleChildScrollView(
            child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: holdingList.length,
                itemBuilder: (context, index) {
                  HoldingModel holdingItem = holdingList[index];

                  return new Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    shadowColor: AppColor.primaryTextColor,
                    child: new Padding(
                        padding: new EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                child: LabelTextField(
                              label: holdingItem.scriptName ?? '',
                              fontFamily: 'SemiBold',
                              textSize: 18.0,
                            )),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: new LabelTextField(
                                    label: '${holdingItem.scriptQty ?? ''}',
                                    textColor: AppColor.secondaryTextColor,
                                    textSize: 16.0,
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: new LabelTextField(
                                    alignment: Alignment.center,
                                    label: '${holdingItem.scriptPrice ?? ''}',
                                    textColor: AppColor.secondaryTextColor,
                                    textSize: 16.0,
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: new LabelTextField(
                                    alignment: Alignment.topRight,
                                    label: '${holdingItem.scriptValue ?? ''}',
                                    textColor: AppColor.secondaryTextColor,
                                    textSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  );
                }),
          );
  }

  getCusaHolding() async {
    singleClient = globals.clientList[globals.codeIndex];
    Map<String, String> headerParam = {
      'Authorization': globals.accessToken,
    };
    await ApiService.getMethod(
      '${Constants.middleWareBaseUrl}/api/v1/holding/cusa/${singleClient.clientCode}',
      context,
      headerParam: headerParam,  isShowLoader: true,
    ).then((result) => {
          response = result,
          if (response.statusCode == 200)
            {
              setState(() {
                holdingList = (json.decode(response.body) as List)
                    .map((i) => HoldingModel.fromJson(i))
                    .toList();
              })
            }
        });
  }
}
