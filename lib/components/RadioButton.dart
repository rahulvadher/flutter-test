import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../AppColor.dart';

class RadioButton<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String leading;
  final Widget? title;
  final ValueChanged<T?> onChanged;

  const RadioButton({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.leading,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _customRadioButton,
            SizedBox(
              width: 10,
              height: 30,
            ),
            if (title != null) title,
          ],
        ),
      ),
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;
    return Container(
      width: 20.0,
      height: 20.0,
      decoration: BoxDecoration(
        color: AppColor.primaryTextColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.primaryColor, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Container(
            decoration: BoxDecoration(
          color: isSelected
              ? AppColor.primaryColor
              : AppColor.primaryTextColor,
          borderRadius: BorderRadius.circular(20),
        )),
      ),
    );
  }
}
