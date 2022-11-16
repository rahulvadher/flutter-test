import 'package:backoffice/AppColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/globals.dart' as globals;
import 'IconView.dart';
import 'LabelTextField.dart';

class Picker extends StatefulWidget {
  String selectedValue = '';
  bool isMore =false;

  Picker(this.selectedValue,{this.isMore=false});

  State<StatefulWidget> createState() => PickerState();
}

class PickerState extends State<Picker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LabelTextField(
          label: widget.selectedValue,
          fontFamily: 'Bold',
          textSize: 22.0,
          textColor: widget.isMore?globals.foregroundColor:AppColor.primaryColor,
        ),
        IconView(
          icon: Icons.arrow_drop_down_sharp,
          size: 40,
          color: widget.isMore?globals.foregroundColor:AppColor.primaryColor,
        ),
      ],
    );
  }
}
