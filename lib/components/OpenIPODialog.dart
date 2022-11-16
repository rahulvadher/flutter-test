import 'dart:convert';

import 'package:backoffice/components/DropDown.dart';
import 'package:backoffice/components/IPOCategoryDropDown.dart';
import 'package:backoffice/components/IconView.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Picker.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/model/OpenBIDListDataModel.dart';
import 'package:backoffice/services/ApiService.dart';
import 'package:backoffice/services/Constants.dart';
import 'package:backoffice/services/Helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart';
import '../AppColor.dart';
import '../services/globals.dart' as globals;
import 'InputTextField.dart';
import 'SubmitButton.dart';
import 'DropDown.dart';

class OpenIPODialog extends StatefulWidget {
  final OpenBIDContent singleBIDItem;

  OpenIPODialog({key, required this.singleBIDItem}) : super(key: key);

  State<StatefulWidget> createState() => OpenIPODialogState();
}

class OpenIPODialogState extends State<OpenIPODialog> {
  TextEditingController upiController = TextEditingController();
  bool chbTerm = false;
  int totalBID = 1;
  int bidQty = 0, minBidQty = 0;
  double totalValue = 0.0;
  double cutOff = 0.0;
  RegExp regExp = new RegExp(
    Constants.UPIdPattern,
    caseSensitive: false,
    multiLine: false,
  );
  ClientListModel singleClient = new ClientListModel();
  String cipherText = '';
  String initializeVector = '';
  Response response = new Response('body', 200);
  Map<String, dynamic> dataMap = new Map<String, dynamic>();
  Category category = new Category();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bidQty = widget.singleBIDItem.minBidQuantity!;
    minBidQty = widget.singleBIDItem.minBidQuantity!;
    cutOff = widget.singleBIDItem.cutOffPrice!;
    //bidupiController.text = widget.singleBIDItem.minbidqty!;

    singleClient = globals.clientList[globals.codeIndex];
    //encryptText(singleClient.clientCode.toString());

    final index = widget.singleBIDItem.category!
        .indexWhere((element) => element.code == 'IND');
    if (index >= 0) {
      globals.categoryIndex = index;
      category = widget.singleBIDItem.category![index];
    }
    totalValue = bidQty.toDouble() * (widget.singleBIDItem.cutOffPrice!-category.discount!.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Card(
            margin: EdgeInsets.symmetric(horizontal: 30.0),
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            shadowColor: AppColor.primaryColor,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: LabelTextField(
                      alignment: Alignment.center,
                      textAlign: TextAlign.center,
                      label:
                          'Apply For ${widget.singleBIDItem.symbol.toString()}',
                      fontFamily: 'Bold',
                      textSize: 20.0,

                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LabelTextField(
                        alignment: Alignment.center,
                        textAlign: TextAlign.center,
                        label: 'Client Code :- ',
                        fontFamily: 'Bold',
                        textSize: 16.0,
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
                                      encryptText(
                                          singleClient.clientCode.toString());
                                    }),
                                  }
                              });
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Picker(singleClient.clientCode ?? ''),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LabelTextField(
                        alignment: Alignment.center,
                        textAlign: TextAlign.center,
                        label: 'Category :- ',
                        fontFamily: 'Bold',
                        textSize: 16.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return IPOCategoryDropDown(
                                    pickerData: widget.singleBIDItem.category);
                              }).then((value) => {
                                if (value != null)
                                  {
                                    setState(() {
                                      category = value;
                                    }),
                                  }
                              });
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Picker(category.code ?? ''),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                LabelTextField(
                                  label: 'Offer Price :- ',
                                  fontFamily: 'SemiBold',
                                ),
                                LabelTextField(
                                  label: cutOff.toString(),
                                  textColor: AppColor.primaryHintColor,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                LabelTextField(
                                  label: 'Discount :- ',
                                  fontFamily: 'SemiBold',
                                ),
                                LabelTextField(
                                  label: '${category.discount ?? 0.0}',
                                  textColor: AppColor.primaryHintColor,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                LabelTextField(
                                  label: 'BID Qty :- ',
                                  fontFamily: 'SemiBold',
                                ),
                                LabelTextField(
                                  label: bidQty.toString(),
                                  textColor: AppColor.primaryHintColor,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                LabelTextField(
                                  label: 'BID Value :- ',
                                  fontFamily: 'SemiBold',
                                ),
                                LabelTextField(
                                  label: totalValue.toString(),
                                  textColor: AppColor.primaryHintColor,
                                )
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (totalValue != 0 &&
                                      minBidQty != 0 &&
                                      cutOff != 0) {
                                    if (totalValue <
                                        (200000 - minBidQty * cutOff)) {
                                      totalBID++;
                                      bidQty = bidQty +
                                          widget.singleBIDItem.minBidQuantity!;
                                      totalValue = bidQty.toDouble() *
                                          widget.singleBIDItem.cutOffPrice!;
                                      setState(() {});
                                    }
                                  }
                                });
                              },
                              child: Container(
                                width: 35.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: AppColor.primaryColor,
                                        spreadRadius: 0,
                                        blurRadius: 0),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: IconView(
                                    size: 22.0,
                                    icon: Icons.add,
                                    color: AppColor.primaryTextColor,
                                  ),
                                ),
                              ),
                            ),
                            LabelTextField(
                              label: '${totalBID}x',
                              fontFamily: 'Bold',
                              textSize: 20.0,
                              textColor: AppColor.secondaryTextColor,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (minBidQty != 0 && cutOff != 0) {
                                    if (bidQty > minBidQty) {
                                      if (totalBID > 1) totalBID--;
                                      bidQty = bidQty -
                                          widget.singleBIDItem.minBidQuantity!;
                                      totalValue = bidQty.toDouble() *
                                          widget.singleBIDItem.cutOffPrice!;
                                      setState(() {});
                                    }
                                  }
                                });
                              },
                              child: Container(
                                width: 35.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15.0),
                                    bottomRight: Radius.circular(15.0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: AppColor.primaryColor,
                                        spreadRadius: 0,
                                        blurRadius: 0),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: IconView(
                                    size: 22.0,
                                    icon: Icons.remove,
                                    color: AppColor.primaryTextColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  InputTextField(
                    onChanged: (text) {
                      upiController.selection = TextSelection.fromPosition(
                        TextPosition(offset: upiController.text.length),
                      );
                    },
                    labelText: 'Enter your UPI',
                    textFieldController: upiController,
                    icon: IconView(
                      icon: Icons.smartphone,
                      size: 20,
                      color: AppColor.primaryHintColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        Checkbox(
                          activeColor: AppColor.primaryColor,
                          checkColor: AppColor.primaryTextColor,
                          value: chbTerm,
                          onChanged: (bool? value) {
                            setState(() {
                              chbTerm = value!;
                            });
                          },
                        ),
                        Flexible(
                          child: LabelTextField(
                            onPressed: () {},
                            label:
                                'Yes, I agree and request PWAPL terms to apply for ${widget.singleBIDItem.name} IPO for me, against my UPI id/Trading Code. I have read and understood terms & conditions.',
                            textColor: AppColor.primaryHintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: SubmitButton(
                        label: 'Apply Now',
                        onPressed: () {
                          if (upiController.text.isEmpty) {
                            Helpers.showAlertDialog('Enter UPI', context);
                          }
                          /* else if (!regExp.hasMatch(upiController.text)) {
                            Helpers.showAlertDialog(
                                "Enter valid UPID", context);
                          }*/

                          else if (!chbTerm) {
                            Helpers.showAlertDialog(
                                "Check terms and conditions", context);
                          } else {
                            newBID();
                          }
                        },
                        fontFamily: 'SemiBold',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Card(
              margin: EdgeInsets.only(top: 15.0),
              elevation: 5.0,
              shadowColor: AppColor.primaryTextColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Container(
                width: 40.0,
                height: 40.0,
                child: IconView(icon: Icons.clear),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> newBID() async {
    Map<String, dynamic> bodyParam = {
      'symbol': widget.singleBIDItem.symbol,
      'category': category.code,
      'clientCode': singleClient.clientCode,
      'upi': upiController.text,
      'quantity': bidQty,
      'price': cutOff,
      'amount': totalValue,
      'discount': category.discount,
    };
    print('newBId ${jsonEncode(bodyParam)}');

    Map<String, String> headerParam = {
      'Content-Type': 'application/json',
      'Api-Key': Constants.ipoAPIKey,
    };

    ApiService.postMethod('${Constants.ipoUrl}api/v1/bid/', context,
            headerParam: headerParam, bodyParam: jsonEncode(bodyParam),isShowLoader: true)
        .then((value) => {
              //  Navigator.pop(context, "BID Success")
              {
                response = value,
                if (response.statusCode == 200)
                  {
                    setState(() {
                      dataMap = jsonDecode(response.body);
                      Navigator.pop(context, dataMap['reason']);
                    })
                  }
              }
            });
  }

  Future<void> submitBID() async {
    var cipherParam = {
      'encClientcode': 'yes',
      'iv': initializeVector,
      'ciphertext': cipherText
    };
    var serialParam = {'serial': '1234'};
    var valueParam = {
      'vpa': upiController.text,
      'symbol': ' widget.singleBIDItem.symbol',
      'qty1': bidQty.toString(),
      'price1': cutOff.toString()
    };
    var bodyParam = [
      cipherParam,
      serialParam,
      valueParam,
    ];

    Map<String, String> headerParam = {
      'Authorization': 'Bearer bd595e8cac56b2f6a3696e41fcb858354bbc4695',
      'Content-Type': 'application/json'
    };
/*    ApiService.postMethod('${Constants.meonBaseUrl}/bidsubmit',
            headerParam: headerParam, bodyParam: bodyParam).then((value) => {
              dataMap = value,
              openBidList = OpenBIDListModel.fromJson(dataMap).data,
              setState(() {})
            });*/

    ApiService.postMethod('${Constants.meonBaseUrl}/bidsubmit', context,
            headerParam: headerParam, bodyParam: jsonEncode(bodyParam))
        .then((value) => Navigator.pop(context, "BID Success"));
  }

  void encryptText(String plainText) {
    final key = encrypt.Key.fromUtf8(Constants.key);
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    initializeVector = iv.base64;
    cipherText = encrypted.base64;
    setState(() {});
    print(encrypted.base64);
    print(iv.base64);
    print(encrypter.decrypt(encrypted, iv: iv));
  }
}
