class PathModel {
  List<PathItem> sharedpaths;

  PathModel({this.sharedpaths});

  factory PathModel.fromJson(Map<String, dynamic> json) {
    return PathModel(
      sharedpaths: List.of(json["getSharedPath"])
          .map((i) => PathItem.fromJson(i))
          .toList(),
    );
  }
}

class PathItem {
  String username;
  String sharedUsername;
  List<String> path;

  PathItem({this.username, this.sharedUsername, this.path});

  PathItem.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    sharedUsername = json['shared_username'];
    path = json['path'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['shared_username'] = this.sharedUsername;
    data['path'] = this.path;
    return data;
  }
}
