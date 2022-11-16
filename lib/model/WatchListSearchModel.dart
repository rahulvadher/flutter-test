
import 'WatchListSearchItemModel.dart';

class WatchListSearchModel {
  List<WatchListSearchItemModel> content = [];
  bool? last;
  WatchListSearchModel({required this.content});

  WatchListSearchModel.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <WatchListSearchItemModel>[];
      json['content'].forEach((v) {
        content.add(new WatchListSearchItemModel.fromJson(v));
      });
    }
    last = json['last'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content.map((v) => v.toJson()).toList();
    data['last'] = this.last;
    return data;
  }
}
