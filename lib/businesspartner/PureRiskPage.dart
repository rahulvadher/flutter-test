import 'dart:convert';

import 'package:backoffice/components/BackNavigationButton.dart';
import 'package:backoffice/components/IconView.dart';
import 'package:backoffice/components/InputTextField.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Loader.dart';
import 'package:backoffice/components/SubmitButton.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/model/PureRiskItemModel.dart';
import 'package:backoffice/model/PureRiskModel.dart';
import 'package:backoffice/services/ApiService.dart';
import 'package:backoffice/services/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

import '../AppColor.dart';
import '../services/globals.dart' as globals;

class PureRiskPage extends StatefulWidget {
  State<StatefulWidget> createState() => PureRiskPageState();
}

class PureRiskPageState extends State<PureRiskPage> {
  List<PureRiskItemModel> pureRiskList = [];
  PureRiskModel pureRiskModel = new PureRiskModel(content: []);
  double totalPureRisk = 0.0;
  Response response = Response('', 200);
  Map<String, dynamic> dataMap = new Map<String, dynamic>();
  ClientListModel singleClient = new ClientListModel();
  int pageIndex = 0;
  ScrollController scrollController = new ScrollController();
  TextEditingController searchController = TextEditingController();

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    singleClient = globals.clientList[globals.codeIndex];
    getPureRisk();
    scrollController
      ..addListener(() {
        if (scrollController.offset >=
                scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          if (!(pureRiskModel.last ?? false)) {
            pageIndex++;
            getPureRisk();
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

  getPureRisk() async {
    Map<String, String> headerParam = {
      'Authorization': globals.accessToken,
    };
    await ApiService.getMethod(
      '${Constants.middleWareBaseUrl}/api/v1/branch/${globals.singleBranch.branchCode}/purerisk?page=$pageIndex&search=${searchController.text}',
      context,
      headerParam: headerParam,
    ).then((result) => {
          response = result,
          if (response.statusCode == 200) dataMap = jsonDecode(response.body),
          {
            setState(() {
              pureRiskModel = PureRiskModel.fromJson(jsonDecode(response.body));
              pureRiskList.addAll(
                  pureRiskModel.content.where((i) => i.pureRisk! > 0).toList());
              pureRiskList.sort((a, b) =>
                  a.clientName.toString().compareTo(b.clientName.toString()));
              totalPureRisk = pureRiskList
                  .map((expense) => expense.pureRisk)
                  .fold(0,
                      (prev, amount) => prev + double.parse(amount.toString()));
            })
          }
        });
  }

  onSearchTextChanged(String text) async {
    setState(() {
      pageIndex = 0;
      pureRiskList.clear();
      print('$text');
    });
    if (text.isNotEmpty) getPureRisk();
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
                label: 'Pure Risk',
                isBackVisible: true,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: InputTextField(
                  onChanged: (text) {
                    searchController.selection = TextSelection.fromPosition(
                      TextPosition(offset: searchController.text.length),
                    );
                    onSearchTextChanged(text);
                  },
                  labelText: 'Search',
                  textFieldController: searchController,
                  icon: IconView(
                    icon: Icons.search,
                    size: 20,
                    color: AppColor.primaryHintColor,
                  ),
                ),
              ),
              Expanded(
                  child: pureRiskList.isEmpty
                      ? Loader()
                      : ListView.builder(
                          primary: false,
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: pureRiskList.length,
                          itemBuilder: (context, index) {
                            PureRiskItemModel pureRiskItem =
                                pureRiskList[index];
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        LabelTextField(
                                          label: pureRiskItem.clientName
                                              .toString(),
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
                                                label: pureRiskItem.clientCode
                                                    .toString(),
                                                textColor:
                                                    AppColor.secondaryTextColor,
                                              ),
                                              LabelTextField(
                                                label: pureRiskItem.pureRisk
                                                    .toString(),
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
                  label: 'Total Risk ₹ ${totalPureRisk.toStringAsFixed(2)}',
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
