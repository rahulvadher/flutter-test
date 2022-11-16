import 'package:backoffice/model/OpenBIDListDataModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AppColor.dart';
import 'LabelTextField.dart';
import '../services/globals.dart' as globals;
class IPOCategoryDropDown extends StatefulWidget {
  List<Category>? pickerData;
  IPOCategoryDropDown({required this.pickerData});
  State<StatefulWidget> createState() => IPOCategoryDropDownState();
}

int tempIndex = 0;

class IPOCategoryDropDownState extends State<IPOCategoryDropDown> {
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
                        initialItem: globals.categoryIndex,
                      ),
                      useMagnifier: true,
                      onSelectedItemChanged: (int index) {
                        tempIndex = index;
                      },
                      children: new List<Widget>.generate(
                          widget.pickerData!.length, (int index) {
                        return new Center(
                          child: new LabelTextField(
                            alignment: Alignment.center,
                            fontFamily: 'SemiBold',
                            textSize: 18.0,
                            label: widget.pickerData![index].code ?? '',
                          ),
                        );
                      })),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
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
                            globals.categoryIndex = tempIndex;
                            Navigator.pop(
                                context, widget.pickerData![globals.categoryIndex]);
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
