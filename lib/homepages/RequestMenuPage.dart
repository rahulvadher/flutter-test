import 'package:backoffice/components/DropDown.dart';
import 'package:backoffice/components/IconView.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Picker.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/requeste/AccountStatementPage.dart';
import 'package:backoffice/requeste/ContractBillPage.dart';
import 'package:backoffice/requeste/DematClientMasterPage.dart';
import 'package:backoffice/requeste/DematHoldingTransactionStatementPage.dart';
import 'package:backoffice/requeste/PLStatementPage.dart';
import 'package:backoffice/requeste/PasswordResetPage.dart';
import 'package:backoffice/requeste/ProfileChangePage.dart';
import 'package:backoffice/requeste/TradingActivationPage.dart';
import 'package:backoffice/requeste/TradingDeactivationPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AppColor.dart';
import '../services/globals.dart' as globals;

class RequestMenuPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RequestMenuPageState();
}

class RequestMenuPageState extends State<RequestMenuPage> {
  ClientListModel singleClient = new ClientListModel();
  Map<String, IconData> requestList = {
    'Demat Client Master': Icons.sort_outlined,
    'Demat Holding & Transaction Statement': Icons.stacked_line_chart_outlined,
    'Account Statement': Icons.receipt_long_outlined,
    'Contract Bill': Icons.wallet_membership_outlined,
    'P&L Statement': Icons.list_alt_outlined,
    'Profile Change': Icons.edit_attributes_outlined,
    'Trading Activation': Icons.desktop_mac_outlined,
    'Trading Deactivation': Icons.desktop_access_disabled_outlined,
    'Password Reset': Icons.vpn_key_outlined,
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      singleClient = globals.clientList[globals.codeIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15.0,
        ),
        child: Column(
          children: [
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
                      }),
                    }
                });
              },
              child: Picker(singleClient.clientCode ?? ''),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: new GridView.builder(
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        mainAxisExtent: 150),
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    itemCount: requestList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          openRequest(index);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5.0,
                          margin: EdgeInsets.all(15.0),
                          shadowColor: AppColor.primaryTextColor,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconView(
                                  icon: requestList.values.elementAt(index),
                                  size: 30,
                                  color: AppColor.primaryColor,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: LabelTextField(
                                    alignment: Alignment.center,
                                    textAlign: TextAlign.center,
                                    label: requestList.keys.elementAt(index),
                                    textColor: AppColor.secondaryTextColor,
                                    fontFamily: 'SemiBold',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    ));
  }

  openRequest(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DematClientMasterPage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DematHoldingTransactionStatementPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccountStatementPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ContractBillPage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PLStatementPage()),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileChangePage()),
        );
        break;
      case 6:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TradingActivationPage()),
        );
        break;
      case 7:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TradingDeactivationPage()),
        );
        break;
      case 8:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PasswordResetPage()),
        );
        break;
    }
  }
}
