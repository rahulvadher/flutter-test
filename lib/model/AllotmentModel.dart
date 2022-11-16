class AllotmentModel {
  List<AllotmentContent> content = [];
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

  AllotmentModel(
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

  AllotmentModel.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <AllotmentContent>[];
      json['content'].forEach((v) {
        content.add(new AllotmentContent.fromJson(v));
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

class AllotmentContent {
  String? id;
  String? branch;
  String? clientCode;
  String? memberDpId;
  String? dpId;
  String? isinCode;
  String? name;
  String? mobileNumber;
  String? script;
  String? qty;
  String? accountStatus;

  AllotmentContent({
    this.id,
    this.branch,
    this.clientCode,
    this.memberDpId,
    this.dpId,
    this.isinCode,
    this.name,
    this.mobileNumber,
    this.script,
    this.qty,
    this.accountStatus,
  });

  AllotmentContent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branch = json['branch'];
    clientCode = json['clientCode'];
    memberDpId = json['memberDpId'];
    dpId = json['dpId'];
    isinCode = json['isinCode'];
    name = json['name'];
    mobileNumber = json['mobileNumber'];
    script = json['script'];
    qty = json['qty'];
    accountStatus = json['accountStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['branch'] = this.branch;
    data['clientCode'] = this.clientCode;
    data['memberDpId'] = this.memberDpId;
    data['dpId'] = this.dpId;
    data['isinCode'] = this.isinCode;
    data['name'] = this.name;
    data['mobileNumber'] = this.mobileNumber;
    data['script'] = this.script;
    data['qty'] = this.qty;
    data['accountStatus'] = this.accountStatus;
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
