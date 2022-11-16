class BrokerageItemModel {
  String? clientCode;
  String? transactionDate;
  String? name;
  double? turnover;
  double? brokerage;

  BrokerageItemModel(
      {this.clientCode, this.transactionDate,this.name, this.turnover, this.brokerage});

  BrokerageItemModel.fromJson(Map<String, dynamic> json) {
    clientCode = json['clientCode'];
    transactionDate = json['transactionDate'];
    name = json['name'];
    turnover = json['turnover'];
    brokerage = json['brokerage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientCode'] = this.clientCode;
    data['transactionDate'] = this.transactionDate;
    data['name'] = this.name;
    data['turnover'] = this.turnover;
    data['brokerage'] = this.brokerage;
    return data;
  }
}
