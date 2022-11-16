import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/services/Helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AppColor.dart';
import 'IconView.dart';
import 'InputTextField.dart';

class CallBackDialog extends StatefulWidget {
  String header = '', labelText = '', type;

  CallBackDialog(this.type, {this.header = '', this.labelText = ''});

  State<StatefulWidget> createState() => CallBackDialogState();
}

class CallBackDialogState extends State<CallBackDialog> {
  TextEditingController numberController = TextEditingController();

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
              label: widget.header,
              fontFamily: 'SemiBold',
              textSize: 16.0,
            ),
            actions: <Widget>[
              Container(
                child: InputTextField(
                  onChanged: (text) {
                    numberController.selection = TextSelection.fromPosition(
                      TextPosition(offset: numberController.text.length),
                    );
                  },
                  labelText: widget.labelText,
                  textFieldController: numberController,
                  textInputType: TextInputType.phone,
                  textInputLength: 10,
                  icon: IconView(
                    icon: Icons.smartphone,
                    size: 20,
                    color: AppColor.primaryHintColor,
                  ),
                ),
              ),
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
                        if (numberController.text.isEmpty)
                          Helpers.showAlertDialog(
                              'Enter mobile number', context);
                        else if (numberController.text.length < 10)
                          Helpers.showAlertDialog(
                              'Enter valid number', context);
                        else
                          Navigator.pop(context);
                      },
                      label: 'SUBMIT',
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
