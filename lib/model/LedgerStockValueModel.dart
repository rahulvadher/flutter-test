class LedgerStockValueModel {
  Ledger? ledger;
  Ledger? stock;

  LedgerStockValueModel({this.ledger, this.stock});

  LedgerStockValueModel.fromJson(Map<String, dynamic> json) {
    ledger =
    json['ledger'] != null ? new Ledger.fromJson(json['ledger']) : null;
    stock = json['stock'] != null ? new Ledger.fromJson(json['stock']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ledger != null) {
      data['ledger'] = this.ledger?.toJson();
    }
    if (this.stock != null) {
      data['stock'] = this.stock?.toJson();
    }
    return data;
  }
}

class Ledger {
  double? balance;
  String? clientCode;

  Ledger({this.balance, this.clientCode});

  Ledger.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    clientCode = json['clientCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    data['clientCode'] = this.clientCode;
    return data;
  }
}