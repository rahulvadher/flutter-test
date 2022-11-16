import 'TradeListModel.dart';

class TradeModel {
  String clientCode = '';
  String symbol = '';
  String scriptName = '';
  int buyQty = 0;
  int saleQty = 0;
  double buyAmount = 0.0;
  double buyAvg = 0.0;
  double saleAmount = 0.0;
  double saleAvg = 0.0;
  double profitLose = 0.0;
  String eqFutOpt = '';
  double strikePrice = 0.0;
  String expiry = '';
  String optionType = '';
  List<TradeListModel> trades = [];
  bool isVisible=false;

  TradeModel({
    this.clientCode = '',
    this.symbol = '',
    this.scriptName = '',
    this.buyQty = 0,
    this.saleQty = 0,
    this.buyAmount = 0.0,
    this.buyAvg = 0.0,
    this.saleAmount = 0.0,
    this.saleAvg = 0.0,
    this.profitLose = 0.0,
    this.eqFutOpt = '',
    this.strikePrice = 0.0,
    this.expiry = '',
    this.optionType = '',
    required this.trades,
    this.isVisible=false,
  });

  TradeModel.fromJson(Map<String, dynamic> json) {
    clientCode = json['clientCode'];
    symbol = json['symbol'];
    scriptName = json['scriptName'];
    buyQty = json['buyQty'];
    saleQty = json['saleQty'];
    buyAmount = json['buyAmount'];
    buyAvg = json['buyAvg'];
    saleAmount = json['saleAmount'];
    saleAvg = json['saleAvg'];
    profitLose = json['profitLose'];
    eqFutOpt = json['eqFutOpt'];
    strikePrice = json['strikePrice'];
    expiry = json['expiry'];
    optionType = json['optionType'];
    if (json['trades'] != null) {
      trades = <TradeListModel>[];
      json['trades'].forEach((v) {
        trades.add(new TradeListModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientCode'] = this.clientCode;
    data['symbol'] = this.symbol;
    data['scriptName'] = this.scriptName;
    data['buyQty'] = this.buyQty;
    data['saleQty'] = this.saleQty;
    data['buyAmount'] = this.buyAmount;
    data['buyAvg'] = this.buyAvg;
    data['saleAmount'] = this.saleAmount;
    data['saleAvg'] = this.saleAvg;
    data['profitLose'] = this.profitLose;
    data['eqFutOpt'] = this.eqFutOpt;
    data['strikePrice'] = this.strikePrice;
    data['expiry'] = this.expiry;
    data['optionType'] = this.optionType;
    if (this.trades != null) {
      data['trades'] = this.trades.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
