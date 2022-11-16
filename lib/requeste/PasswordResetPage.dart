import 'package:backoffice/AppColor.dart';
import 'package:backoffice/components/BackNavigationButton.dart';
import 'package:backoffice/components/DropDown.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Picker.dart';
import 'package:backoffice/components/RadioButton.dart';
import 'package:backoffice/components/SubmitButton.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../services/globals.dart' as globals;

class PasswordResetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PasswordResetPageState();
}

class PasswordResetPageState extends State<PasswordResetPage> {
  int group1 = 1;
  ClientListModel singleClient = new ClientListModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    singleClient = globals.clientList[globals.codeIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: BackNavigationButton(
                      label: 'Password Reset',
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
              Padding(padding: EdgeInsets.only(top: 30.0)),
              Row(
                children: [
                  Expanded(
                    child: RadioButton<int>(
                      value: 1,
                      groupValue: group1,
                      leading: 'A',
                      title: Expanded(
                        child: LabelTextField(
                          label: 'Mobile Trading',
                          textColor: AppColor.secondaryTextColor,
                        ),
                      ),
                      onChanged: (value) => setState(() => group1 = value!),
                    ),
                  ),
                  Expanded(
                    child: RadioButton<int>(
                      value: 2,
                      groupValue: group1,
                      leading: 'A',
                      title: Flexible(
                        child: LabelTextField(
                          label: 'Mutual Fund Web Backoffice',
                          textColor: AppColor.secondaryTextColor,
                        ),
                      ),
                      onChanged: (value) => setState(() => group1 = value!),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioButton<int>(
                      value: 3,
                      groupValue: group1,
                      leading: 'A',
                      title: Expanded(
                        child: LabelTextField(
                          label: 'Odin Diet',
                          textColor: AppColor.secondaryTextColor,
                        ),
                      ),
                      onChanged: (value) => setState(() => group1 = value!),
                    ),
                  ),
                  Expanded(
                    child: RadioButton<int>(
                      value: 4,
                      groupValue: group1,
                      leading: 'A',
                      title: LabelTextField(
                        label: 'Web Backoffice',
                        textColor: AppColor.secondaryTextColor,
                      ),
                      onChanged: (value) => setState(() => group1 = value!),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: SubmitButton(
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
