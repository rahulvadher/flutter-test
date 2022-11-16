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
import 'OfferPage.dart';
import 'components/IconView.dart';
import 'components/InputTextField.dart';
import 'components/LabelTextField.dart';
import 'components/SubmitButton.dart';
import 'model/LoginAuthModel.dart';

class ChangePasswordPage extends StatefulWidget {
  LoginAuthModel loginAuthModel;
  String mobileNumber;

  ChangePasswordPage(this.loginAuthModel, this.mobileNumber);

  State<StatefulWidget> createState() => ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  Response response = Response('', 200);

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              BackNavigationButton(
                label: 'Change Password',
                isBackVisible: true,
              ),
              Padding(padding: EdgeInsets.only(top: 50.0)),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                          onChanged: (text) {},
                          labelText: widget.mobileNumber,
                          isEnable: false,
                          icon: IconView(
                            icon: Icons.smartphone,
                            size: 20,
                            color: AppColor.primaryHintColor,
                          ),
                          textFieldController: numberController,
                        ),
                        InputTextField(
                          onChanged: (text) {
                            passwordController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset: passwordController.text.length),
                            );
                          },
                          labelText: 'Password',
                          textFieldController: passwordController,
                          icon: IconView(
                            icon: Icons.password,
                            size: 20,
                            color: AppColor.primaryHintColor,
                          ),
                        ),
                        InputTextField(
                          onChanged: (text) {
                            confirmPasswordController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset:
                                      confirmPasswordController.text.length),
                            );
                          },
                          labelText: 'Confirm Password',
                          textFieldController: confirmPasswordController,
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
                              callSetPassword();
                            },
                            fontFamily: 'SemiBold',
                          ),
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

  Future<void> callSetPassword() async {
    if (passwordController.text.isEmpty) {
      Helpers.showAlertDialog('Enter password', context);
    } else if (confirmPasswordController.text.isEmpty) {
      Helpers.showAlertDialog('Enter confirm password', context);
    } else if (confirmPasswordController.text !=
        confirmPasswordController.text) {
      Helpers.showAlertDialog('Password mismatch', context);
    } else {
      Map<String, String> headerParam = {
        'Authorization': globals.accessToken,
      };
      await ApiService.getMethod(
        '${Constants.middleWareBaseUrl}/api/v1/user/changePassword/${confirmPasswordController.text}',
        context,
        headerParam: headerParam,
      ).then((result) => {
            response = result,
            if (response.statusCode == 200)
              {
                Helpers.saveStringSF(
                    'accessToken', widget.loginAuthModel.accessToken),
                Helpers.saveStringSF(
                    'refreshToken', widget.loginAuthModel.refreshToken),
                Helpers.saveStringSF(
                    'redirectTo', widget.loginAuthModel.redirectTo),
                Helpers.saveStringSF('topic', widget.loginAuthModel.topic),
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OfferPage()),
                ),
              }
          });
    }
  }
}
