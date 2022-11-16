import 'package:backoffice/AppColor.dart';
import 'package:backoffice/components/BackNavigationButton.dart';
import 'package:backoffice/components/DropDown.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Picker.dart';
import 'package:backoffice/components/RadioButton.dart';
import 'package:backoffice/components/SubmitButton.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/services/Helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../services/globals.dart' as globals;
class DematHoldingTransactionStatementPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      DematHoldingTransactionStatementPageState();
}

class DematHoldingTransactionStatementPageState
    extends State<DematHoldingTransactionStatementPage> {
  int _value = 1;
  String selectFromDate = Helpers.currentDate(isFrom: true);
  String selectToDate = Helpers.currentDate();
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
                      label: 'Demat Holding & Transaction Statement',
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                      children: [
                        LabelTextField(
                          onPressed: () {},
                          label: 'From: ',
                          textColor: AppColor.secondaryTextColor,
                        ),
                        LabelTextField(
                          onPressed: () async {         await Helpers.selectDate(context, DateTime.now().subtract(Duration(days: 1)),DateTime.now().add(new Duration(days: 30)))
                              .then((value) => selectFromDate = value);
                          setState(() {});},
                          label: selectFromDate,
                          textColor: AppColor.secondaryTextColor,
                        ),
                      ],
                    ),
                   Row(
                      children: [
                        LabelTextField(
                          onPressed: () {},
                          label: 'To: ',
                          textColor: AppColor.secondaryTextColor,
                        ),
                        LabelTextField(
                          onPressed: () async {       await Helpers.selectDate(context, DateTime.now().subtract(Duration(days: 1)),DateTime.now().add(new Duration(days: 30)))
                              .then((value) => selectToDate = value);
                          setState(() {});},
                          label: selectToDate,
                          textColor: AppColor.secondaryTextColor,
                        ),
                      ],
                    ),
                ],
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
