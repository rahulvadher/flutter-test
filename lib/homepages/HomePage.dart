import 'package:backoffice/components/SubmitButton.dart';
import 'package:backoffice/homepages/MoreMenuPage.dart';
import 'package:backoffice/homepages/StockMenuPage.dart';
import 'package:backoffice/moremenu/ExecutedTradesPage.dart';
import 'package:backoffice/moremenu/ProfilePage.dart';
import 'package:backoffice/services/ConnectivityStatus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../AppColor.dart';
import '../services/globals.dart' as globals;
import 'HomeMenuPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage>  {
  int selectedIndex = 0;
  static List<Widget> menuPageList = <Widget>[
    HomeMenuPage(),
    ProfilePage(),
    StockMenuPage(),
    ExecutedTradesPage(),
    MoreMenuPage(),
  ];

  @override
  Widget build(BuildContext context) {
    if (Provider.of<ConnectivityStatus>(context) ==
        ConnectivityStatus.Offline) {
      return Scaffold(
          backgroundColor: AppColor.primaryTextColor,
          body: SafeArea(
            child: Center(
              child: Container(
                  height: 90,
                  child: Column(
                    children: [
                      Text(
                        'Network Connection Offline',
                        style: TextStyle(
                          color: AppColor.primaryColor,
                          fontSize: 16.0,
                          fontFamily: 'Montserrat-light',
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                      SubmitButton(
                        onPressed: () {},
                        label: 'Get Online',
                      ),
                    ],
                  )),
            ),
          ));
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
          backgroundColor:selectedIndex==4? globals.backgroundColor:null,
          body: menuPageList.elementAt(selectedIndex),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25), topLeft: Radius.circular(25)),
              boxShadow: [
                BoxShadow(

                    spreadRadius: 0,
                    blurRadius: 5),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),

                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  selectedLabelStyle: TextStyle(
                    fontFamily: 'SemiBold',
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontFamily: 'SemiBold',
                  ),
                  selectedIconTheme: IconThemeData(size: 28.0),

                  unselectedItemColor: AppColor.primaryHintColor.withOpacity(.60),
                  selectedFontSize: 14.0,
                  unselectedFontSize: 14.0,
                  currentIndex: selectedIndex,
                  onTap: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                  items: [
                    BottomNavigationBarItem(
                      label: 'Home',
                      icon: Icon(Icons.home),
                    ),

                    BottomNavigationBarItem(
                      label: 'Profile',
                      icon: Icon(Icons.person_pin_rounded),
                    ),
                    BottomNavigationBarItem(
                      label: 'Portfolio',
                      icon: Icon(Icons.sort_outlined),
                    ),
                    BottomNavigationBarItem(
                      label: 'Trades',
                      icon: Icon(Icons.sticky_note_2_outlined),
                    ),
                    BottomNavigationBarItem(
                      label: 'More',
                      icon: Icon(Icons.settings),
                    ),
                  ],
                ),

            ),
          ),
        ),
      );
    }
  }
}
