import 'dart:convert';

import 'package:backoffice/ForgotPasswordPage.dart';
import 'package:backoffice/OfferPage.dart';
import 'package:backoffice/components/BackNavigationButton.dart';
import 'package:backoffice/services/ApiService.dart';
import 'package:backoffice/services/Constants.dart';
import 'package:backoffice/services/Helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';

import '../services/globals.dart' as globals;
import 'AppColor.dart';
import 'ChangePasswordPage.dart';
import 'components/IconView.dart';
import 'components/InputTextField.dart';
import 'components/LabelTextField.dart';
import 'components/SubmitButton.dart';
import 'model/LoginAuthModel.dart';

class LoginPage extends StatefulWidget {
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordIsVisible = false;
  bool passwordIsEnable = false;

  LoginAuthModel loginAuthModel = new LoginAuthModel();
  Response response = Response('', 200);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: SafeArea(
          child: Column(
            children: [
              BackNavigationButton(
                label: 'Login',
                isBackVisible: true,
              ),

              Padding(padding: EdgeInsets.only(top: 50.0)),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
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
                        Padding(padding: EdgeInsets.only(top: 50.0)),
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
                        Padding(padding: EdgeInsets.symmetric(vertical: 30.0)),
                        InputTextField(
                          onChanged: (text) {
                            numberController.selection =
                                TextSelection.fromPosition(
                                  TextPosition(
                                      offset: numberController.text.length),
                                );
                          },
                          labelText: 'Mobile Number',
                          textFieldController: numberController,
                          textInputType: TextInputType.phone,
                          textInputLength: 10,
                          icon: IconView(
                            icon: Icons.smartphone,
                            size: 20,
                            color: AppColor.primaryHintColor,
                          ),
                        ),
                        if (passwordIsVisible)
                          InputTextField(
                            onChanged: (text) {
                              passwordController.selection =
                                  TextSelection.fromPosition(
                                    TextPosition(
                                        offset: passwordController.text.length),
                                  );
                            },
                            labelText: 'OTP/Password',
                            textFieldController: passwordController,
                            icon: IconView(
                              icon: Icons.password,
                              size: 20,
                              color: AppColor.primaryHintColor,
                            ),
                          ),
                        Padding(padding: EdgeInsets.all(5.0)),
                        Padding(
                          padding: EdgeInsets.only(right: 100.0),
                          child: SubmitButton(
                            onPressed: () {
                              if (numberController.text.isEmpty) {
                                Helpers.showAlertDialog(
                                    'Enter mobile number', context);
                                return;
                              }
                              if (!passwordIsEnable) checkRegisterUser();
                              if (passwordIsEnable) setOtp();
                            },
                            fontFamily: 'SemiBold',
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 50.0)),
                        Row(
                          children: [
                            LabelTextField(
                              label: 'Don\'t have an account? ',
                              textColor: AppColor.primaryHintColor,
                              onPressed: () {},
                              textSize: 16.0,
                            ),
                            LabelTextField(
                              label: 'Register',
                              onPressed: () {},
                              fontFamily: 'Bold',
                              textSize: 16.0,
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                        LabelTextField(
                          label: 'Forgot password',
                          fontFamily: 'Bold',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordPage()),
                            );
                          },
                          textSize: 16.0,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void checkRegisterUser() {
    ApiService.postMethod(
            '${Constants.middleWareBaseUrl}/api/v1/user/check/${numberController.text}',
            context,
            isShowLoader: true)
        .then(
      (value) => {
        response = value,
        if (response.statusCode == 200)
          {
            setState(() {
              passwordIsEnable = true;
              passwordIsVisible = true;
            }),
          }
      },
    );
  }

  void setOtp() {
    Map<String, String> headerParam = {
      'Authorization': Constants.authKey,
    };
    var bodyParam = {
      'grant_type': 'password',
      'username': numberController.text,
      'password': passwordController.text,
    };
    ApiService.postMethod('${Constants.middleWareBaseUrl}/oauth/token', context,
            bodyParam: bodyParam, headerParam: headerParam, isShowLoader: true)
        .then(
      (value) async => {
        response = value,
        if (response.statusCode == 200)
          {
            loginAuthModel = LoginAuthModel.fromJson(jsonDecode(response.body)),
            globals.accessToken = 'Bearer ${loginAuthModel.accessToken}',
            if (loginAuthModel.redirectTo == 'changePassword')
              {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangePasswordPage(
                          loginAuthModel, numberController.text)),
                ),
              }
            else
              {
                Helpers.saveStringSF('accessToken', loginAuthModel.accessToken),
                Helpers.saveStringSF(
                    'refreshToken', loginAuthModel.refreshToken),
                Helpers.saveStringSF('redirectTo', loginAuthModel.redirectTo),
                Helpers.saveStringSF('topic', loginAuthModel.topic),
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OfferPage()),
                ),
              }
          }
      },
    );
  }
}
