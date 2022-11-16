class TradeListModel {
  String eqFutOpt = '';
  double strikePrice = 0.0;
  String expiry = '';
  String optionType = '';
  int qty = 0;
  double price = 0.0;
  String buy = '';
  String tradeTime = '';
  int tradeNo = 0;

  TradeListModel(
      {this.eqFutOpt = '',
      this.strikePrice = 0.0,
      this.expiry = '',
      this.optionType = '',
      this.qty = 0,
      this.price = 0.0,
      this.buy = '',
      this.tradeTime = '',
      this.tradeNo = 0});

  TradeListModel.fromJson(Map<String, dynamic> json) {
    eqFutOpt = json['eqFutOpt'];
    strikePrice = json['strikePrice'];
    expiry = json['expiry'];
    optionType = json['optionType'];
    qty = json['qty'];
    price = json['price'];
    buy = json['buy'];
    tradeTime = json['tradeTime'];
    tradeNo = json['tradeNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eqFutOpt'] = this.eqFutOpt;
    data['strikePrice'] = this.strikePrice;
    data['expiry'] = this.expiry;
    data['optionType'] = this.optionType;
    data['qty'] = this.qty;
    data['price'] = this.price;
    data['buy'] = this.buy;
    data['tradeTime'] = this.tradeTime;
    data['tradeNo'] = this.tradeNo;
    return data;
  }
}
