
import 'package:backoffice/AppColor.dart';
import 'package:backoffice/components/BackNavigationButton.dart';
import 'package:backoffice/components/DropDown.dart';
import 'package:backoffice/components/FundDialog.dart';
import 'package:backoffice/components/IconView.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Picker.dart';
import 'package:backoffice/components/SubmitButton.dart';
import 'package:backoffice/components/WithdrawFundDialog.dart';
import 'package:backoffice/model/BankListModel.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/model/LedgerStockValueModel.dart';
import 'package:backoffice/moremenu/AccountLedgerPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

import '../services/globals.dart' as globals;

class FundsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FundsPageState();
}

class FundsPageState extends State<FundsPage> {

  ClientListModel singleClient = new ClientListModel();
  Response response = Response('', 200);
  List<BankListModel> bankList = [];
  LedgerStockValueModel singleValue = new LedgerStockValueModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    singleClient = globals.clientList[globals.codeIndex];
    singleValue=globals.singleValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: BackNavigationButton(
                          label: 'Funds',
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
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  elevation: 5.0,
                  shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  shadowColor: AppColor.primaryTextColor,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            LabelTextField(
                              onPressed: () {},
                              label: 'Your total balance is ',
                              textSize: 16.0,
                            ),
                            LabelTextField(
                              onPressed: () {},
                              label: '₹ ${ singleValue.ledger?.balance
                                  .toString() ??
                                  '0.0'}',
                              textSize: 18.0,
                              fontFamily: 'SemiBold',
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => AccountLedgerPage()),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              children: [
                                LabelTextField(
                                  label: 'View statement',
                                  textSize: 16.0,
                                ),
                                IconView(
                                  icon: Icons.chevron_right,
                                  size: 35.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: SubmitButton(
                                  backGroundColor: AppColor.primaryGreenColor,
                                  borderWidth: 0.0,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return FundDialog();
                                      },
                                    );
                                  },
                                  shadowColors: AppColor.primaryGreenColor,
                                  label: 'Add Funds',
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: SubmitButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return WithdrawFundDialog();
                                      },
                                    );
                                  },
                                  label: 'Withdraw',
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
