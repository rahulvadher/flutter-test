class OpenBIDListDataModel {
  List<OpenBIDContent> content=[];
  Pageable? pageable;
  int? totalPages;
  int? totalElements;
  bool? last;
  int? size;
  int? number;
  Sort? sort;
  int? numberOfElements;
  bool? first;
  bool? empty;

  OpenBIDListDataModel(
      {required this.content,
        this.pageable,
        this.totalPages,
        this.totalElements,
        this.last,
        this.size,
        this.number,
        this.sort,
        this.numberOfElements,
        this.first,
        this.empty});

  OpenBIDListDataModel.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <OpenBIDContent>[];
      json['content'].forEach((v) {
        content.add(new OpenBIDContent.fromJson(v));
      });
    }
    pageable = json['pageable'] != null
        ? new Pageable.fromJson(json['pageable'])
        : null;
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
    last = json['last'];
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
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
    data['last'] = this.last;
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

class OpenBIDContent {
  String? symbol;
  String? biddingStartDate;
  String? biddingEndDate;
  int? minBidQuantity;
  String? registrar;
  int? lotSize;
  String? dailyStartTime;
  String? dailyEndTime;
  double? tickSize;
  String? issueType;
  double? faceValue;
  double? minPrice;
  String? name;
  int? issueSize;
  double? maxPrice;
  double? cutOffPrice;
  String? isin;
  List<String>? exchange;
  int? series;
  int? seriesNext;
  int? seriesCount;
  List<Category>? category;
  bool? isEnable;
  double? ratings;

  OpenBIDContent(
      {this.symbol,
        this.biddingStartDate,
        this.biddingEndDate,
        this.minBidQuantity,
        this.registrar,
        this.lotSize,
        this.dailyStartTime,
        this.dailyEndTime,
        this.tickSize,
        this.issueType,
        this.faceValue,
        this.minPrice,
        this.name,
        this.issueSize,
        this.maxPrice,
        this.cutOffPrice,
        this.isin,
        this.exchange,
        this.series,
        this.seriesNext,
        this.seriesCount,
        this.category,
        this.isEnable,
        this.ratings,
      });

  OpenBIDContent.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    biddingStartDate = json['biddingStartDate'];
    biddingEndDate = json['biddingEndDate'];
    minBidQuantity = json['minBidQuantity'];
    registrar = json['registrar'];
    lotSize = json['lotSize'];
    dailyStartTime = json['dailyStartTime'];
    dailyEndTime = json['dailyEndTime'];
    tickSize = json['tickSize'];
    issueType = json['issueType'];
    faceValue = json['faceValue'];
    minPrice = json['minPrice'];
    name = json['name'];
    issueSize = json['issueSize'];
    maxPrice = json['maxPrice'];
    cutOffPrice = json['cutOffPrice'];
    isin = json['isin'];
    exchange = json['exchange'].cast<String>();
    series = json['series'];
    ratings = json['ratings'];
    seriesNext = json['seriesNext'];
    seriesCount = json['seriesCount'];
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['symbol'] = this.symbol;
    data['biddingStartDate'] = this.biddingStartDate;
    data['biddingEndDate'] = this.biddingEndDate;
    data['minBidQuantity'] = this.minBidQuantity;
    data['registrar'] = this.registrar;
    data['lotSize'] = this.lotSize;
    data['dailyStartTime'] = this.dailyStartTime;
    data['dailyEndTime'] = this.dailyEndTime;
    data['tickSize'] = this.tickSize;
    data['issueType'] = this.issueType;
    data['faceValue'] = this.faceValue;
    data['minPrice'] = this.minPrice;
    data['name'] = this.name;
    data['issueSize'] = this.issueSize;
    data['maxPrice'] = this.maxPrice;
    data['cutOffPrice'] = this.cutOffPrice;
    data['isin'] = this.isin;
    data['exchange'] = this.exchange;
    data['ratings'] = this.ratings;
    data['series'] = this.series;
    data['seriesNext'] = this.seriesNext;
    data['seriesCount'] = this.seriesCount;
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  String? code;
  String? startTime;
  String? endTime;
  double? discount;

  Category({this.code, this.startTime, this.endTime, this.discount});

  Category.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['discount'] = this.discount;
    return data;
  }
}

class Pageable {
  Sort? sort;
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? paged;
  bool? unpaged;

  Pageable(
      {this.sort,
        this.offset,
        this.pageNumber,
        this.pageSize,
        this.paged,
        this.unpaged});

  Pageable.fromJson(Map<String, dynamic> json) {
    sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    offset = json['offset'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    paged = json['paged'];
    unpaged = json['unpaged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sort != null) {
      data['sort'] = this.sort!.toJson();
    }
    data['offset'] = this.offset;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['paged'] = this.paged;
    data['unpaged'] = this.unpaged;
    return data;
  }
}

class Sort {
  bool? empty;
  bool? sorted;
  bool? unsorted;

  Sort({this.empty, this.sorted, this.unsorted});

  Sort.fromJson(Map<String, dynamic> json) {
    empty = json['empty'];
    sorted = json['sorted'];
    unsorted = json['unsorted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empty'] = this.empty;
    data['sorted'] = this.sorted;
    data['unsorted'] = this.unsorted;
    return data;
  }
}
