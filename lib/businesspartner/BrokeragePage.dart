import 'dart:convert';

import 'package:backoffice/components/BackNavigationButton.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Loader.dart';
import 'package:backoffice/components/SubmitButton.dart';
import 'package:backoffice/model/BrokerageItemModel.dart';
import 'package:backoffice/model/BrokerageModel.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/services/ApiService.dart';
import 'package:backoffice/services/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

import '../AppColor.dart';
import '../services/globals.dart' as globals;

class BrokeragePage extends StatefulWidget {
  State<StatefulWidget> createState() => BrokeragePageState();
}

class BrokeragePageState extends State<BrokeragePage> {
  List<BrokerageItemModel> brokerageList = [];
  double totalBrokerage = 0.0;
  Response response = Response('', 200);
  ClientListModel singleClient = new ClientListModel();
  Map<String, dynamic> dataMap = new Map<String, dynamic>();
  BrokerageModel brokerageModel = new BrokerageModel(content: []);
  int pageIndex=0;
  ScrollController scrollController = new ScrollController();

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    singleClient = globals.clientList[globals.codeIndex];
   getBrokerage();
    getBrokerageTotal();

    scrollController
      ..addListener(() {
        if (scrollController.offset >=
            scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          if (!(brokerageModel.last ?? false)) {
            pageIndex++;
            getBrokerage();
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

  getBrokerage() async {
    Map<String, String> headerParam = {
      'Authorization': globals.accessToken,
    };
    await ApiService.getMethod(
      '${Constants.middleWareBaseUrl}/api/v1/branch/${globals.singleBranch.branchCode}/brokerage?page=$pageIndex',
      context,
      headerParam: headerParam,
    ).then((result) => {
          response = result,
          if (response.statusCode == 200) dataMap = jsonDecode(response.body),
          {
            setState(() {
              brokerageModel = BrokerageModel.fromJson(jsonDecode(response.body));
              brokerageList.addAll(brokerageModel.content);
            })
          }
        });
  }
  getBrokerageTotal() async {
    Map<String, String> headerParam = {
      'Authorization': globals.accessToken,
    };
    await ApiService.getMethod(
      '${Constants.middleWareBaseUrl}/api/v1/branch/brokerage/${globals.singleBranch.branchCode}/total',
      context,
      headerParam: headerParam,
    ).then((result) => {
      response = result,
      if (response.statusCode == 200) dataMap = jsonDecode(response.body),
      {
        setState(() {
          Map<String, dynamic> data = new Map<String, dynamic>.from(json.decode(response.body));
          totalBrokerage=data['brokerage'];
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
          child: Column(
            children: [
              BackNavigationButton(
                label: 'Brokerage',
                isBackVisible: true,
              ),
              Expanded(
                  child: brokerageList.isEmpty
                      ? Loader()
                      : ListView.builder(
                          primary: false,
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: brokerageList.length,
                          itemBuilder: (context, index) {
                            BrokerageItemModel singleItem = brokerageList[index];
                            return Column(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5.0,
                                  shadowColor: AppColor.primaryTextColor,
                                  child: new Padding(
                                    padding: new EdgeInsets.all(7.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        LabelTextField(
                                          label: singleItem.name.toString(),
                                          textSize: 18.0,
                                          fontFamily: 'SemiBold',
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0.0, 5.0, 0.0, 5.0),
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              LabelTextField(
                                                label: singleItem.clientCode.toString(),
                                                textColor:
                                                    AppColor.secondaryTextColor,
                                              ),
                                              LabelTextField(
                                                label: singleItem.brokerage.toString(),
                                                textColor:
                                                    AppColor.secondaryTextColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          })),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: SubmitButton(
                  onPressed: () {},
                  label:
                      'Total Brokerage ₹ ${totalBrokerage.toStringAsFixed(2)}',
                  fontFamily: 'SemiBold',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
