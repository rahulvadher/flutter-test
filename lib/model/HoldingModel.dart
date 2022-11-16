class HoldingModel {
  String? scriptCode;
  String? scriptISIN;
  double? scriptQty;
  String? scriptSeries;
  String? scriptName;
  double? scriptPrice;
  double? scriptValue;

  HoldingModel({
    this.scriptCode,
    this.scriptISIN,
    this.scriptQty,
    this.scriptSeries,
    this.scriptName,
    this.scriptPrice,
    this.scriptValue,
  });

  HoldingModel.fromJson(Map<String, dynamic> json) {
    scriptCode = json['scriptCode'];
    scriptISIN = json['scriptISIN'];
    scriptQty = json['scriptQty'];
    scriptSeries = json['scriptSeries'];
    scriptName = json['scriptName'];
    scriptPrice = json['scriptPrice'];
    scriptValue = json['scriptValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scriptCode'] = this.scriptCode;
    data['scriptISIN'] = this.scriptISIN;
    data['scriptQty'] = this.scriptQty;
    data['scriptSeries'] = this.scriptSeries;
    data['scriptName'] = this.scriptName;
    data['scriptPrice'] = this.scriptPrice;
    data['scriptValue'] = this.scriptValue;
    return data;
  }
}
