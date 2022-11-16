import 'dart:convert';
import 'dart:io';

import 'package:backoffice/AppColor.dart';
import 'package:backoffice/components/BackNavigationButton.dart';
import 'package:backoffice/components/CallBackDialog.dart';
import 'package:backoffice/components/DropDown.dart';
import 'package:backoffice/components/FundDialog.dart';
import 'package:backoffice/components/IconView.dart';
import 'package:backoffice/components/InputTextField.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/LogoutDialog.dart';
import 'package:backoffice/components/Picker.dart';
import 'package:backoffice/components/SuggestionFeedbackDialog.dart';
import 'package:backoffice/components/WebPage.dart';
import 'package:backoffice/components/WithdrawFundDialog.dart';
import 'package:backoffice/homepages/IPOMenuPage.dart';
import 'package:backoffice/ipo/OpenIPOPage.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/model/MoreMenuModel.dart';
import 'package:backoffice/moremenu/AccountLedgerPage.dart';
import 'package:backoffice/services/ApiService.dart';
import 'package:backoffice/services/Constants.dart';
import 'package:backoffice/services/Helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share/share.dart';

import '../LoginPage.dart';
import '../services/globals.dart' as globals;

class MoreExpandMeuPage extends StatefulWidget {
  int menuIndex;

  MoreExpandMeuPage(this.menuIndex);

  @override
  State<StatefulWidget> createState() => MoreExpandMeuPageState();
}

class MoreExpandMeuPageState extends State<MoreExpandMeuPage> {
  ClientListModel singleClient = new ClientListModel();
  Response response = Response('', 200);
  List<MoreMenuModel> moreMenuList = [];
  List<MoreMenuModel> filterItem = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      singleClient = globals.clientList[globals.codeIndex];
    });
    getMoreMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: BackNavigationButton(
                        label: 'More',
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
                                  }),
                                }
                            });
                      },
                      child: Picker(singleClient.clientCode ?? ''),
                    ),
                  ],
                ),
              ),
              new Container(

                child: new Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: InputTextField(
                    labelText: 'Search',
                    textFieldController: searchController,
                    radius: 10.0,
                    icon: IconView(
                      icon: Icons.search,
                      size: 20,
                      color: AppColor.primaryHintColor,
                    ),
                    autoFocus: widget.menuIndex == 0 ? true : false,
                    onChanged: (text) {
                      onSearchTextChanged(text);
                    },
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: new GridView.builder(
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0,
                              mainAxisExtent: 150),
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      itemCount: filterItem.length,
                      itemBuilder: (context, index) {
                        MoreMenuModel singleItem = filterItem[index];
                        return GestureDetector(
                          onTap: () {
                            openMoreMenu(singleItem);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),

                            margin: EdgeInsets.all(10.0),
                            shadowColor: AppColor.primaryTextColor,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.network(
                                    singleItem.icon ?? '',
                                    height: 50.0,
                                    width: 50.0,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 0.0),
                                    child: LabelTextField(
                                      alignment: Alignment.center,
                                      textAlign: TextAlign.center,
                                      label: singleItem.title ?? '',
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
      ),
    );
  }

  onSearchTextChanged(String text) async {
    if (text.isNotEmpty) {
      setState(() {
        filterItem = moreMenuList
            .where((element) =>
                element.tags!.toLowerCase().contains(text.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        filterItem = moreMenuList;
      });
    }
  }

  getMoreMenu() async {
    Map<String, String> headerParam = {
      'Authorization': globals.accessToken,
    };
    await ApiService.getMethod(
      '${Constants.middleWareBaseUrl}/api/v1/more_menu/',
      context,
      headerParam: headerParam,
    ).then((result) => {
          response = result,
          if (response.statusCode == 200)
            {
              setState(() {
                if (widget.menuIndex == 0) {
                  moreMenuList = (json.decode(response.body) as List)
                      .map((i) => MoreMenuModel.fromJson(i))
                      .toList();
                  filterItem = moreMenuList;
                } else {
                  moreMenuList = (json.decode(response.body) as List)
                      .map((i) => MoreMenuModel.fromJson(i))
                      .toList()
                      .where((element) => element.parent == widget.menuIndex)
                      .toList();
                  filterItem = moreMenuList;
                }
              })
            }
        });
  }

  openMoreMenu(MoreMenuModel item) {
    print("more menu ${jsonEncode(item)}");
    switch (item.type) {
      case 'LINK':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WebPage(item)),
        );
        break;
      case 'IPO':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => IPOMenuPage()),
        );
        break;
      case 'LEDGER':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccountLedgerPage()),
        );
        break;
      case 'ADD_BALANCE':
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return FundDialog();
          },
        );
        break;
      case 'WITHDRAW_BALANCE':
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WithdrawFundDialog();
          },
        );
        break;
      case 'WHATSAPP_LINK':
        Helpers.launchURL('https://wa.me/${item.url}');
        //Helpers.launchURL('https://wa.me/${item.url}?text=Your Message here');
        break;
      case 'TELEGRAM_LINK':
        Helpers.launchURL(item.url ?? '');
        break;
      case 'SHARE_APP':
        Share.share(
            '\nI have experienced PATEL WEALTH BACKOFFICE App and it\'s so easy and user friendly.I insist you to try it once.\n\n${Constants.playStoreUrl}',
            subject: 'Patel Wealth BackOffice');
        break;
      case 'RATE_APP':
        if (Platform.isAndroid) {
          Helpers.launchURL(
              Constants.playStoreUrl);
        } else {
          openStoreListing();
        }
        break;
      case 'CALL_BACK':
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CallBackDialog(
              item.type ?? '',
              header: item.title ?? '',
              labelText: 'Mobile Number',
            );
          },
        );
        break;
      case 'SUGGESTION':
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SuggestionFeedbackDialog(
              item.type ?? '',
              header: item.title ?? '',
              labelText: 'Write Suggestions',
            );
          },
        );
        break;
      case 'FEEDBACK':
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SuggestionFeedbackDialog(
              item.type ?? '',
              header: item.title ?? '',
              labelText: 'Write Feedback',
            );
          },
        );
        break;
      case 'LOGOUT':
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return LogoutDialog();
          },
        ).then(
          (value) => {
            if (value != null && value == 'Logout')
              {
                Helpers.clearSF(),
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                ),
              },
          },
        );
        break;
    }
  }

  Future<void> openStoreListing() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }
}
