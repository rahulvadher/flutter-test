class ClientListModel {
  String? clientCode;
  String? branchCode;
  String? name;
  String? firstName;
  String? midName;
  String? lastName;
  String? dateOfBirth;
  String? upiId;
  String? adharNo;
  String? panNo;
  String? email;
  String? mobileNo;
  String? memberDpId;
  String? dpId;
  String? address1;
  String? address2;
  String? address3;
  String? city;
  String? pinCode;
  String? bankName;
  String? bankAccountNo;
  String? bankAdd1;
  String? bankAdd2;
  String? bankAdd3;
  String? bankAdd4;
  String? bankIfscCode;
  String? bankMicrCode;
  String? status;
  String? segments;
  String? openDate;
  bool? nseFo;
  bool? bseEq;
  bool? bseFo;
  bool? mcx;
  bool? nseCd;
  bool? bseCd;
  bool? nseEq;
  bool? poaFlag;


  ClientListModel(
      {this.clientCode,
      this.branchCode,
      this.name,
      this.firstName,
      this.midName,
      this.lastName,
      this.dateOfBirth,
      this.upiId,
      this.adharNo,
      this.panNo,
      this.email,
      this.mobileNo,
      this.memberDpId,
      this.dpId,
      this.address1,
      this.address2,
      this.address3,
      this.city,
      this.pinCode,
      this.bankName,
      this.bankAccountNo,
      this.bankAdd1,
      this.bankAdd2,
      this.bankAdd3,
      this.bankAdd4,
      this.bankIfscCode,
      this.bankMicrCode,
      this.status,
      this.segments,
      this.nseFo,
      this.bseEq,
      this.bseFo,
      this.mcx,
      this.nseCd,
      this.bseCd,
      this.nseEq,
      this.openDate,
      this.poaFlag});

  ClientListModel.fromJson(Map<String, dynamic> json) {
    clientCode = json['clientCode'];
    branchCode = json['branchCode'];
    name = json['name'];
    firstName = json['firstName'];
    midName = json['midName'];
    lastName = json['lastName'];
    dateOfBirth = json['dateOfBirth'];
    upiId = json['upiId'];
    adharNo = json['adharNo'];
    panNo = json['panNo'];
    email = json['email'];
    mobileNo = json['mobileNo'];
    memberDpId = json['memberDpId'];
    dpId = json['dpId'];
    address1 = json['address1'];
    address2 = json['address2'];
    address3 = json['address3'];
    city = json['city'];
    pinCode = json['pinCode'];
    bankName = json['bankName'];
    bankAccountNo = json['bankAccountNo'];
    bankAdd1 = json['bankAdd1'];
    bankAdd2 = json['bankAdd2'];
    bankAdd3 = json['bankAdd3'];
    bankAdd4 = json['bankAdd4'];
    bankIfscCode = json['bankIfscCode'];
    bankMicrCode = json['bankMicrCode'];
    status = json['status'];
    segments = json['segments'];
    nseFo = json['nseFo'];
    bseEq = json['bseEq'];
    bseFo = json['bseFo'];
    mcx = json['mcx'];
    nseCd = json['nseCd'];
    bseCd = json['bseCd'];
    nseEq = json['nseEq'];
    openDate = json['openDate'];
    poaFlag = json['poaFlag']=='Y'?true:json['poaFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientCode'] = this.clientCode;
    data['branchCode'] = this.branchCode;
    data['name'] = this.name;
    data['firstName'] = this.firstName;
    data['midName'] = this.midName;
    data['lastName'] = this.lastName;
    data['dateOfBirth'] = this.dateOfBirth;
    data['upiId'] = this.upiId;
    data['adharNo'] = this.adharNo;
    data['panNo'] = this.panNo;
    data['email'] = this.email;
    data['mobileNo'] = this.mobileNo;
    data['memberDpId'] = this.memberDpId;
    data['dpId'] = this.dpId;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['address3'] = this.address3;
    data['city'] = this.city;
    data['pinCode'] = this.pinCode;
    data['bankName'] = this.bankName;
    data['bankAccountNo'] = this.bankAccountNo;
    data['bankAdd1'] = this.bankAdd1;
    data['bankAdd2'] = this.bankAdd2;
    data['bankAdd3'] = this.bankAdd3;
    data['bankAdd4'] = this.bankAdd4;
    data['bankIfscCode'] = this.bankIfscCode;
    data['bankMicrCode'] = this.bankMicrCode;
    data['status'] = this.status;
    data['segments'] = this.segments;
    data['nseFo'] = this.nseFo;
    data['bseEq'] = this.bseEq;
    data['bseFo'] = this.bseFo;
    data['mcx'] = this.mcx;
    data['nseCd'] = this.nseCd;
    data['bseCd'] = this.bseCd;
    data['nseEq'] = this.nseEq;
    data['openDate'] = this.openDate;
    data['poaFlag'] = this.poaFlag;
    return data;
  }
}
