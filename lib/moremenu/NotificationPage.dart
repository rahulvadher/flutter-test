import 'package:backoffice/components/BackNavigationButton.dart';
import 'package:backoffice/components/DropDown.dart';
import 'package:backoffice/components/Picker.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../services/globals.dart' as globals;

class NotificationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  ClientListModel singleClient = new ClientListModel();
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
                          label: 'Notification',
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
                        child: Picker(singleClient.clientCode ?? ''),
                      ),
                    ],
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
