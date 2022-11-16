

class WatchListSearchItemModel {
  Object? id;
  String? type;
  String? token;
  String? symbol;
  String? series;
  String? name;
  String? isinNumber;

  WatchListSearchItemModel({
    this.id,
    this.type,
    this.token,
    this.symbol,
    this.series,
    this.name,
    this.isinNumber,
  });

  WatchListSearchItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    token = json['token'];
    symbol = json['symbol'];
    series = json['series'];
    name = json['name'];
    isinNumber = json['isinNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['token'] = this.token;
    data['symbol'] = this.symbol;
    data['series'] = this.series;
    data['name'] = this.name;
    data['isinNumber'] = this.isinNumber;
    return data;
  }
}
