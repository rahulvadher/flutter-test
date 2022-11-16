class PureRiskItemModel {
  String? clientCode;
  String? clientName;
  double? pureRisk;

  PureRiskItemModel(
      {this.clientCode, this.clientName, this.pureRisk});

  PureRiskItemModel.fromJson(Map<String, dynamic> json) {
    clientCode = json['clientCode'];
    clientName = json['clientName'];
    pureRisk = json['pureRisk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientCode'] = this.clientCode;
    data['clientName'] = this.clientName;
    data['pureRisk'] = this.pureRisk;
    return data;
  }
}
