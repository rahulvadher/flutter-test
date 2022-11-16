
import 'LTPModel.dart';

class RateModel {
  int? Token;
  String? code;
  LTPModel? oldLTP;
  LTPModel? newLTP;
  bool isAdded=false,isVisible=false;

  RateModel({
    this.Token,
    this.code,
    this.oldLTP,
    this.newLTP,
    this.isAdded=false,
    this.isVisible=false,
  });
}
