import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/services/Helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AppColor.dart';
import 'IconView.dart';
import 'InputTextField.dart';

class SuggestionFeedbackDialog extends StatefulWidget {
  String header = '', labelText = '', type;

  SuggestionFeedbackDialog(this.type, {this.header = '', this.labelText = ''});

  State<StatefulWidget> createState() => SuggestionFeedbackDialogState();
}

class SuggestionFeedbackDialogState extends State<SuggestionFeedbackDialog> {
  TextEditingController textController = TextEditingController();

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
              InputTextField(
                onChanged: (text) {
                  textController.selection = TextSelection.fromPosition(
                    TextPosition(offset: textController.text.length),
                  );
                },
                labelText: widget.labelText,
                textFieldController: textController,
                textInputLength: 100,
                maxLine: 5,
                minLine: 3,
                radius: 10.0,
                textInputType: TextInputType.multiline,
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
                        if (textController.text.isEmpty)
                          Helpers.showAlertDialog('Enter text', context);
                        else if (textController.text.length < 10)
                          Helpers.showAlertDialog('Enter more text', context);
                        else
                          Navigator.of(context).pop();
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
