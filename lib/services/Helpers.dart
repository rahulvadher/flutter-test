import 'package:backoffice/components/LabelTextField.dart';
import 'package:backoffice/components/Loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../AppColor.dart';

class Helpers {
  static Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  static String changeDateFormat(
      String inputDate, String inputDateFormat, String expectedDateFormat) {
    return new DateFormat(expectedDateFormat)
        .format(new DateFormat(inputDateFormat).parse(inputDate));
  }

  static String currentDate({bool? isFrom}) {
    DateTime dateTime;
    if (isFrom != null && isFrom) {
      dateTime = DateTime.now().subtract(new Duration(days: 30));
    } else {
      dateTime = DateTime.now();
    }
    return new DateFormat('dd-MM-yyyy').format(dateTime);
  }

  static launchURL(String url, {bool forceWebView=false}) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: forceWebView);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<String> selectDate(
      BuildContext context, DateTime firstDate, DateTime lastDate) async {
    final newDateTime = await showRoundedDatePicker(
      initialDate: DateTime.now(),
      firstDate:firstDate,
      lastDate:lastDate,
      context: context,
      height: MediaQuery.of(context).size.height / 2,
      styleDatePicker: MaterialRoundedDatePickerStyle(
        textStyleButtonNegative: TextStyle(
            fontSize: 16.0,
            color: AppColor.primaryAlertColor,
            fontFamily: 'SemiBold'),
        textStyleButtonPositive: TextStyle(
            fontSize: 16.0,
            color: AppColor.primaryColor,
            fontFamily: 'SemiBold'),
        paddingMonthHeader: EdgeInsets.all(10.0),
        textStyleDayButton: TextStyle(
            fontSize: 18.0,
            color: AppColor.primaryTextColor,
            fontFamily: 'SemiBold'),
        textStyleYearButton: TextStyle(
          fontSize: 18.0,
          color: AppColor.primaryTextColor,
          fontFamily: 'SemiBold',
        ),
        textStyleMonthYearHeader: TextStyle(
          fontSize: 18.0,
          color: AppColor.secondaryTextColor,
          fontFamily: 'SemiBold',
        ),
      ),
      theme: ThemeData(
        primaryColor: AppColor.primaryColor,
        accentColor: AppColor.primaryColor,
        dialogBackgroundColor: AppColor.primaryTextColor,
        textTheme: TextTheme(
          bodyText2: TextStyle(
              color: AppColor.secondaryTextColor, fontFamily: 'SemiBold'),
          caption:
              TextStyle(color: AppColor.primaryColor, fontFamily: 'SemiBold'),
        ),
        disabledColor: AppColor.primaryHintColor.withOpacity(0.60),
        accentTextTheme: TextTheme(
          bodyText1: TextStyle(
              color: AppColor.primaryTextColor, fontFamily: 'SemiBold'),
        ),
      ),
    );
    if (newDateTime != null) {
      return DateFormat('dd-MM-yyyy').format(newDateTime);
    } else
      return DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  static showAlert(String alertMessage, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppColor.primaryAlertColor,
      content: Text(
        alertMessage,
        style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'Montserrat-light',
            fontWeight: FontWeight.w700),
      ),
    ));
  }

  static Future<void> showAlertDialog(
      String alertMessage, BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Wrap(
            children: [
              AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                title: LabelTextField(
                  fontFamily: 'SemiBold',
                  textSize: 16.0,
                  label: alertMessage,
                  textColor: AppColor.secondaryTextColor,
                ),
                actions: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: LabelTextField(
                      alignment: Alignment.topRight,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      label: 'OK',
                      fontFamily: 'SemiBold',
                      textSize: 16.0,
                      textColor: AppColor.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> shodLoader(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Wrap(
            children: [
              Loader(),
            ],
          ),
        );
      },
    );
  }

  static saveStringSF(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String?> getStringSF(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(key) ?? null);
  }

  static clearSF() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
