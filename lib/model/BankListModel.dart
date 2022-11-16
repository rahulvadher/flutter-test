class BankListModel {
  String? clientCode;
  String? bankAccountNumber;
  String? bankName;
  String? bankIfsc;

  BankListModel(
      {this.clientCode, this.bankAccountNumber, this.bankName, this.bankIfsc});

  BankListModel.fromJson(Map<String, dynamic> json) {
    clientCode = json['clientCode'];
    bankAccountNumber = json['bankAccountNumber'];
    bankName = json['bankName'];
    bankIfsc = json['bankIfsc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientCode'] = this.clientCode;
    data['bankAccountNumber'] = this.bankAccountNumber;
    data['bankName'] = this.bankName;
    data['bankIfsc'] = this.bankIfsc;
    return data;
  }
}
