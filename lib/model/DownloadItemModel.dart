class DownloadItemModel {
  String? title;
  String? link;

  DownloadItemModel({
    this.title,
    this.link,
  });

  DownloadItemModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['link'] = this.link;
    return data;
  }
}
