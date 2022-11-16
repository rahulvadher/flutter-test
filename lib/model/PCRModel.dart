class PCRModel {
  String branchCode = "";
  String clientCode = "";
  String clientName = "";
  String cashFOLedger = "";
  String cdsLedger = "";
  String totalLedger = "";
  String BENDEMAT_STOCK = "";
  String DPPOA_STOCK = "";
  String DP_BEN_STOCK_AHC = "";
  String marginStock = "";
  String foMargin = "";
  String cdsMargin = "";
  String totalMGN = "";
  String netBalance = "";
  String netBalance2 = "";
  String unrealVoucher = "";
  String debitDays = "";
  String t5Debit = "";
  String pureRisk = "";

  PCRModel({
    this.branchCode = "",
    this.clientCode = "",
    this.clientName = "",
    this.cashFOLedger = "",
    this.cdsLedger = "",
    this.totalLedger = "",
    this.BENDEMAT_STOCK = "",
    this.DPPOA_STOCK = "",
    this.DP_BEN_STOCK_AHC = "",
    this.marginStock = "",
    this.foMargin = "",
    this.cdsMargin = "",
    this.totalMGN = "",
    this.netBalance = "",
    this.netBalance2 = "",
    this.unrealVoucher = "",
    this.debitDays = "",
    this.t5Debit = "",
    this.pureRisk = "",
  });

  PCRModel.fromJson(Map<String, dynamic> json) {
    branchCode = json['1'];
    clientCode = json['2'];
    clientName = json['3'];
    cashFOLedger = json['4'];
    cdsLedger = json['5'];
    totalLedger = json['6'];
    BENDEMAT_STOCK = json['7'];
    DPPOA_STOCK = json['8'];
    DP_BEN_STOCK_AHC = json['9'];
    marginStock = json['10'];
    foMargin = json['11'];
    cdsMargin = json['12'];
    totalMGN = json['13'];
    netBalance = json['14'];
    netBalance2 = json['15'];
    unrealVoucher = json['16'];
    debitDays = json['17'];
    t5Debit = json['18'];
    pureRisk = json['19'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.branchCode;
    data['2'] = this.clientCode;
    data['3'] = this.clientName;
    data['4'] = this.cashFOLedger;
    data['5'] = this.cdsLedger;
    data['6'] = this.totalLedger;
    data['7'] = this.BENDEMAT_STOCK;
    data['8'] = this.DPPOA_STOCK;
    data['9'] = this.DP_BEN_STOCK_AHC;
    data['10'] = this.marginStock;
    data['11'] = this.foMargin;
    data['12'] = this.cdsMargin;
    data['13'] = this.totalMGN;
    data['14'] = this.netBalance;
    data['15'] = this.netBalance2;
    data['16'] = this.unrealVoucher;
    data['17'] = this.debitDays;
    data['18'] = this.t5Debit;
    data['19'] = this.pureRisk;
    return data;
  }
}
