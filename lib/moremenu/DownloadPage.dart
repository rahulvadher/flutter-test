import 'dart:convert';

import 'package:backoffice/components/BackNavigationButton.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Loader.dart';
import 'package:backoffice/model/DownloadItemModel.dart';
import 'package:backoffice/model/DownloadModel.dart';
import 'package:backoffice/services/ApiService.dart';
import 'package:backoffice/services/Constants.dart';
import 'package:backoffice/services/Helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import '../AppColor.dart';
import '../services/globals.dart' as globals;

class DownloadPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DownloadPageState();
}

class DownloadPageState extends State<DownloadPage> {
  List<DownloadItemModel> downloadList = [];
  Response response = Response('', 200);
  Map<String, dynamic> dataMap = new Map<String, dynamic>();
  DownloadModel downloadModel = new DownloadModel(content: []);
  int pageIndex = 0;
  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDownload();

    scrollController
      ..addListener(() {
        if (scrollController.offset >=
                scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          if (!(downloadModel.last ?? false)) {
            pageIndex++;
            getDownload();
          }
        }
        if (scrollController.offset <=
                scrollController.position.minScrollExtent &&
            !scrollController.position.outOfRange) {
          setState(() {
            //   message = "reach the top";
          });
        }
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
                BackNavigationButton(
                  label: 'Download',
                  isBackVisible: true,
                ),
                Expanded(
                    child: downloadList.isEmpty
                        ? Loader()
                        : ListView.builder(
                            primary: false,
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: downloadList.length,
                            itemBuilder: (context, index) {
                              DownloadItemModel singleItem =
                                  downloadList[index];
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Helpers.launchURL(
                                          singleItem.link.toString());
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5.0,
                                      shadowColor: AppColor.primaryTextColor,
                                      child: new Padding(
                                        padding: new EdgeInsets.all(7.0),
                                        child: LabelTextField(
                                          label: singleItem.title.toString(),
                                          textSize: 16.0,
                                          fontFamily: 'SemiBold',
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            })),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getDownload() async {
    Map<String, String> headerParam = {
      'Authorization': globals.accessToken,
    };
    await ApiService.getMethod(
      '${Constants.middleWareBaseUrl}/api/v1/download/?page=$pageIndex',
      context,
      headerParam: headerParam,
    ).then((result) => {
          response = result,
          if (response.statusCode == 200) dataMap = jsonDecode(response.body),
          {
            setState(() {
              downloadModel = DownloadModel.fromJson(jsonDecode(response.body));
              downloadList.addAll(downloadModel.content);
            })
          }
        });
  }
}
