import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import 'AppColor.dart';
import 'components/SubmitButton.dart';

class LandingPage extends StatefulWidget {
  State<StatefulWidget> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0,vertical: 10.0),
        child: SafeArea(
          child: SingleChildScrollView(

            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: SvgPicture.asset(
                      'assets/image/ic_logo.svg',
                      height: 80.0,
                      width: 80.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 50)),
                  Column(
                    children: [
                      LabelTextField(
                        label: 'Welcome to',
                        onPressed: () {},
                        textSize: 26.0,
                      ),
                      Padding(padding: EdgeInsets.only(top: 5.0)),
                      LabelTextField(
                        label: 'Patel Wealth Advisors Pvt. Ltd.',
                        onPressed: () {},
                        textSize: 24.0,
                      ),
                      Padding(padding: EdgeInsets.only(top: 15.0)),
                      LabelTextField(
                        label:
                            'We are a team of entrepreneurs from Gujarat engaged in offering a wide range of financial services with a primary focus on qualitative financial advice and helping small and medium businesses to access capital market at economical costs.',
                        onPressed: () {},
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 30.0)),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: width/2,
                          child: SubmitButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            },
                            label: 'Login to Back Office',
                            fontFamily: 'SemiBold',
                            backGroundColor: AppColor.primaryTextColor,
                            textColor: AppColor.primaryColor,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(5.0)),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: width/2,
                          child: SubmitButton(
                            onPressed: () {},
                            label: 'Open an account',
                            fontFamily: 'SemiBold',
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 30.0)),
                      LabelTextField(
                        label: 'NSE & BSE & MCX - SEBI Registration no: INZ000018432',
                        onPressed: () {},
                        textSize: 12.0,
                      ),
                      LabelTextField(
                        label: 'NSDL - SEBI Registration no: IN-DP-251-201',
                        onPressed: () {},
                        textSize: 12.0,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
