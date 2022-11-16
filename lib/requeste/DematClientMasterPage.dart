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
class DematClientMasterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DematClientMasterPageState();
}

class DematClientMasterPageState extends State<DematClientMasterPage> {
  int _value = 1;
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
                      label: 'Demat Client Master',
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
              LabelTextField(
                label: 'I want Demat Client Master copy for my ${singleClient.clientCode} client code.',
                textSize: 16.0,
                textColor: AppColor.secondaryTextColor,
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RadioButton<int>(
                    value: 1,
                    groupValue: _value,
                    leading: 'A',
                    title: LabelTextField(
                      onPressed: () {},
                      label: 'By Email',
                      textColor: AppColor.secondaryTextColor,
                    ),
                    onChanged: (value) => setState(() => _value = value!),
                  ),
                  RadioButton<int>(
                    value: 2,
                    groupValue: _value,
                    leading: 'A',
                    title: LabelTextField(
                      label: 'By Post',
                      textColor: AppColor.secondaryTextColor,
                    ),
                    onChanged: (value) => setState(() => _value = value!),
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
