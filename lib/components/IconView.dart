import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AppColor.dart';

class IconView extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color color;

  const IconView(
      {required this.icon,
      this.size = 25.0,
      this.color = AppColor.primaryColor});

  State<StatefulWidget> createState() => IconViewState();
}

class IconViewState extends State<IconView> {
  late String header;
  late bool isBackVisible;

  @override
  Widget build(BuildContext context) {
    return Icon(
      widget.icon,
      size: widget.size,
      color: widget.color,
    );
  }
}
