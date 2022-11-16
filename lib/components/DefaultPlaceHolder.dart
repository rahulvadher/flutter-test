import 'package:backoffice/components/LabelTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DefaultPlaceHolder extends StatelessWidget {
  final String placeHolderImage, headerText, subHeaderText;

  DefaultPlaceHolder({
    this.placeHolderImage = 'assets/image/norecord.png',
    this.headerText = 'Header Text',
    this.subHeaderText = 'Sub Header Text',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(placeHolderImage),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: LabelTextField(
            label: headerText,
            alignment: Alignment.center,
            fontFamily: "Bold",
            textSize: 20.0,
          ),
        ),
        LabelTextField(
          alignment: Alignment.center,
          label: subHeaderText,
        )
      ],
    ));
  }
}
