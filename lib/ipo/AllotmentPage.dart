import 'dart:convert';

import 'package:backoffice/components/DefaultPlaceHolder.dart';
import 'package:backoffice/components/IconView.dart';
import 'package:backoffice/components/InputTextField.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/model/AllotmentModel.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/model/OpenBIDListDataModel.dart';
import 'package:backoffice/services/ApiService.dart';
import 'package:backoffice/services/Constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../AppColor.dart';
import '../services/globals.dart' as globals;

class AllotmentPage extends StatefulWidget {
  State<StatefulWidget> createState() => AllotmentPageState();
}

class AllotmentPageState extends State<AllotmentPage> {
  List<OpenBIDListDataModel> openBidList = [];
  Map<String, dynamic> dataMap = new Map<String, dynamic>();
  String cipherText = '';
  String initializeVector = '';
  Response response = new Response('body', 200);
  ClientListModel singleClient = new ClientListModel();
  int pageIndex = 0;
  ScrollController scrollController = new ScrollController();
  List<AllotmentContent> allotmentList = [];
  List<AllotmentContent> searchAllotmentList = [];
  AllotmentModel allotmentModel = new AllotmentModel(content: []);
  TextEditingController searchController = TextEditingController();

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    singleClient = globals.clientList[globals.codeIndex];
    getAllotment();
  }

  onSearchTextChanged(String text) async {
    if (text.isNotEmpty) {
      getSearchAllotment(text);
    } else {
      setState(() {
        getAllotment();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: allotmentList.isEmpty
          ? DefaultPlaceHolder()
          : Column(
              children: [
                if (globals.singleBranch.branchCode != null)
                new Container(
                  child: new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: InputTextField(
                      labelText: 'Search',
                      textFieldController: searchController,
                      radius: 10.0,
                      icon: IconView(
                        icon: Icons.search,
                        size: 20,
                        color: AppColor.primaryHintColor,
                      ),
                      onChanged: (text) {
                        onSearchTextChanged(text);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: allotmentList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        AllotmentContent singleItem = allotmentList[index];
                        return new Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5.0,
                          shadowColor: AppColor.primaryTextColor,
                          child: new Padding(
                            padding: new EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                LabelTextField(
                                  label: singleItem.script ?? "",
                                  fontFamily: 'Bold',
                                  textSize: 18.0,
                                ),
                                LabelTextField(
                                  label: singleItem.name ?? "",
                                  fontFamily: 'SemiBold',
                                ),
                                Row(
                                  children: [
                                    LabelTextField(
                                      label: 'Account Status :- ',
                                      fontFamily: 'SemiBold',
                                    ),
                                    LabelTextField(
                                      label: singleItem.accountStatus.toString(),
                                      textColor:
                                      AppColor.secondaryTextColor,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        LabelTextField(
                                          label: 'Code :- ',
                                          fontFamily: 'SemiBold',
                                        ),
                                        LabelTextField(
                                          label:
                                              singleItem.clientCode.toString(),
                                          textColor:
                                              AppColor.secondaryTextColor,
                                          textAlign: TextAlign.start,
                                          alignment: Alignment.topRight,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        LabelTextField(
                                          label: 'CL ID :- ',
                                          fontFamily: 'SemiBold',
                                        ),
                                        LabelTextField(
                                          label: singleItem.dpId.toString(),
                                          textColor:
                                              AppColor.secondaryTextColor,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        LabelTextField(
                                          label: 'QTY :- ',
                                          fontFamily: 'SemiBold',
                                        ),
                                        LabelTextField(
                                          label: singleItem.qty.toString(),
                                          textColor:
                                              AppColor.secondaryTextColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Future<void> getAllotment() async {
    Map<String, String> headerParam = {
      'Api-Key': Constants.ipoAPIKey,
    };
    String endPoint = 'mobileNumber=${singleClient.mobileNo}';
    if (globals.singleBranch.branchCode != null) {
      endPoint = 'branch=${globals.singleBranch.branchCode}';
    }
    ApiService.getMethod(
            '${Constants.ipoUrl}api/v1/allotment/?$endPoint&sort=script,clientCode,asc&page=$pageIndex',
            context,
            headerParam: headerParam)
        .then((value) => {
              response = value,
              if (response.statusCode == 200)
                {
                  setState(() {
                    dataMap = jsonDecode(response.body);
                    allotmentModel =
                        AllotmentModel.fromJson(jsonDecode(response.body));
                    if (pageIndex == 0)
                      allotmentList = allotmentModel.content;
                    else
                      allotmentList.addAll(allotmentModel.content);
                  })
                }
            });
  }

  Future<void> getSearchAllotment(String text) async {
    Map<String, String> headerParam = {
      'Api-Key': Constants.ipoAPIKey,
    };
    ApiService.getMethod(
            '${Constants.ipoUrl}api/v1/allotment/?branch=${globals.singleBranch.branchCode}&sort=script,clientCode,asc&search=$text&page=$pageIndex',
            context,
            headerParam: headerParam)
        .then((value) => {
              response = value,
              if (response.statusCode == 200)
                {
                  setState(() {
                    dataMap = jsonDecode(response.body);
                    allotmentModel =
                        AllotmentModel.fromJson(jsonDecode(response.body));
                    if (pageIndex == 0)
                      searchAllotmentList = allotmentModel.content;
                    else
                      searchAllotmentList.addAll(allotmentModel.content);
                    if (searchAllotmentList.length != 0) {
                      allotmentList = searchAllotmentList;
                    }
                  })
                }
            });
  }
}
