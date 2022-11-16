import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../AppColor.dart';

class InputTextField extends StatelessWidget {
  String labelText;
  TextEditingController textFieldController;
  TextInputType textInputType;
  int textInputLength;
  int maxLine;
  int minLine;
  bool? isEnable;
  ValueChanged<String> onChanged;
  Widget? icon;
  double radius;
  bool autoFocus;
  double elevation;

  InputTextField({
    required this.labelText,
    required this.textFieldController,
    this.textInputType = TextInputType.emailAddress,
    this.textInputLength = 50,
    this.isEnable = true,
    this.icon,
    required this.onChanged,
    this.radius = 50.0,
    this.autoFocus = false,
    this.elevation=3.0,
    this.maxLine=1,
    this.minLine=1
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: new RoundedRectangleBorder(
            side: new BorderSide(color: AppColor.primaryHintColor, width: 1.0),
            borderRadius: BorderRadius.circular(radius)),
        elevation: elevation,
        shadowColor: AppColor.primaryTextColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  maxLines: maxLine,
                  minLines: minLine,
                  autofocus: autoFocus,
                  onChanged: onChanged,
                  enabled: isEnable,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(textInputLength),
                  ],
                  style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'SemiBold',
                      letterSpacing: 1.0),
                  controller: textFieldController,
                  textInputAction: TextInputAction.done,
                  keyboardType: textInputType,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    hintText: labelText,
                    hintStyle: TextStyle(
                        color: isEnable == true
                            ? AppColor.primaryHintColor
                            : AppColor.primaryDisable),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 10.0)),
              Container(child: icon),
            ],
          ),
        ),
      ),
    );
  }
}
