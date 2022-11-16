import 'dart:convert';

import 'package:backoffice/components/IconView.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Loader.dart';
import 'package:backoffice/components/OpenIPODialog.dart';
import 'package:backoffice/components/SubmitButton.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/model/OpenBIDListDataModel.dart';
import 'package:backoffice/model/OpenBIDListModel.dart';
import 'package:backoffice/services/ApiService.dart';
import 'package:backoffice/services/Constants.dart';
import 'package:backoffice/services/Helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../AppColor.dart';
import '../services/globals.dart' as globals;

class OpenIPOPage extends StatefulWidget {
  State<StatefulWidget> createState() => OpenIPOPageState();
}

class OpenIPOPageState extends State<OpenIPOPage> {
  List<OpenBIDContent> openBidList = [];
  Map<String, dynamic> dataMap = new Map<String, dynamic>();
  OpenBIDListDataModel openBIDListDataModel =
      new OpenBIDListDataModel(content: []);
  Response response = Response('', 200);
  ClientListModel singleClient = new ClientListModel();
  int pageIndex = 0;
  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    singleClient = globals.clientList[globals.codeIndex];
    getOpenIPO();

    scrollController
      ..addListener(() {
        if (scrollController.offset >=
                scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          if (!(openBIDListDataModel.last ?? false)) {
            pageIndex++;
            getOpenIPO();
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
      body: openBidList.isEmpty
          ? Loader()
          : ListView.builder(
              controller: scrollController,
              padding: EdgeInsets.zero,
              itemCount: openBidList.length,
              itemBuilder: (context, index) {
                OpenBIDContent singleBIDItem = openBidList[index];
                if (checkDate(
                    Helpers.changeDateFormat(
                        singleBIDItem.biddingStartDate ?? '',
                        'dd-MM-yyyy',
                        'dd-MM-yyyy'),
                    Helpers.changeDateFormat(singleBIDItem.biddingEndDate ?? '',
                        'dd-MM-yyyy', 'dd-MM-yyyy'))) {
                  singleBIDItem.isEnable = false;
                } else {
                  singleBIDItem.isEnable = true;
                }
                return new Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5.0,
                    shadowColor: AppColor.primaryTextColor,
                    child: new Padding(
                        padding: new EdgeInsets.all(7.0),
                        child: Align(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              LabelTextField(
                                label: singleBIDItem.name.toString(),
                                fontFamily: 'Bold',
                                textSize: 18.0,
                              ),
                              Row(
                                children: [
                                  LabelTextField(
                                    label: 'Open Date :- ',
                                    fontFamily: 'SemiBold',
                                  ),
                                  LabelTextField(
                                    label:
                                        '${singleBIDItem.biddingStartDate} to '
                                        '${singleBIDItem.biddingEndDate}',
                                    textColor: AppColor.secondaryTextColor,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  LabelTextField(
                                    label: 'Min. Bid Qty :- ',
                                    fontFamily: 'SemiBold',
                                  ),
                                  LabelTextField(
                                    label:
                                        singleBIDItem.minBidQuantity.toString(),
                                    textColor: AppColor.secondaryTextColor,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  LabelTextField(
                                    label: 'Price Range :- ',
                                    fontFamily: 'SemiBold',
                                  ),
                                  LabelTextField(
                                    label:
                                        '${singleBIDItem.minPrice!} - ${singleBIDItem.cutOffPrice!}',
                                    textColor: AppColor.secondaryTextColor,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  LabelTextField(
                                    label: 'Min App Value :- ',
                                    fontFamily: 'SemiBold',
                                  ),
                                  LabelTextField(
                                    label:
                                        '${singleBIDItem.minBidQuantity! * singleBIDItem.cutOffPrice!}',
                                    textColor: AppColor.secondaryTextColor,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  LabelTextField(
                                    label: 'Exchange :- ',
                                    fontFamily: 'SemiBold',
                                  ),
                                  LabelTextField(
                                    label: singleBIDItem.exchange!.join(','),
                                    textColor: AppColor.secondaryTextColor,
                                  ),
                                ],
                              ),
                              if (singleBIDItem.ratings != 0.0)
                                Row(
                                  children: [
                                    LabelTextField(
                                      label: 'Rating :- ',
                                      fontFamily: 'SemiBold',
                                    ),
                                    RatingBarIndicator(
                                      rating: singleBIDItem.ratings ?? 0.0,
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 10,
                                      itemSize: 20.0,
                                      direction: Axis.horizontal,
                                    ),
                                  ],
                                ),
                              Padding(padding: EdgeInsets.all(5.0)),
                              Row(
                                children: [
                                  SubmitButton(
                                    onPressed: () {
                                      if (singleBIDItem.isEnable!) {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return OpenIPODialog(
                                              singleBIDItem: singleBIDItem,
                                            );
                                          },
                                        ).then((value) => {
                                              if (value != null)
                                                Helpers.showAlertDialog(
                                                    value, context)
                                            });
                                      }
                                    },
                                    fontFamily: 'SemiBold',
                                    label: 'Apply Now',
                                    backGroundColor:
                                        singleBIDItem.isEnable ?? false
                                            ? AppColor.primaryColor
                                            : AppColor.primaryHintColor,
                                    textColor: AppColor.primaryTextColor,
                                    shadowColors: singleBIDItem.isEnable == true
                                        ? AppColor.primaryColor
                                        : AppColor.primaryTextColor,
                                    borderWidth: singleBIDItem.isEnable == true
                                        ? 1.0
                                        : 0.0,
                                  ),
                                  Expanded(
                                    flex: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        Helpers.launchURL('tel:8469184848');
                                      },
                                      child: Card(
                                        elevation: 5.0,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0)),
                                        shadowColor: AppColor.primaryColor,
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(5.0),
                                          child: IconView(
                                            icon: Icons.phone,
                                            size: 25.0,
                                            color: AppColor.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )));
              },
            ),
    );
  }

  Future<void> getOpenIPO() async {
    Map<String, String> headerParam = {
      'Api-Key': Constants.ipoAPIKey,
    };
    ApiService.getMethod(
      '${Constants.ipoUrl}/api/v1/open/?sort=name,asc&page=$pageIndex',
      context,
      headerParam: headerParam,
    ).then((value) => {
          response = value,
          if (response.statusCode == 200)
            {
              dataMap = jsonDecode(response.body),
              if (mounted)
                setState(() {
                  openBIDListDataModel =
                      OpenBIDListDataModel.fromJson(jsonDecode(response.body));
                  if (pageIndex == 0)
                    openBidList = openBIDListDataModel.content;
                  else
                    openBidList.addAll(openBIDListDataModel.content);
                })
            }
        });
  }

  bool checkDate(String openDate, String endDate) {
    final String formatted = DateFormat('dd-MM-yyyy').format(DateTime.now());
    DateTime current = DateFormat('dd-MM-yyyy').parse(formatted);
    DateTime openIPODate = DateFormat('dd-MM-yyyy').parse(openDate);
    DateTime endIPODate = DateFormat('dd-MM-yyyy').parse(endDate);
    if (openIPODate.isBefore(current) && endIPODate.isAtSameMomentAs(current)) {
      return false;
    } else if (openIPODate.isBefore(current) && endIPODate.isAfter(current)) {
      return false;
    } else if (openIPODate.isAfter(current) && endIPODate.isBefore(current)) {
      return false;
    } else if (openIPODate.isAtSameMomentAs(current) &&
        endIPODate.isAfter(current)) {
      return false;
    } else {
      return true;
    }
  }
}
