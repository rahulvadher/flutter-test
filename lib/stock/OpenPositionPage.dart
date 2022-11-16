import 'dart:convert';

import 'package:backoffice/components/DefaultPlaceHolder.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Loader.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/model/HoldingModel.dart';
import 'package:backoffice/model/PositionModel.dart';
import 'package:backoffice/services/ApiService.dart';
import 'package:backoffice/services/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

import '../AppColor.dart';
import '../services/globals.dart' as globals;

class OpenPositionPage extends StatefulWidget {
  const OpenPositionPage({Key? key}) : super(key: key);

  State<StatefulWidget> createState() => OpenPositionPageState();
}

class OpenPositionPageState extends State<OpenPositionPage> {
  ClientListModel singleClient = new ClientListModel();
  Response response = Response('', 200);
  List<PositionModel> positionList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () {
      singleClient = globals.clientList[globals.codeIndex];
      getPledgedHolding();
    });
  }
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted)
      super.setState(fn);
  }


  @override
  Widget build(BuildContext context) {
    return positionList.isEmpty
        ? Center(child: DefaultPlaceHolder())
        : SingleChildScrollView(
            child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: positionList.length,
                itemBuilder: (context, index) {
                  PositionModel singleItem = positionList[index];

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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                LabelTextField(
                                  label: singleItem.scriptCode.toString(),
                                  fontFamily: 'SemiBold',
                                  textSize: 18.0,
                                ),
                                LabelTextField(
                                  label:
                                      'Exp. Date: ${singleItem.expiryDate.toString()}',
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: new LabelTextField(
                                    label:
                                        'Type: ${singleItem.optionType.toString()}',
                                    textColor: AppColor.secondaryTextColor,
                                    textSize: 13.0,
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: new LabelTextField(
                                    alignment: Alignment.center,
                                    label:
                                        'Qty: ${singleItem.scriptQty.toString()}',
                                    textColor: AppColor.secondaryTextColor,
                                    textSize: 13.0,
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: new LabelTextField(
                                    alignment: Alignment.topRight,
                                    label:
                                        'Value: ${singleItem.scriptValue.toString()}',
                                    textColor: AppColor.secondaryTextColor,
                                    textSize: 13.0,
                                  ),
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: new LabelTextField(
                                    alignment: Alignment.topLeft,
                                    label:
                                        'Strike Price: ${singleItem.strikePrice.toString()}',
                                    textColor: AppColor.secondaryTextColor,
                                    textSize: 13.0,
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: new LabelTextField(
                                    alignment: Alignment.topRight,
                                    label:
                                        'Closing Price: ${singleItem.scriptPrice.toString()}',
                                    textColor: AppColor.secondaryTextColor,
                                    textSize: 13.0,
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

  getPledgedHolding() async {
    singleClient = globals.clientList[globals.codeIndex];
    Map<String, String> headerParam = {
      'Authorization': globals.accessToken,
    };
    await ApiService.getMethod(
      '${Constants.middleWareBaseUrl}/api/v1/position/${singleClient.clientCode}',
      context,
      headerParam: headerParam,
      isShowLoader: true,
    ).then((result) => {
          response = result,
          if (response.statusCode == 200)
            {
              setState(() {
                positionList = (json.decode(response.body) as List)
                    .map((i) => PositionModel.fromJson(i))
                    .toList();
              })
            }
        });
  }
}
