import 'dart:convert';

import 'package:backoffice/services/Helpers.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<dynamic> getMethod(String url, BuildContext context,
      {Map<String, String>? headerParam, bool isShowLoader = false}) async {
    if (isShowLoader) Helpers.shodLoader(context);
    var responseJson;
    try {
      final response = await http.get(Uri.parse(url), headers: headerParam);
      responseJson = _returnResponse(response, context, isShowLoader);
    } on Exception catch (e) {
      print('error caught: $e');
    }
    return responseJson;
  }

  static Future<dynamic> getDeleteMethod(String url, BuildContext context,
      {Map<String, String>? headerParam, bool isShowLoader = false}) async {
    if (isShowLoader) Helpers.shodLoader(context);
    var responseJson;
    try {
      final response = await http.delete(Uri.parse(url), headers: headerParam);
      responseJson = _returnResponse(response, context, isShowLoader);
    } on Exception catch (e) {
      print('error caught: $e');
    }
    return responseJson;
  }

  static Future<dynamic> getPutMethod(String url, BuildContext context,
      {Object? bodyParam,
      Map<String, String>? headerParam,
      bool isShowLoader = false}) async {
    if (isShowLoader) Helpers.shodLoader(context);
    var responseJson;
    try {
      final response =
          await http.put(Uri.parse(url), headers: headerParam, body: bodyParam);
      responseJson = _returnResponse(response, context, isShowLoader);
    } on Exception catch (e) {
      print('error caught: $e');
    }
    return responseJson;
  }

  static Future<dynamic> postMethod(String url, BuildContext context,
      {Object? bodyParam,
      Map<String, String>? headerParam,
      bool isShowLoader = false}) async {
    if (isShowLoader) Helpers.shodLoader(context);
    var responseJson;
    try {
      final response = await http.post(Uri.parse(url),
          body: bodyParam, headers: headerParam);
      responseJson = _returnResponse(response, context, isShowLoader);
    } on Exception catch (e) {
      print('error caught: $e');
    }
    return responseJson;
  }

  static dynamic _returnResponse(
      http.Response response, BuildContext context, bool isShowLoader) {
    if (isShowLoader) Navigator.pop(context);
    print(response.body);
    switch (response.statusCode) {
      case 200:
        return response;
      default:
        {
          var json = jsonDecode(response.body);
          Helpers.showAlertDialog(
              json['error_description'] != null
                  ? json['error_description']
                  : 'Something Wrong',
              context);
          return response;
        }
    }
  }
}
