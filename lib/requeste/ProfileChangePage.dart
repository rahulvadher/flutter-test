import 'package:backoffice/AppColor.dart';
import 'package:backoffice/components/BackNavigationButton.dart';
import 'package:backoffice/components/DropDown.dart';
import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Picker.dart';
import 'package:backoffice/components/SubmitButton.dart';
import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/services/Helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../services/globals.dart' as globals;

class ProfileChangePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfileChangePageState();
}

class ProfileChangePageState extends State<ProfileChangePage> {
  String selectFromDate = Helpers.currentDate(isFrom: true);
  String selectToDate = Helpers.currentDate();

  Map<String, bool> changeValue = {
    'Mobile ': false,
    'Email': false,
    'Address': false,
    'Nominee': false,
    'Demat': false,
    'Segment Addtion': false,
    'Bank': false,
    'Other': false,
  };
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
                      label: 'Profile Change',
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
              Container(
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    GridView(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150.0,
                        childAspectRatio: 3.0,
                        mainAxisSpacing: 5.0,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: changeValue.keys.map(
                        (String key) {
                          return Row(
                            children: <Widget>[
                              Checkbox(
                                activeColor: AppColor.primaryColor,
                                checkColor: AppColor.primaryTextColor,
                                value: changeValue[key],
                                onChanged: (bool? value) {
                                  setState(() {
                                    changeValue[key] = value!;
                                  });
                                },
                              ),
                              Flexible(
                                child: LabelTextField(
                                  alignment: Alignment.centerLeft,
                                  label: key,
                                  textColor: AppColor.secondaryTextColor,
                                ),
                              ),
                            ],
                          );
                        },
                      ).toList(),
                    ),
                    // ...... other list children.
                  ],
                ),
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
