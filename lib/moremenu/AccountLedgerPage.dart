import 'dart:convert';

import 'package:backoffice/components/BackNavigationButton.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Loader.dart';
import 'package:backoffice/components/Picker.dart';
import 'package:backoffice/components/SubmitButton.dart';
import 'package:backoffice/components/DropDown.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/model/LedgerModel.dart';
import 'package:backoffice/services/ApiService.dart';
import 'package:backoffice/services/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

import '../AppColor.dart';
import '../services/globals.dart' as globals;

class AccountLedgerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccountLedgerPageState();
}

class AccountLedgerPageState extends State<AccountLedgerPage> {
  ClientListModel singleClient = new ClientListModel();
  Response response = Response('', 200);
  List<LedgerModel> ledgerList = [];
  double balance = 0.0, closingBalance = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    singleClient = globals.clientList[globals.codeIndex];
    getLedger();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: BackNavigationButton(
                            label: 'Account Ledger',
                            isBackVisible: true,
                          ),
                        ),
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
                                        getLedger();
                                      }),
                                    }
                                });
                          },
                          child: Picker(singleClient.clientCode ?? ''),
                        ),
                      ],
                    ),
                  ),
                 Expanded(
                   child: ledgerList.isEmpty?Loader(): Expanded(
                      child: SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                              width: MediaQuery.of(context).size.width * 2,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          child: LabelTextField(
                                            label: 'Fin. Date',
                                            fontFamily: 'Bold',
                                            textSize: 16.0,
                                          ),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: LabelTextField(
                                            label: 'Naration',
                                            fontFamily: 'Bold',
                                            textSize: 16.0,
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: LabelTextField(
                                            label: 'Bill/Chq No',
                                            fontFamily: 'Bold',
                                            textSize: 16.0,
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: LabelTextField(
                                            label: 'Trx.Dt/Chq',
                                            fontFamily: 'Bold',
                                            textSize: 16.0,
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: LabelTextField(
                                            alignment: Alignment.topRight,
                                            label: 'Debit',
                                            fontFamily: 'Bold',
                                            textSize: 16.0,
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: LabelTextField(
                                            alignment: Alignment.topRight,
                                            label: 'Credit',
                                            fontFamily: 'Bold',
                                            textSize: 16.0,
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: LabelTextField(
                                            alignment: Alignment.topRight,
                                            label: 'Balance',
                                            fontFamily: 'Bold',
                                            textSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: new ListView.builder(
                                        padding: EdgeInsets.zero,
                                        primary: false,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: ledgerList.length,
                                        itemBuilder: (context, index) {
                                          LedgerModel singleItem =
                                              ledgerList[index];
                                          if (index == 0) {
                                            balance = (singleItem.credit! -
                                                singleItem.debit!);
                                          } else {
                                            var previousBalance = balance;
                                            var balance2 = (singleItem.credit! -
                                                singleItem.debit!);
                                            balance = balance2 + previousBalance;
                                          }
                                          return Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    color: index % 2 == 0
                                                        ? AppColor.primaryColor
                                                            .withOpacity(0.30)
                                                        : AppColor
                                                            .primaryTextColor,
                                                    spreadRadius: 0,
                                                    blurRadius: 0),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  flex: 1,
                                                  child: LabelTextField(
                                                    label: singleItem.voucherDate
                                                        .toString(),
                                                    textColor: AppColor
                                                        .secondaryTextColor,
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 2,
                                                  child: LabelTextField(
                                                    label: singleItem.naration
                                                        .toString(),
                                                    textColor: AppColor
                                                        .secondaryTextColor,
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: LabelTextField(
                                                    label: singleItem.billNo
                                                        .toString(),
                                                    textColor: AppColor
                                                        .secondaryTextColor,
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: LabelTextField(
                                                    label: singleItem
                                                        .effectiveDate
                                                        .toString(),
                                                    textColor: AppColor
                                                        .secondaryTextColor,
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: LabelTextField(
                                                    alignment: Alignment.topRight,
                                                    label: singleItem.debit
                                                        .toString(),
                                                    textColor: AppColor
                                                        .secondaryTextColor,
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: LabelTextField(
                                                    alignment: Alignment.topRight,
                                                    label: singleItem.credit
                                                        .toString(),
                                                    textColor: AppColor
                                                        .secondaryTextColor,
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: LabelTextField(
                                                    alignment: Alignment.topRight,
                                                    label:
                                                        '${balance.toStringAsFixed(2)}',
                                                    textColor: AppColor
                                                        .secondaryTextColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                 ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: SubmitButton(
                        onPressed: () {},
                        label:
                            'Closing Balance Rs. ${closingBalance.toStringAsFixed(2)}',
                        fontFamily: 'SemiBold',
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  getLedger() async {
    Map<String, String> headerParam = {
      'Authorization': globals.accessToken,
    };
    await ApiService.getMethod(
      '${Constants.middleWareBaseUrl}/api/v1/client/ledger/${singleClient.clientCode}',
      context,
      headerParam: headerParam,
    ).then((result) => {
          response = result,
          if (response.statusCode == 200)
            {
              setState(() {
                ledgerList = (json.decode(response.body) as List)
                    .map((i) => LedgerModel.fromJson(i))
                    .toList();

                for (int i = 0; i < ledgerList.length; i++) {
                  LedgerModel singleItem = ledgerList[i];
                  if (i == 0) {
                    closingBalance = (singleItem.credit! - singleItem.debit!);
                  } else {
                    var previousBalance = closingBalance;
                    var balance2 = (singleItem.credit! - singleItem.debit!);
                    closingBalance = balance2 + previousBalance;
                    setState(() {});
                  }
                }
              })
            }
        });
  }
}
