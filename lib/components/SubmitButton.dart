import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../AppColor.dart';

class SubmitButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String label, fontFamily;
  final Color? backGroundColor, textColor,shadowColors;
  final double borderWidth;

  SubmitButton({
    required this.onPressed,
    this.label = 'Submit',
    this.backGroundColor = AppColor.primaryColor,
    this.textColor = AppColor.primaryTextColor,
    this.fontFamily = 'Regular',
    this.borderWidth = 1.0,
    this.shadowColors = AppColor.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: EdgeInsets.only(right: 0.0),
          child: Card(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                side: new BorderSide(color: AppColor.primaryColor, width: borderWidth),
                borderRadius: BorderRadius.circular(50.0)),
            shadowColor: shadowColors,
            color: backGroundColor,
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 7.0),
                    child: new Text(
                      label,
                      maxLines: 1,
                      style: TextStyle(
                          color: textColor,
                          fontFamily: fontFamily,
                          fontSize: 15.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
