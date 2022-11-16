class PositionModel {
  String? scriptCode;
  String? scriptName;
  double? scriptPrice;
  double? scriptValue;
  double? scriptQty;
  String? featureOption;
  String? expiryDate;
  double? strikePrice;
  String? optionType;
  String? type;

  PositionModel(
      {this.scriptCode,
        this.scriptName,
        this.scriptPrice,
        this.scriptValue,
        this.scriptQty,
        this.featureOption,
        this.expiryDate,
        this.strikePrice,
        this.optionType,
        this.type});

  PositionModel.fromJson(Map<String, dynamic> json) {
    scriptCode = json['scriptCode'];
    scriptName = json['scriptName'];
    scriptPrice = json['scriptPrice'];
    scriptValue = json['scriptValue'];
    scriptQty = json['scriptQty'];
    featureOption = json['featureOption'];
    expiryDate = json['expiryDate'];
    strikePrice = json['strikePrice'];
    optionType = json['optionType'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scriptCode'] = this.scriptCode;
    data['scriptName'] = this.scriptName;
    data['scriptPrice'] = this.scriptPrice;
    data['scriptValue'] = this.scriptValue;
    data['scriptQty'] = this.scriptQty;
    data['featureOption'] = this.featureOption;
    data['expiryDate'] = this.expiryDate;
    data['strikePrice'] = this.strikePrice;
    data['optionType'] = this.optionType;
    data['type'] = this.type;
    return data;
  }
}