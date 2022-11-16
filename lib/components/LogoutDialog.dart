import 'package:backoffice/components/LabelTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AppColor.dart';

class LogoutDialog extends StatefulWidget {
  State<StatefulWidget> createState() => LogoutDialogState();
}

class LogoutDialogState extends State<LogoutDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            title: LabelTextField(
              onPressed: () {},
              label: 'Are you sure want to logout?',
              fontFamily: 'SemiBold',
              textSize: 16.0,
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: LabelTextField(
                      alignment: Alignment.topRight,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      label: 'CANCEL',
                      fontFamily: 'SemiBold',
                      textColor: AppColor.primaryAlertColor,
                      textSize: 16.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: LabelTextField(
                      onPressed: () {
                        Navigator.pop(context, "Logout");
                      },
                      label: 'YES',
                      fontFamily: 'SemiBold',
                      textColor: AppColor.primaryColor,
                      textSize: 16.0,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
