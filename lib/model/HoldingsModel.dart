class HoldingsModel {
  String mobileNumber = "";
  String clientCode = "";
  String scripCode = "";
  String scripName = "";
  String demat = "";
  String pool = "";
  String rate = "";
  String symbol = "";
  String pledge = "";

  HoldingsModel(
      {this.mobileNumber = "",
      this.clientCode = "",
      this.scripCode = "",
      this.scripName = "",
      this.demat = "",
      this.pool = "",
      this.rate = "",
      this.symbol = "",
      this.pledge = ""});

  HoldingsModel.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['1'];
    clientCode = json['2'];
    scripCode = json['3'];
    scripName = json['4'];
    demat = json['5'];
    pool = json['6'];
    rate = json['7'];
    symbol = json['8'];
    pledge = json['9'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.mobileNumber;
    data['2'] = this.clientCode;
    data['3'] = this.scripCode;
    data['4'] = this.scripName;
    data['5'] = this.demat;
    data['6'] = this.pool;
    data['7'] = this.rate;
    data['8'] = this.symbol;
    data['9'] = this.pledge;
    return data;
  }
}
