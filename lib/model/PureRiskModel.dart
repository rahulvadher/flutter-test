import 'PureRiskItemModel.dart';

class PureRiskModel {
  List<PureRiskItemModel> content=[];
  int? numberOfElements;
  bool? last;
  PureRiskModel({required this.content, this.numberOfElements});

  PureRiskModel.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <PureRiskItemModel>[];
      json['content'].forEach((v) {
        content.add(new PureRiskItemModel.fromJson(v));
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
