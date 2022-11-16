import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import '../AppColor.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          Column(
            children: [
              SvgPicture.asset(
                'assets/image/ic_logo.svg',
                height: 50.0,
                width: 50.0,
              ),
              SpinKitThreeBounce(
                color: AppColor.primaryColor,
                size: 20.0,
              ),
            ],
          )
        ],
      ),
    );
  }
}
