import 'dart:convert';

import 'package:backoffice/AppColor.dart';
import 'package:backoffice/components/BackNavigationButton.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Loader.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/model/PCRModel.dart';
import 'package:backoffice/services/ApiService.dart';
import 'package:backoffice/services/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

import '../services/globals.dart' as globals;

class PCRReportPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PCRReportPageState();
}

class PCRReportPageState extends State<PCRReportPage> {
  ClientListModel singleClient = new ClientListModel();
  Response response = Response('', 200);
  List<PCRModel> pcrList = [];
  double balance = 0.0, closingBalance = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    singleClient = globals.clientList[globals.codeIndex];
    getMarginList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: pcrList.isEmpty
            ? Loader()
            : Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: BackNavigationButton(
                label: 'PCR Report',
                isBackVisible: true,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 5,
                      child: Wrap(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: LabelTextField(
                                    label: 'BranchID',
                                    fontFamily: 'Bold',
                                    textSize: 16.0,
                                    alignment: Alignment.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: LabelTextField(
                                    label: 'Client Cd',
                                    fontFamily: 'Bold',
                                    textSize: 16.0,
                                    alignment: Alignment.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: LabelTextField(
                                    label: 'Client Name',
                                    fontFamily: 'Bold',
                                    textSize: 16.0,
                                    alignment: Alignment.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: LabelTextField(
                                    label: 'Cash FO Ledger',
                                    fontFamily: 'Bold',
                                    textSize: 16.0,
                                    alignment: Alignment.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: LabelTextField(
                                    label: 'CDS Ledger',
                                    fontFamily: 'Bold',
                                    textSize: 16.0,
                                    alignment: Alignment.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: LabelTextField(
                                    label: 'Ledger Balance',
                                    fontFamily: 'Bold',
                                    textSize: 16.0,
                                    alignment: Alignment.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: LabelTextField(
                                    label: 'BENDEMAT Stock',
                                    fontFamily: 'Bold',
                                    textSize: 16.0,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: LabelTextField(
                                    label: 'DPPOA Stock',
                                    fontFamily: 'Bold',
                                    textSize: 16.0,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: LabelTextField(
                                    label: 'DP BEN Stock Ahc',
                                    fontFamily: 'Bold',
                                    textSize: 16.0,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: LabelTextField(
                                    label: 'Margin Stock',
                                    fontFamily: 'Bold',
                                    textSize: 16.0,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: LabelTextField(
                                    label: 'FO Margin',
                                    fontFamily: 'Bold',
                                    textSize: 16.0,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: LabelTextField(
                                    label: 'CDS Margin',
                                    fontFamily: 'Bold',
                                    textSize: 16.0,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: LabelTextField(
                                    label: 'Total Margin',
                                    fontFamily: 'Bold',
                                    textSize: 16.0,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: LabelTextField(
                                    label: 'Net Balance',
                                    fontFamily: 'Bold',
                                    textSize: 16.0,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: LabelTextField(
                                    label: 'Net Balance 2',
                                    fontFamily: 'Bold',
                                    textSize: 16.0,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: LabelTextField(
                                    label: 'Unreal Voucher',
                                    fontFamily: 'Bold',
                                    textSize: 16.0,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: LabelTextField(
                                    label: 'Debit Days',
                                    fontFamily: 'Bold',
                                    textSize: 16.0,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: LabelTextField(
                                    label: 'T5 Debit',
                                    fontFamily: 'Bold',
                                    textSize: 16.0,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: LabelTextField(
                                    label: 'Pure Risk',
                                    fontFamily: 'Bold',
                                    textSize: 16.0,
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: pcrList.length,
                              itemBuilder: (context, index) {
                                PCRModel singleItem = pcrList[index];
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: index % 2 == 0
                                              ? AppColor.primaryColor
                                              .withOpacity(0.30)
                                              : AppColor.primaryTextColor,
                                          spreadRadius: 0,
                                          blurRadius: 0),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: LabelTextField(
                                          label: singleItem.branchCode
                                              .toString(),
                                          textColor:
                                          AppColor.secondaryTextColor,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: LabelTextField(
                                          label: singleItem.clientCode
                                              .toString(),
                                          textColor:
                                          AppColor.secondaryTextColor,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: LabelTextField(
                                          label: singleItem.clientName
                                              .toString(),
                                          textColor:
                                          AppColor.secondaryTextColor,
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: LabelTextField(
                                          label: double.parse(singleItem.cashFOLedger).toStringAsFixed(2),
                                          textColor:
                                          AppColor.secondaryTextColor,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: LabelTextField(
                                          label: singleItem.cdsLedger
                                              .toString(),
                                          textColor:
                                          AppColor.secondaryTextColor,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: LabelTextField(
                                          label: 'total Ledger',
                                          textColor:
                                          AppColor.secondaryTextColor,
                                          alignment: Alignment.topRight,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: LabelTextField(
                                          label: singleItem.BENDEMAT_STOCK
                                              .toString(),
                                          textColor:
                                          AppColor.secondaryTextColor,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: LabelTextField(
                                          label: singleItem.DPPOA_STOCK
                                              .toString(),
                                          textColor:
                                          AppColor.secondaryTextColor,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: LabelTextField(
                                          label: singleItem.DP_BEN_STOCK_AHC
                                              .toString(),
                                          textColor:
                                          AppColor.secondaryTextColor,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: LabelTextField(
                                          label: singleItem.marginStock
                                              .toString(),
                                          textColor:
                                          AppColor.secondaryTextColor,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: LabelTextField(
                                          label: singleItem.foMargin
                                              .toString(),
                                          textColor:
                                          AppColor.secondaryTextColor,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: LabelTextField(
                                          label: singleItem.cdsMargin
                                              .toString(),
                                          textColor:
                                          AppColor.secondaryTextColor,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: LabelTextField(
                                          label: singleItem.totalMGN
                                              .toString(),
                                          textColor:
                                          AppColor.secondaryTextColor,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: LabelTextField(
                                          label: singleItem.netBalance
                                              .toString(),
                                          textColor:
                                          AppColor.secondaryTextColor,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: LabelTextField(
                                          label: singleItem.netBalance2
                                              .toString(),
                                          textColor:
                                          AppColor.secondaryTextColor,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: LabelTextField(
                                          label: singleItem.unrealVoucher
                                              .toString(),
                                          textColor:
                                          AppColor.secondaryTextColor,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: LabelTextField(
                                          label:
                                          singleItem.debitDays.toString(),
                                          textColor:
                                          AppColor.secondaryTextColor,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: LabelTextField(
                                          label: singleItem.t5Debit
                                              .toString(),
                                          textColor:
                                          AppColor.secondaryTextColor,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: LabelTextField(
                                          label: singleItem.pureRisk
                                              .toString(),
                                          textColor:
                                          AppColor.secondaryTextColor,
                                          alignment: Alignment.centerRight,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  getMarginList() async {
    await ApiService.getMethod(
            '${Constants.capexBaseUrl}/cap_getclient?Requesttype=PCR&userid=${globals.singleBranch.branchCode}&datefrom=25APR2021',
            context)
        .then((value) => {
              response = value,
              if (response.statusCode == 200)
                {
                  setState(() {
                    pcrList = (json.decode(response.body) as List)
                        .map((i) => PCRModel.fromJson(i))
                        .toList();
                    pcrList.sort((a, b) => a.clientCode.compareTo(b.clientCode));
                  })
                }
            });

    setState(() {});
  }
}
