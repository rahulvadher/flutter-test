library my_prj.globals;

import 'package:backoffice/model/ClientListModel.dart';
import 'package:backoffice/model/LedgerStockValueModel.dart';
import 'package:backoffice/model/WatchListModel.dart';
import 'package:flutter/material.dart';
import 'package:stomp/stomp.dart';

int codeIndex = 0;
int categoryIndex = 0;
int wlTabSelected = 0;
String accessToken = '';
String token = '';
List<ClientListModel> clientList = [];
List<WatchListModel> watchList = [];
LedgerStockValueModel singleValue = new LedgerStockValueModel();
ClientListModel singleBranch = new ClientListModel();
StompClient? stompClient;
String backgroundImage = "assets/image/homevideo.mp4";
Color backgroundColor = Color(0xFF1B61C9), foregroundColor = Color(0xFFFFFFFF);
