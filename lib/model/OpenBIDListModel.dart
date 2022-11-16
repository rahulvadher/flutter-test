import 'OpenBIDListDataModel.dart';

class OpenBIDListModel{
  List<OpenBIDListDataModel> data=[];

  OpenBIDListModel({ required this.data});

  OpenBIDListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <OpenBIDListDataModel>[];
      json['data'].forEach((v) {
        data.add(new OpenBIDListDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}
