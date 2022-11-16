import 'dart:convert';

import 'package:backoffice/components/BackNavigationButton.dart';
import 'package:backoffice/components/IconView.dart';
import 'package:backoffice/components/InputTextField.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Loader.dart';
import 'package:backoffice/components/SubmitButton.dart';
import 'package:backoffice/model/ClientListBSModel.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/services/ApiService.dart';
import 'package:backoffice/services/Constants.dart';
import 'package:backoffice/services/Helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

import '../AppColor.dart';
import '../services/globals.dart' as globals;

class ClientListPage extends StatefulWidget {
  State<StatefulWidget> createState() => ClientListPageState();
}

class ClientListPageState extends State<ClientListPage> {
  List<ClientListModel> clientList = [];
  Response response = Response('', 200);
  ClientListModel singleClient = new ClientListModel();
  Map<String, dynamic> dataMap = new Map<String, dynamic>();
  ClientListBSModel clientListBSModel = new ClientListBSModel(content: []);
  int pageIndex = 0;
  ScrollController scrollController = new ScrollController();
  TextEditingController searchController = TextEditingController();
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    singleClient = globals.clientList[globals.codeIndex];
    getClientList();
    scrollController
      ..addListener(() {
        if (scrollController.offset >=
            scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          if (!(clientListBSModel.last ?? false)) {
            pageIndex++;
            getClientList();
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

  getClientList() async {
    Map<String, String> headerParam = {
      'Authorization': globals.accessToken,
    };
    await ApiService.getMethod(
      '${Constants.middleWareBaseUrl}/api/v1/branch/${globals.singleBranch.branchCode}/client?page=$pageIndex&search=${searchController.text}',
      context,
      headerParam: headerParam,
    ).then((result) => {
          response = result,
          if (response.statusCode == 200) dataMap = jsonDecode(response.body),
          {
            setState(() {
              clientListBSModel =
                  ClientListBSModel.fromJson(jsonDecode(response.body));
              clientList.addAll(clientListBSModel.content);
              clientList.sort(
                  (a, b) => a.name.toString().compareTo(b.name.toString()));
            })
          }
        });
  }

  onSearchTextChanged(String text) async {
    setState(() {
      pageIndex = 0;
      clientList.clear();
      print('$text');
    });
    if (text.isNotEmpty) getClientList();
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
                label: 'Client',
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
                  child: clientList.isEmpty
                      ? Loader()
                      : ListView.builder(
                          primary: false,
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: clientList.length,
                          itemBuilder: (context, index) {
                            ClientListModel singleClient = clientList[index];
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
                                          label: singleClient.name.toString(),
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
                                                label: singleClient.clientCode
                                                    .toString(),
                                                textColor:
                                                    AppColor.secondaryTextColor,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Helpers.launchURL(
                                                      'tel:${singleClient.mobileNo.toString()}');
                                                },
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.0),
                                                      child: LabelTextField(
                                                        label: singleClient
                                                            .mobileNo
                                                            .toString(),
                                                        textColor: AppColor
                                                            .secondaryTextColor,
                                                      ),
                                                    ),
                                                    IconView(
                                                      icon: Icons.phone,
                                                      size: 20,
                                                      color: AppColor
                                                          .primaryHintColor,
                                                    ),
                                                  ],
                                                ),
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
                  label: 'Total Clients : ${clientListBSModel.totalElements}',
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
