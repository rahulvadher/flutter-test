import 'TradeModel.dart';

class TradeExpandListModel{
  List<TradeModel> trades = [];
  String tradeName ='';
  String m2m ='';
  bool isVisible = false;
  TradeExpandListModel( List<TradeModel> trades,String tradeName,  String m2m){
    this.trades=trades;
    this.tradeName=tradeName;
    this.m2m=m2m;
  }
}