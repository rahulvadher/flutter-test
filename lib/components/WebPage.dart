import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/model/MoreMenuModel.dart';
import 'package:backoffice/services/Helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/globals.dart' as globals;
import 'BackNavigationButton.dart';
import 'DropDown.dart';
import 'Picker.dart';

class WebPage extends StatefulWidget {
  MoreMenuModel item;

  WebPage(this.item);

  State<StatefulWidget> createState() => WebPageState();
}

class WebPageState extends State<WebPage> {
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
      body: Column(
        children: [
          SafeArea(
            child: Padding(
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
                                }),
                              }
                          });
                    },
                    child: Picker(singleClient.clientCode ?? ''),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: WebView(
              initialUrl: widget.item.url,
              onPageStarted: (item) {
                Helpers.shodLoader(context);
              },
              onPageFinished: (item) {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
