import 'package:backoffice/businesspartner/BrokeragePage.dart';
import 'package:backoffice/businesspartner/ClientListPage.dart';
import 'package:backoffice/businesspartner/PCRReportPage.dart';
import 'package:backoffice/businesspartner/PureRiskPage.dart';
import 'package:backoffice/components/BackNavigationButton.dart';
import 'package:backoffice/components/IconView.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AppColor.dart';

class AuthorizedMenuPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AuthorizedMenuPageState();
}

class AuthorizedMenuPageState extends State<AuthorizedMenuPage> {
  Map<String, IconData> authorizedList = {
    'Pure Risk': Icons.sort_outlined,
    'Client List': Icons.stacked_line_chart_outlined,
    'Brokerage': Icons.receipt_long_outlined,
    // 'Dormant': Icons.wallet_membership_outlined,
   // 'PCR Report': Icons.list_alt_outlined
  };



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
            BackNavigationButton(
              label: 'Business Partner',
              isBackVisible: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: new GridView.builder(
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 150),
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    itemCount: authorizedList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          openMenu(index);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5.0,
                          margin: EdgeInsets.all(10.0),
                          shadowColor: AppColor.primaryTextColor,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconView(
                                  icon: authorizedList.values.elementAt(index),
                                  size: 40,
                                  color: AppColor.primaryColor,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: LabelTextField(
                                    alignment: Alignment.center,
                                    textAlign: TextAlign.center,
                                    label: authorizedList.keys.elementAt(index),
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

  openMenu(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PureRiskPage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ClientListPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BrokeragePage()),
        );
        break;
      case 3:
        /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ContractBillPage()),
        );*/
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PCRReportPage()),
        );
        break;

    }
  }
}
