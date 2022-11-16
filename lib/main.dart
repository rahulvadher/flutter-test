// @dart=2.9

import 'dart:io';
import 'dart:ui';

import 'package:backoffice/OfferPage.dart';
import 'package:backoffice/services/ConnectivityService.dart';
import 'package:backoffice/services/ConnectivityStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'AppColor.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    accentColor: Colors.white,
    accentIconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
  );

  final lightTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFE5E5E5),
    accentColor: Colors.black,
    accentIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.white54,
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return StreamProvider<ConnectivityStatus>(
        initialData: ConnectivityStatus.Wifi,
        create: (context) =>
            ConnectivityService().connectionStatusController.stream,
        child: MaterialApp(
        /*  darkTheme: ThemeData(
            brightness: Brightness.dark,
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: AppColor.secondaryTextColor,
              selectedItemColor: AppColor.primaryTextColor,
            ),
            cardTheme: CardTheme(elevation: 2.0),
            textTheme: TextTheme(
              subtitle1: TextStyle(color: AppColor.primaryTextColor),
            ),

          ),
          theme: ThemeData(
            brightness: Brightness.light,
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: AppColor.primaryTextColor,
              selectedItemColor: AppColor.primaryColor,
            ),
            cardTheme: CardTheme(elevation: 5.0),
            textTheme: TextTheme(
              subtitle1: TextStyle(color: AppColor.secondaryTextColor),
            ),
          ),
          themeMode: ThemeMode.system,*/
          home: OfferPage(),
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return MediaQuery(
                child: child,
                data: MediaQuery.of(context).copyWith(
                    textScaleFactor:
                        MediaQuery.of(context).size.width * 0.0025));
          },
        ));
  }
}
