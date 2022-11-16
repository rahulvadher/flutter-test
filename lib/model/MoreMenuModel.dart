class MoreMenuModel {
  String? title;
  String? tags;
  int? parent;
  String? type;
  String? icon;
  String? url;

  MoreMenuModel({this.title, this.tags, this.parent,this.type,this.icon,this.url});

  MoreMenuModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    tags = json['tags'];
    parent = json['parent'];
    type = json['type'];
    icon = json['icon'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['tags'] = this.tags;
    data['parent'] = this.parent;
    data['type'] = this.type;
    data['icon'] = this.icon;
    data['url'] = this.url;
    return data;
  }
}
