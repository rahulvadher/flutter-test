import 'dart:convert';

import 'package:backoffice/components/DefaultPlaceHolder.dart';
import 'package:backoffice/components/EditIPODialog.dart';
import 'package:backoffice/components/IconView.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Loader.dart';
import 'package:backoffice/components/OpenIPODialog.dart';
import 'package:backoffice/components/SubmitButton.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/model/MyBIDListDataModel.dart';
import 'package:backoffice/model/OpenBIDListDataModel.dart';
import 'package:backoffice/services/ApiService.dart';
import 'package:backoffice/services/Constants.dart';
import 'package:backoffice/services/Helpers.dart';
// import 'package:encrypt/encrypt.dart';
// import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../AppColor.dart';
import '../services/globals.dart' as globals;

class BIDListPage extends StatefulWidget {
  const BIDListPage({Key? key}) : super(key: key);
  State<StatefulWidget> createState() => BIDListPageState();
}

class BIDListPageState extends State<BIDListPage> {
  List<BIDContent> myBidList = [];
  MyBIDListDataModel myBIDListDataModel = new MyBIDListDataModel(content: []);
  Map<String, dynamic> dataMap = new Map<String, dynamic>();
  String cipherText = '';
  String initializeVector = '';
  Response response = new Response('body', 200);
  ClientListModel singleClient = new ClientListModel();
  int pageIndex = 0, rowIndex = -1;
  ScrollController scrollController = new ScrollController();
  List<OpenBIDContent> openBidList = [];
  OpenBIDListDataModel openBIDListDataModel =
      new OpenBIDListDataModel(content: []);
  OpenBIDContent openBIDContent = new OpenBIDContent();

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    singleClient = globals.clientList[globals.codeIndex];
    //encryptText(singleClient.clientCode.toString());
getMyBIDList();
    scrollController
      ..addListener(() {
        if (scrollController.offset >=
                scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          if (!(myBIDListDataModel.last ?? false)) {
            pageIndex++;
            getMyBIDList();
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: myBidList.isEmpty
          ? DefaultPlaceHolder()
          : Column(
              children: [

                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: myBidList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        BIDContent singleBIDItem = myBidList[index];
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    LabelTextField(
                                      label: singleBIDItem.symbol ?? "",
                                      fontFamily: 'Bold',
                                      textSize: 18.0,
                                    ),
                                    Wrap(
                                      children: [
                                        LabelTextField(
                                          label: 'QTY :- ',
                                          fontFamily: 'SemiBold',
                                        ),
                                        LabelTextField(
                                          label:
                                              singleBIDItem.quantity.toString(),
                                          textColor:
                                              AppColor.secondaryTextColor,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    LabelTextField(
                                      label: 'UPI :- ',
                                      fontFamily: 'SemiBold',
                                    ),
                                    LabelTextField(
                                      label: singleBIDItem.upi ?? '',
                                      textColor: AppColor.secondaryTextColor,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    LabelTextField(
                                      label: 'Bid Reference :- ',
                                      fontFamily: 'SemiBold',
                                    ),
                                    LabelTextField(
                                      label: singleBIDItem.bidReferenceNumber ??
                                          '',
                                      textColor: AppColor.secondaryTextColor,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    LabelTextField(
                                      label: 'Application Number :- ',
                                      fontFamily: 'SemiBold',
                                    ),
                                    LabelTextField(
                                      label:
                                          singleBIDItem.applicationNumber ?? '',
                                      textColor: AppColor.secondaryTextColor,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SubmitButton(
                                          onPressed: () {
                                            getOpenIPO(singleBIDItem);

                                          },
                                          fontFamily: 'SemiBold',
                                          label: 'Edit',
                                          backGroundColor:
                                              AppColor.primaryColor,
                                          textColor: AppColor.primaryTextColor,
                                        ),
                                        Expanded(
                                          flex: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              deleteBID(singleBIDItem, index);
                                            },
                                            child: Card(
                                              elevation: 5.0,
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0)),
                                              shadowColor:
                                                  AppColor.primaryColor,
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(5.0),
                                                child: IconView(
                                                  icon: Icons.delete,
                                                  size: 25.0,
                                                  color: AppColor.primaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    LabelTextField(
                                      label: singleBIDItem.timestamp.toString(),
                                      textColor: AppColor.secondaryTextColor,
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

  Future<void> getMyBIDList() async {
    singleClient = globals.clientList[globals.codeIndex];
    Map<String, String> headerParam = {
      'Api-Key': Constants.ipoAPIKey,
    };
    ApiService.getMethod(
            '${Constants.ipoUrl}api/v1/bid/?clientCode=${singleClient.clientCode}&status=success&sort=id,desc&page=$pageIndex',
            context,
            headerParam: headerParam)
        .then((value) => {
              response = value,
              if (response.statusCode == 200)
                {
                  setState(() {
                    dataMap = jsonDecode(response.body);
                    myBIDListDataModel =
                        MyBIDListDataModel.fromJson(jsonDecode(response.body));
                    if (pageIndex == 0)
                      myBidList = myBIDListDataModel.content;
                    else
                      myBidList.addAll(myBIDListDataModel.content);
                  })
                }
            });
  }

  Future<void> deleteBID(BIDContent singleBid, int index) async {
    Map<String, String> headerParam = {
      'Api-Key': Constants.ipoAPIKey,
    };
    print(
        '${Constants.ipoUrl}api/v1/bid/${singleBid.symbol}/${singleBid.applicationNumber}');
    ApiService.getDeleteMethod(
            '${Constants.ipoUrl}api/v1/bid/${singleBid.symbol}/${singleBid.applicationNumber}',
            context,
            headerParam: headerParam,
            isShowLoader: true)
        .then((value) => {
              response = value,
              if (response.statusCode == 200)
                {
                  setState(() {
                    dataMap = jsonDecode(response.body);

                    Helpers.showAlertDialog(dataMap['reason'], context)
                        .whenComplete(() => {
                              if (dataMap['success'] == 'success')
                                {
                                  //failed
                                  setState(() {
                                    myBidList.removeAt(index);
                                  })
                                }
                            });
                  })
                }
            });
  }

  Future<void> getOpenIPO(BIDContent mySingleBIDItem) async {
    Map<String, String> headerParam = {
      'Api-Key': Constants.ipoAPIKey,
    };
    ApiService.getMethod(
      '${Constants.ipoUrl}/api/v1/open/?sort=name,asc&page=$pageIndex',
      context,
      headerParam: headerParam,
    ).then((value) => {
          response = value,
          if (response.statusCode == 200)
            {
              dataMap = jsonDecode(response.body),
              if (mounted)
                setState(() {
                  openBIDListDataModel =
                      OpenBIDListDataModel.fromJson(jsonDecode(response.body));
                  if (pageIndex == 0)
                    openBidList = openBIDListDataModel.content;
                  else
                    openBidList.addAll(openBIDListDataModel.content);

                  openBIDContent = openBidList.firstWhere((element) => mySingleBIDItem.symbol == element.symbol);
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return EditIPODialog(
                        singleBIDItem: openBIDContent,mySingleBIDItem: mySingleBIDItem,
                      );
                    },
                  ).then((value) => {
                    if (value != null)
                      Helpers.showAlertDialog(
                          value, context).whenComplete(() => {
                            getMyBIDList()
                      })
                  });
                })
            }
        });
  }

 /* Future<void> encryptText(String plainText) async {
    final key = encrypt.Key.fromUtf8(Constants.key);
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = await encrypter.encrypt(plainText, iv: iv);
    setState(() {
      initializeVector = iv.base64;
      cipherText = encrypted.base64;
    });
    getMyBIDList();
  }*/
}
