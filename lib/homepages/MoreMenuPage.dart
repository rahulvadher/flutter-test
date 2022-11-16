import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:backoffice/LoginPage.dart';
import 'package:backoffice/businesspartner/BrokeragePage.dart';
import 'package:backoffice/businesspartner/ClientListPage.dart';
import 'package:backoffice/businesspartner/PCRReportPage.dart';
import 'package:backoffice/businesspartner/PureRiskPage.dart';
import 'package:backoffice/components/DropDown.dart';
import 'package:backoffice/components/IconView.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/LogoutDialog.dart';
import 'package:backoffice/components/Picker.dart';
import 'package:backoffice/homepages/IPOMenuPage.dart';
import 'package:backoffice/ipo/AllotmentPage.dart';
import 'package:backoffice/ipo/BIDListPage.dart';
import 'package:backoffice/ipo/OpenIPOPage.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/model/MoreMenuModel.dart';
import 'package:backoffice/moremenu/AccountLedgerPage.dart';
import 'package:backoffice/moremenu/AuthorizedMenuPage.dart';
import 'package:backoffice/moremenu/DownloadPage.dart';
import 'package:backoffice/moremenu/ExecutedTradesPage.dart';
import 'package:backoffice/moremenu/FundsPage.dart';
import 'package:backoffice/moremenu/MoreExpandMeuPage.dart';
import 'package:backoffice/moremenu/NotificationPage.dart';
import 'package:backoffice/services/Helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';

import '../AppColor.dart';
import '../services/globals.dart' as globals;

class MoreMenuPage extends StatefulWidget {
  State<StatefulWidget> createState() => MoreMenuPageState();
}

class MoreMenuPageState extends State<MoreMenuPage>
    with TickerProviderStateMixin {
  String segment = '';

  List<MoreMenuModel> moreMenuList = [];
  ClientListModel singleClient = new ClientListModel();
  double menu1Height = 70.0,
      menu2Height = 70.0,
      menu3Height = 70.0,
      menu4Height = 70.0,
      menu5Height = 50.0;
  VideoPlayerController _controller=new VideoPlayerController.asset(globals.backgroundImage);
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
        globals.backgroundImage)
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.play();
        setState(() {});
      });
    setState(() {
      singleClient = globals.clientList[globals.codeIndex];
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      singleClient = globals.clientList[globals.codeIndex];
    });

    return Scaffold(
      body: Stack(

     children: [
       Padding(
         padding: EdgeInsets.only(bottom: 150.0),
         child: SizedBox.expand(
           child: FittedBox(
             fit: BoxFit.cover,
             child: SizedBox(
               width: _controller.value.size.width,
               height: _controller.value.size.height,
               child: VideoPlayer(_controller),
             ),
           ),
         ),
       ),
      SafeArea(
        child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Padding(
                 padding: EdgeInsets.symmetric(horizontal: 15.0),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                         child: Picker(
                           singleClient.clientCode ?? '',
                           isMore: true,
                         )),
                     GestureDetector(
                       onTap: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                               builder: (context) => NotificationPage()),
                         );

                       },
                       child: IconView(
                         icon: Icons.notifications_none,
                         color: AppColor.primaryTextColor,
                         size: 20,
                       ),
                     ),
                   ],
                 ),
               ),
               Expanded(
                 child: Align(
                   alignment: FractionalOffset.bottomCenter,
                   child: menu(
                       70,
                       70,
                       70,
                       globals.singleBranch.branchCode == null ? 50 : 50,
                       50,
                       context,
                       globals.backgroundColor,
                       globals.foregroundColor),
                 ),
               )
             ],
           ),
      ),
     ],
      ),
    );
  }
}


void openExpandMenu(BuildContext context,int menuIndex) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MoreExpandMeuPage(menuIndex),
    ),
  );
}

Widget menu(
    double menu1,
    double menu2,
    double menu3,
    double menu4,
    double menu5,
    BuildContext context,
    Color backgroundColor,
    Color foregroundColor) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      GestureDetector(
        onTap: () {
          openExpandMenu(context,0);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(spreadRadius: 0, blurRadius: 5),
            ],
            color: backgroundColor,
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: LabelTextField(
                      label: 'Search',
                      fontFamily: 'SemiBold',
                      textSize: 16.0,
                      alignment: Alignment.center,
                      textColor: foregroundColor,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Align(
                  alignment: Alignment.center,
                  child: IconView(icon: Icons.search, color: foregroundColor),
                ),
              ),
            ],
          ),
        ),
      ),
      ColumnSuper(
        innerDistance: -20,
        children: <Widget>[
          if (globals.singleBranch.branchCode != null)
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthorizedMenuPage(),
                ),
              );
            },
            child: Container(
              height: menu1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(spreadRadius: 0, blurRadius: 5),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: Container(
                  color: backgroundColor,
                  child: Padding(
                    padding:
                    EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 15.0),
                              child: IconView(
                                color: foregroundColor,
                                icon: Icons.business_outlined,
                                size: 20,
                              ),
                            ),
                            LabelTextField(
                              label: 'Business Partner',
                              fontFamily: 'SemiBold',
                              textSize: 16.0,
                              alignment: Alignment.center,
                              textColor: foregroundColor,
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: IconView(
                              icon: Icons.chevron_right, color: foregroundColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              openExpandMenu(context,1);
            },
            child: Container(
              height: menu1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(spreadRadius: 0, blurRadius: 5),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: Container(
                  color: backgroundColor,
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 15.0),
                              child: IconView(
                                color: foregroundColor,
                                icon: Icons.margin,
                                size: 20,
                              ),
                            ),
                            LabelTextField(
                              label: 'I want to',
                              fontFamily: 'SemiBold',
                              textSize: 16.0,
                              alignment: Alignment.center,
                              textColor: foregroundColor,
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: IconView(
                              icon: Icons.chevron_right, color: foregroundColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              openExpandMenu(context,2);
            },
            child: Container(
              height: menu2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(spreadRadius: 0, blurRadius: 5),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: Container(
                  color: backgroundColor,
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 15.0),
                              child: IconView(
                                icon: Icons.keyboard,
                                size: 20,
                                color: foregroundColor,
                              ),
                            ),
                            LabelTextField(
                              label: 'I need',
                              fontFamily: 'SemiBold',
                              textSize: 16.0,
                              alignment: Alignment.center,
                              textColor: foregroundColor,
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: IconView(
                              icon: Icons.chevron_right, color: foregroundColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              openExpandMenu(context,3);
            },
            child: Container(
              height: menu3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(spreadRadius: 0, blurRadius: 5),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: Container(
                  color: backgroundColor,
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 15.0),
                              child: IconView(
                                icon: Icons.view_compact_outlined,
                                size: 20,
                                color: foregroundColor,
                              ),
                            ),
                            LabelTextField(
                              label: 'Know more about',
                              fontFamily: 'SemiBold',
                              textSize: 16.0,
                              alignment: Alignment.center,
                              textColor: foregroundColor,
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: IconView(
                              icon: Icons.chevron_right, color: foregroundColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              openExpandMenu(context,4);
            },
            child: Container(
              height: menu4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(spreadRadius: 0, blurRadius: 5),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: Container(
                  color: backgroundColor,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                        bottom:
                            globals.singleBranch.branchCode == null ? 0.0 : 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 15.0),
                              child: IconView(
                                icon: Icons.menu,
                                size: 20,
                                color: foregroundColor,
                              ),
                            ),
                            LabelTextField(
                              label: 'Support',
                              fontFamily: 'SemiBold',
                              textSize: 16.0,
                              alignment: Alignment.center,
                              textColor: foregroundColor,
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: IconView(
                              icon: Icons.chevron_right, color: foregroundColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        /*  if (globals.singleBranch.branchCode != null)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthorizedMenuPage(),
                  ),
                );
              },
              child: Container(
                height: menu5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(spreadRadius: 0, blurRadius: 5),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  child: Container(
                    color: backgroundColor,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 10.0, right: 15.0),
                                child: IconView(
                                  icon: Icons.business_outlined,
                                  size: 20,
                                  color: foregroundColor,
                                ),
                              ),
                              LabelTextField(
                                label: 'Business Partner',
                                fontFamily: 'SemiBold',
                                textSize: 16.0,
                                alignment: Alignment.center,
                                textColor: foregroundColor,
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: IconView(
                              icon: Icons.chevron_right,
                              color: foregroundColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),*/
        ],
      ),
    ],
  );
}

Future<void> menuSelectionTask(BuildContext? context, int id) async {
  print(id);
  switch (id) {
    case 2:
      Navigator.push(
        context!,
        MaterialPageRoute(
            builder: (context) => ExecutedTradesPage(
                  isHeaderVisible: true,
                )),
      );
      break;
    case 3:
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => AccountLedgerPage()),
      );
      break;
    case 4:
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => FundsPage()),
      );
      break;

    case 6:
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => DownloadPage()),
      );
      break;
    case 8:
      Helpers.launchURL('https://www.patelwealth.com');
      break;
    case 9:
      Helpers.launchURL('https://www.patelwealth.com/#about');
      break;
    case 10:
      Share.share(
          '\nI have experienced PATEL WEALTH BACKOFFICE App and it\'s so easy and user friendly.I insist you to try it once.\n\nhttps://play.google.com/store/apps/details?id=com.muraniinfotech.pbackoffice',
          subject: 'Patel Wealth BackOffice');
      break;
    case 11:
      Helpers.launchURL(
          'http://play.google.com/store/apps/details?id=com.muraniinfotech.pbackoffice');
      break;
    case 12:
      showDialog(
        context: context!,
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
    case 51:
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => OpenIPOPage()),
      );
      break;

    case 53:
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => AllotmentPage()),
      );
      break;

    case 101:
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => PureRiskPage()),
      );
      break;
    case 102:
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => ClientListPage()),
      );
      break;
    case 103:
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => BrokeragePage()),
      );
      break;
    case 105:
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => PCRReportPage()),
      );
      break;
  }
}
