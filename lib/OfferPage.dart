import 'dart:convert';

import 'package:backoffice/LandingPage.dart';
import 'package:backoffice/homepages/HomePage.dart';
import 'package:backoffice/services/ApiService.dart';
import 'package:backoffice/services/Constants.dart';
import 'package:backoffice/services/Helpers.dart';
import 'package:backoffice/services/new_websocket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';

import '../services/globals.dart' as globals;
import 'AppColor.dart';
import 'model/ClientListModel.dart';

class OfferPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OfferPageState();
}

class OfferPageState extends State<OfferPage> {
  Map<String, dynamic> dataMap = new Map<String, dynamic>();
  Response response = Response('', 200);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Helpers.getStringSF('accessToken').then((value) => {
          if (value != null)
            {
              connect('${Constants.stompUrl}=$value').then((stomp) => {
                    globals.stompClient = stomp,

                  }),
              connect('${Constants.stompUrl}=$value').whenComplete(() =>  getBranch(value),)
            }
          else
            {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LandingPage()),
              ),
            }
        });
  }

  getBranch(String accessToken) async {
    Map<String, String> headerParam = {
      'Authorization': 'Bearer $accessToken',
    };

    await ApiService.getMethod(
      '${Constants.middleWareBaseUrl}/api/v1/branch/',
      context,
      headerParam: headerParam,
    ).then((result) => {
          response = result,
          if (response.statusCode == 200)
            {
              setState(() {
                globals.singleBranch =
                    ClientListModel.fromJson(jsonDecode(response.body));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: SafeArea(
          child: Center(
            child: Wrap(
              children: [
                Column(
                  children: [
                    SvgPicture.asset(
                      'assets/image/ic_logo.svg',
                      height: 50.0,
                      width: 50.0,
                    ),
                    SpinKitThreeBounce(
                      color: AppColor.primaryColor,
                      size: 30.0,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
