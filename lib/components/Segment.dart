import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AppColor.dart';

class Segment extends StatelessWidget {
  int currentIndex, selectedIndex;
  TabController tabController;
  GestureTapCallback onPressed;
  String labelText;

  Segment({
    required this.onPressed,
    required this.currentIndex,
    required this.selectedIndex,
    required this.tabController,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 2.0, right: 2.0),
      child: new TextButton(
        style: TextButton.styleFrom(
          backgroundColor: currentIndex == selectedIndex
              ? AppColor.primaryTextColor
              : Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
        onPressed: onPressed,
        child: new Text(
          labelText,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 12.0,
              color: AppColor.secondaryTextColor,
              fontFamily: 'SemiBold'),
        ),
      ),
    );
  }
}
