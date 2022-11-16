import 'package:backoffice/model/ClientListModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/globals.dart' as globals;
import '../AppColor.dart';
import 'LabelTextField.dart';
import 'SubmitButton.dart';

class DropDown extends StatefulWidget {
  List<ClientListModel> pickerData;

  DropDown({required this.pickerData});

  State<StatefulWidget> createState() => DropDownState();
}

int tempIndex = 0;

class DropDownState extends State<DropDown> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          Card(
            margin: EdgeInsets.symmetric(horizontal: 30.0),
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            shadowColor: AppColor.primaryColor,
            child: Column(
              children: [
                Container(
                  height: 200,
                  child: CupertinoPicker(
                      itemExtent: 32.0,
                      backgroundColor: Colors.transparent,
                      scrollController: new FixedExtentScrollController(
                        initialItem: globals.codeIndex,
                      ),
                      useMagnifier: true,
                      onSelectedItemChanged: (int index) {
                        tempIndex = index;
                      },
                      children: new List<Widget>.generate(
                          widget.pickerData.length, (int index) {
                        return new Center(
                          child: new LabelTextField(
                            alignment: Alignment.center,
                            fontFamily: 'SemiBold',
                            textSize: 18.0,
                            label: widget.pickerData[index].clientCode ?? '',
                          ),
                        );
                      })),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0 ,horizontal: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      LabelTextField(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        label: 'CANCEL',
                        fontFamily: 'SemiBold',
                        textSize: 16.0,
                        textColor: AppColor.primaryAlertColor,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: LabelTextField(
                          onPressed: () {
                            globals.codeIndex = tempIndex;
                            Navigator.pop(
                                context, widget.pickerData[globals.codeIndex]);
                          },
                          label: 'OK',
                          textSize: 16.0,
                          fontFamily: 'SemiBold',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
