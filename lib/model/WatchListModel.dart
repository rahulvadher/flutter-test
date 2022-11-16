import 'LTPModel.dart';

class WatchListModel {
  Object? id;
  String? clientCode;
  String? type;
  Object? token;
  String? symbol;
  String? series;
  String? name;
  String? isinNumber;
  String? subTitle;
  LTPModel? oldLTP;
  LTPModel? newLTP;
  bool isVisible = false;
  double? openPrice;
  double? highPrice;
  double? lowPrice;
  double? closingPrice;
  double? previousClosePrice;
  double? fiftyTwoWeekHigh;
  double? fiftyTwoWeekLow;
  double? price;

  WatchListModel({
    this.id,
    this.clientCode,
    this.type,
    this.token,
    this.symbol,
    this.series,
    this.name,
    this.isinNumber,
    this.subTitle,
    this.oldLTP,
    this.newLTP,
    this.isVisible = false,
    this.openPrice,
    this.highPrice,
    this.lowPrice,
    this.closingPrice,
    this.previousClosePrice,
    this.fiftyTwoWeekHigh,
    this.fiftyTwoWeekLow,
    this.price,
  });

  WatchListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientCode = json['clientCode'];
    type = json['type'];
    token = json['token'];
    symbol = json['symbol'];
    series = json['series'];
    name = json['name'];
    isinNumber = json['isinNumber'];
    subTitle = json['subTitle'];
    openPrice = json['openPrice'];
    highPrice = json['highPrice'];
    lowPrice = json['lowPrice'];
    closingPrice = json['closingPrice'];
    previousClosePrice = json['previousClosePrice'];
    fiftyTwoWeekHigh = json['fiftyTwoWeekHigh'];
    fiftyTwoWeekLow = json['fiftyTwoWeekLow'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['clientCode'] = this.clientCode;
    data['type'] = this.type;
    data['token'] = this.token;
    data['symbol'] = this.symbol;
    data['series'] = this.series;
    data['name'] = this.name;
    data['isinNumber'] = this.isinNumber;
    data['subTitle'] = this.subTitle;
    data['openPrice'] = this.openPrice;
    data['highPrice'] = this.highPrice;
    data['lowPrice'] = this.lowPrice;
    data['closingPrice'] = this.closingPrice;
    data['previousClosePrice'] = this.previousClosePrice;
    data['fiftyTwoWeekHigh'] = this.fiftyTwoWeekHigh;
    data['fiftyTwoWeekLow'] = this.fiftyTwoWeekLow;
    data['price'] = this.price;
    return data;
  }
}
