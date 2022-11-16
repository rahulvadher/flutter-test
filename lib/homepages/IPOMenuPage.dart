
import 'package:backoffice/components/BackNavigationButton.dart';
import 'package:backoffice/components/DropDown.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Picker.dart';
import 'package:backoffice/ipo/AllotmentPage.dart';
import 'package:backoffice/ipo/BIDListPage.dart';
import 'package:backoffice/ipo/OpenIPOPage.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/model/OpenBIDListDataModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../AppColor.dart';
import '../services/globals.dart' as globals;

class IPOMenuPage extends StatefulWidget {
  IPOMenuPage({Key? key}) : super(key: key);
  State<StatefulWidget> createState() => IPOMenuPageState();
}

class IPOMenuPageState extends State<IPOMenuPage> with SingleTickerProviderStateMixin {
  GlobalKey<BIDListPageState> _key = GlobalKey<BIDListPageState>(); // declaration of the key
  int segmentedControlValue = 0;
  List<OpenBIDListDataModel> openBidList = [];
  Map<String, dynamic> dataMap = new Map<String, dynamic>();
  Response response = Response('', 200);
  late TabController _tabController;
  ClientListModel singleClient = new ClientListModel();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(
        vsync: this, length: 3, initialIndex: segmentedControlValue);
    setState(() {
      singleClient = globals.clientList[globals.codeIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: BackNavigationButton(
                        isBackVisible: true,
                      ),
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
                                _key.currentState?.getMyBIDList();
                              }),
                            }
                        });
                      },
                      child: Picker(singleClient.clientCode ?? ''),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                width: 300,
                child: CupertinoSlidingSegmentedControl(
                    groupValue: segmentedControlValue,
                    backgroundColor: AppColor.primaryHintColor.withOpacity(0.200),
                    children: <int, Widget>{
                      0: LabelTextField(
                        label: 'Open',
                        alignment: Alignment.center,
                        fontFamily: 'SemiBold',
                        textColor: AppColor.secondaryTextColor,
                      ),
                      1: LabelTextField(
                        label: 'My Bid',
                        alignment: Alignment.center,
                        fontFamily: 'SemiBold',
                        textColor: AppColor.secondaryTextColor,
                      ),
                      2: LabelTextField(
                        label: 'Allotment',
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
                        } else if (segmentedControlValue == 1) {
                          _tabController.animateTo(1);
                        } else {
                          _tabController.animateTo(2);
                        }
                      });
                    }),
              ),
              new Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: new TabBarView(
                      controller: _tabController,
                      // Restrict scroll by user
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        new Center(
                          child: OpenIPOPage(),
                        ),
                        new Center(
                          child: BIDListPage(key: _key),
                        ),
                        new Center(
                          child: AllotmentPage(),
                        ),
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool checkDate(String date) {
    final String formatted = DateFormat('dd-MM-yyyy').format(DateTime.now());
    DateTime current = DateFormat('dd-MM-yyyy').parse(formatted);
    DateTime openIPODate = DateFormat('dd-MM-yyyy').parse(date);
    if (current.isBefore(openIPODate)) {
      return true;
    } else {
      return false;
    }
  }
}
