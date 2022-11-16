class LedgerModel {
  String? clientCode;
  String? voucherDate;
  String? naration;
  String? billNo;
  String? effectiveDate;
  double? debit;
  double? credit;
  String? exchange;
  String? product;
  String? segment;

  LedgerModel(
      {this.clientCode,
        this.voucherDate,
        this.naration,
        this.billNo,
        this.effectiveDate,
        this.debit,
        this.credit,
        this.exchange,
        this.product,
        this.segment});

  LedgerModel.fromJson(Map<String, dynamic> json) {
    clientCode = json['clientCode'];
    voucherDate = json['voucherDate'];
    naration = json['naration'];
    billNo = json['billNo'];
    effectiveDate = json['effectiveDate'];
    debit = json['debit'];
    credit = json['credit'];
    exchange = json['exchange'];
    product = json['product'];
    segment = json['segment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientCode'] = this.clientCode;
    data['voucherDate'] = this.voucherDate;
    data['naration'] = this.naration;
    data['billNo'] = this.billNo;
    data['effectiveDate'] = this.effectiveDate;
    data['debit'] = this.debit;
    data['credit'] = this.credit;
    data['exchange'] = this.exchange;
    data['product'] = this.product;
    data['segment'] = this.segment;
    return data;
  }
}