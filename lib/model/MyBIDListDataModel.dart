class MyBIDListDataModel {
  List<BIDContent> content = [];
  Pageable? pageable;
  bool? last;
  int? totalPages;
  int? totalElements;
  int? size;
  int? number;
  Sort? sort;
  int? numberOfElements;
  bool? first;
  bool? empty;

  MyBIDListDataModel(
      {required this.content,
      this.pageable,
      this.last,
      this.totalPages,
      this.totalElements,
      this.size,
      this.number,
      this.sort,
      this.numberOfElements,
      this.first,
      this.empty});

  MyBIDListDataModel.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <BIDContent>[];
      json['content'].forEach((v) {
        content.add(new BIDContent.fromJson(v));
      });
    }
    pageable = json['pageable'] != null
        ? new Pageable.fromJson(json['pageable'])
        : null;
    last = json['last'];
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
    size = json['size'];
    number = json['number'];
    sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    numberOfElements = json['numberOfElements'];
    first = json['first'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content.map((v) => v.toJson()).toList();
    if (this.pageable != null) {
      data['pageable'] = this.pageable!.toJson();
    }
    data['last'] = this.last;
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
    data['size'] = this.size;
    data['number'] = this.number;
    if (this.sort != null) {
      data['sort'] = this.sort!.toJson();
    }
    data['numberOfElements'] = this.numberOfElements;
    data['first'] = this.first;
    data['empty'] = this.empty;
    return data;
  }
}

class BIDContent {
  int? id;
  String? symbol;
  String? reason;
  String? applicationNumber;
  String? clientCode;
  String? clientName;
  String? mobileNumber;
  String? referenceNumber;
  String? dpVerStatusFlag;
  String? subBrokerCode;
  String? depository;
  String? pan;
  String? timestamp;
  String? dpVerReason;
  String? dpId;
  String? upi;
  String? dpVerFailCode;
  bool? nonASBA;
  String? upiFlag;
  String? category;
  String? clientBenId;
  String? status;
  String? exchange;
  String? bidReferenceNumber;
  bool? atCutOff;
  double? quantity;
  String? remark;
  String? activityType;
  double? cutOffPrice;
  double? discount;

  BIDContent({
    this.id,
    this.symbol,
    this.reason,
    this.applicationNumber,
    this.clientCode,
    this.clientName,
    this.mobileNumber,
    this.referenceNumber,
    this.dpVerStatusFlag,
    this.subBrokerCode,
    this.depository,
    this.pan,
    this.timestamp,
    this.dpVerReason,
    this.dpId,
    this.upi,
    this.dpVerFailCode,
    this.nonASBA,
    this.upiFlag,
    this.category,
    this.clientBenId,
    this.status,
    this.exchange,
    this.bidReferenceNumber,
    this.atCutOff,
    this.quantity,
    this.remark,
    this.activityType,
    this.cutOffPrice,
    this.discount,

  });

  BIDContent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    symbol = json['symbol'];
    reason = json['reason'];
    applicationNumber = json['applicationNumber'];
    clientCode = json['clientCode'];
    clientName = json['clientName'];
    mobileNumber = json['mobileNumber'];
    referenceNumber = json['referenceNumber'];
    dpVerStatusFlag = json['dpVerStatusFlag'];
    subBrokerCode = json['subBrokerCode'];
    depository = json['depository'];
    pan = json['pan'];
    timestamp = json['timestamp'];
    dpVerReason = json['dpVerReason'];
    dpId = json['dpId'];
    upi = json['upi'];
    dpVerFailCode = json['dpVerFailCode'];
    nonASBA = json['nonASBA'];
    upiFlag = json['upiFlag'];
    category = json['category'];
    clientBenId = json['clientBenId'];
    status = json['status'];
    exchange = json['exchange'];
    bidReferenceNumber = json['bidReferenceNumber'];
    atCutOff = json['atCutOff'];
    quantity = json['quantity'];
    remark = json['remark'];
    activityType = json['activityType'];
    cutOffPrice = json['cutOffPrice'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['symbol'] = this.symbol;
    data['reason'] = this.reason;
    data['applicationNumber'] = this.applicationNumber;
    data['clientCode'] = this.clientCode;
    data['clientName'] = this.clientName;
    data['mobileNumber'] = this.mobileNumber;
    data['referenceNumber'] = this.referenceNumber;
    data['dpVerStatusFlag'] = this.dpVerStatusFlag;
    data['subBrokerCode'] = this.subBrokerCode;
    data['depository'] = this.depository;
    data['pan'] = this.pan;
    data['timestamp'] = this.timestamp;
    data['dpVerReason'] = this.dpVerReason;
    data['dpId'] = this.dpId;
    data['upi'] = this.upi;
    data['dpVerFailCode'] = this.dpVerFailCode;
    data['nonASBA'] = this.nonASBA;
    data['upiFlag'] = this.upiFlag;
    data['category'] = this.category;
    data['clientBenId'] = this.clientBenId;
    data['status'] = this.status;
    data['exchange'] = this.exchange;
    data['bidReferenceNumber'] = this.bidReferenceNumber;
    data['atCutOff'] = this.atCutOff;
    data['quantity'] = this.quantity;
    data['remark'] = this.remark;
    data['activityType'] = this.activityType;
    data['cutOffPrice'] = this.cutOffPrice;
    data['discount'] = this.discount;
    return data;
  }
}

class Pageable {
  Sort? sort;
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? unpaged;
  bool? paged;

  Pageable(
      {this.sort,
      this.offset,
      this.pageNumber,
      this.pageSize,
      this.unpaged,
      this.paged});

  Pageable.fromJson(Map<String, dynamic> json) {
    sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    offset = json['offset'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    unpaged = json['unpaged'];
    paged = json['paged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sort != null) {
      data['sort'] = this.sort!.toJson();
    }
    data['offset'] = this.offset;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['unpaged'] = this.unpaged;
    data['paged'] = this.paged;
    return data;
  }
}

class Sort {
  bool? sorted;
  bool? unsorted;
  bool? empty;

  Sort({this.sorted, this.unsorted, this.empty});

  Sort.fromJson(Map<String, dynamic> json) {
    sorted = json['sorted'];
    unsorted = json['unsorted'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sorted'] = this.sorted;
    data['unsorted'] = this.unsorted;
    data['empty'] = this.empty;
    return data;
  }
}
