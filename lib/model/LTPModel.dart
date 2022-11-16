class LTPModel {
  double? price;
  double? highPrice;
  double? lowPrice;
  double? openPrice;
  double? closingPrice;

  LTPModel({
    this.price,
    this.highPrice,
    this.lowPrice,
    this.openPrice,
    this.closingPrice,
  });

  LTPModel.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    highPrice = json['highPrice'];
    lowPrice = json['lowPrice'];
    openPrice = json['openPrice'];
    closingPrice = json['closingPrice'];
  }
}
