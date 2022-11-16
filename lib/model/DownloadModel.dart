import 'package:backoffice/model/DownloadItemModel.dart';

class DownloadModel {
  List<DownloadItemModel> content=[];
  int? numberOfElements;
  bool? last;
  DownloadModel({required this.content, this.numberOfElements});

  DownloadModel.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <DownloadItemModel>[];
      json['content'].forEach((v) {
        content.add(new DownloadItemModel.fromJson(v));
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
