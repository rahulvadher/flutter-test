import 'package:backoffice/model/ClientListModel.dart';

class ClientListBSModel {
  List<ClientListModel> content = [];
  int? totalElements=0;
  bool? last;

  ClientListBSModel({required this.content,this.totalElements=0});

  ClientListBSModel.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <ClientListModel>[];
      json['content'].forEach((v) {
        content.add(new ClientListModel.fromJson(v));
      });
    }
    totalElements = json['totalElements'];
    last = json['last'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content.map((v) => v.toJson()).toList();
    data['totalElements'] = this.totalElements;
    data['last'] = this.last;
    return data;
  }
}
