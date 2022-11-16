import 'dart:convert';

import 'package:backoffice/components/DropDown.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Picker.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/model/HoldingModel.dart';
import 'package:backoffice/services/ApiService.dart';
import 'package:backoffice/services/Constants.dart';
import 'package:backoffice/stock/OpenPositionPage.dart';
import 'package:backoffice/stock/StockCusaHoldingPage.dart';
import 'package:backoffice/stock/StockDematHoldingPage.dart';
import 'package:backoffice/stock/StockPledgedHoldingPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../AppColor.dart';
import '../services/globals.dart' as globals;

class StockMenuPage extends StatefulWidget {
  StockMenuPage({Key? key}) : super(key: key);

  State<StatefulWidget> createState() => StockMenuPageState();
}

class StockMenuPageState extends State<StockMenuPage>
    with SingleTickerProviderStateMixin {
  GlobalKey<StockDematHoldingPageState> _keyDemat =
      GlobalKey<StockDematHoldingPageState>();
  GlobalKey<StockCusaHoldingPageState> _keyCusa =
      GlobalKey<StockCusaHoldingPageState>();
  GlobalKey<StockPledgedHoldingPageState> _keyPledged =
      GlobalKey<StockPledgedHoldingPageState>();
  GlobalKey<OpenPositionPageState> _keyPosition =
      GlobalKey<OpenPositionPageState>();
  int segmentedControlValue = 0;
  late TabController _tabController;
  ClientListModel singleClient = new ClientListModel();
  Response response = Response('', 200);
  List<HoldingModel> holdingList = [];

  @override
  void initState() {
    super.initState();
    singleClient = globals.clientList[globals.codeIndex];
    _tabController = new TabController(
        vsync: this, length: 4, initialIndex: segmentedControlValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SafeArea(
              child: GestureDetector(
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
                              if (segmentedControlValue == 0) {
                                _keyDemat.currentState?.getDematHolding();
                              } else if (segmentedControlValue == 1) {
                                _keyCusa.currentState?.getCusaHolding();
                              } else if (segmentedControlValue == 2) {
                                _keyPledged.currentState?.getPledgedHolding();
                              } else if (segmentedControlValue == 3) {
                                _keyPosition.currentState?.getPledgedHolding();
                              }
                            }),
                          }
                      });
                },
                child: Picker(singleClient.clientCode ?? ''),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              width: 350,
              child: CupertinoSlidingSegmentedControl(
                  groupValue: segmentedControlValue,
                  backgroundColor: AppColor.primaryHintColor.withOpacity(0.200),
                  children: <int, Widget>{
                    0: LabelTextField(
                      label: 'Demat',
                      alignment: Alignment.center,
                      fontFamily: 'SemiBold',
                      textColor: AppColor.secondaryTextColor,
                    ),
                    1: LabelTextField(
                      label: 'Cusa',
                      alignment: Alignment.center,
                      fontFamily: 'SemiBold',
                      textColor: AppColor.secondaryTextColor,
                    ),
                    2: LabelTextField(
                      label: 'Pledged',
                      alignment: Alignment.center,
                      fontFamily: 'SemiBold',
                      textColor: AppColor.secondaryTextColor,
                    ),
                    3: LabelTextField(
                      label: 'Position',
                      alignment: Alignment.center,
                      fontFamily: 'SemiBold',
                      textColor: AppColor.secondaryTextColor,
                    ),
                  },
                  onValueChanged: (value) {
                    setState(() {
                      segmentedControlValue = int.parse('$value');
                      if (segmentedControlValue == 0) {
                        _tabController.animateTo(0);
                        // getDematHolding();
                      } else if (segmentedControlValue == 1) {
                        _tabController.animateTo(1);
                      } else if (segmentedControlValue == 2) {
                        _tabController.animateTo(2);
                        //   getPledgedHolding();
                      } else if (segmentedControlValue == 3) {
                        _tabController.animateTo(3);
                      }
                    });
                  }),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: new LabelTextField(
                      label: 'Quantity',
                      fontFamily: 'SemiBold',
                      textSize: 16.0,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: new LabelTextField(
                      alignment: Alignment.center,
                      label: 'Price',
                      fontFamily: 'SemiBold',
                      textSize: 16.0,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: new LabelTextField(
                      alignment: Alignment.topRight,
                      label: 'Value',
                      fontFamily: 'SemiBold',
                      textSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            new Expanded(
              child: new TabBarView(
                  controller: _tabController,
                  // Restrict scroll by user
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    StockDematHoldingPage(key: _keyDemat),
                    StockCusaHoldingPage(key: _keyCusa),
                    StockPledgedHoldingPage(key: _keyPledged),
                    OpenPositionPage(key: _keyPosition),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
