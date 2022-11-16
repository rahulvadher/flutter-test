class FundsOrderModel {
  int? amount;
  int? amountPaid;
  int? createdAt;
  int? amountDue;
  String? currency;
  String? receipt;
  String? id;
  String? entity;
  String? offerId;
  String? status;
  int? attempts;

  FundsOrderModel(
      {this.amount,
        this.amountPaid,
        this.createdAt,
        this.amountDue,
        this.currency,
        this.receipt,
        this.id,
        this.entity,
        this.offerId,
        this.status,
        this.attempts});

  FundsOrderModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    amountPaid = json['amount_paid'];
    createdAt = json['created_at'];
    amountDue = json['amount_due'];
    currency = json['currency'];
    receipt = json['receipt'];
    id = json['id'];
    entity = json['entity'];
    offerId = json['offer_id'];
    status = json['status'];
    attempts = json['attempts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['amount_paid'] = this.amountPaid;
    data['created_at'] = this.createdAt;
    data['amount_due'] = this.amountDue;
    data['currency'] = this.currency;
    data['receipt'] = this.receipt;
    data['id'] = this.id;
    data['entity'] = this.entity;
    data['offer_id'] = this.offerId;
    data['status'] = this.status;
    data['attempts'] = this.attempts;
    return data;
  }
}