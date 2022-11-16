import 'package:backoffice/model/BrokerageItemModel.dart';

class BrokerageModel {
  List<BrokerageItemModel> content=[];
  int? numberOfElements;
  bool? last;
  BrokerageModel({required this.content, this.numberOfElements});

  BrokerageModel.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <BrokerageItemModel>[];
      json['content'].forEach((v) {
        content.add(new BrokerageItemModel.fromJson(v));
      });
    }
    numberOfElements = json['numberOfElements'];
    last = json['last'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content.map((v) => v.toJson()).toList();
    data['numberOfElements'] = this.numberOfElements;
    data['last'] = this.last;
    return data;
  }
}
