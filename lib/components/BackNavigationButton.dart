
import 'package:backoffice/components/LabelTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AppColor.dart';
import 'IconView.dart';

class BackNavigationButton extends StatefulWidget {
  final String label;
  final bool isBackVisible;

  const
  BackNavigationButton(
      {this.label = '', this.isBackVisible = false});

  State<StatefulWidget> createState() => BackNavigationButtonState();
}

class BackNavigationButtonState extends State<BackNavigationButton> {
  late String header;
  late bool isBackVisible;

  @override
  void initState() {
    super.initState();
    setState(() {
      this.header = widget.label;
      this.isBackVisible = widget.isBackVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isBackVisible)
      return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          children: [
            IconView(
              icon: Icons.arrow_back_ios_outlined,
              color: AppColor.primaryColor,
            ),
            Flexible(

              child: LabelTextField(
                label: header,
                fontFamily: 'SemiBold',
                overflow: TextOverflow.ellipsis,
                textSize: 18.0,
              ),
            ),
          ],
        ),
      );
    else {
      return Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: EdgeInsets.only(left: 0.0, top: 0.0, bottom: 10.0),
          // alignment: Alignment.center,
          child:  LabelTextField(
            label: header,
            fontFamily: 'SemiBold',
            textSize: 18.0,
          ),
        ),
      );
    }
  }
}
