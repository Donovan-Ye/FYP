class FriendModel {
  List<FriendItem> friends;

  FriendModel({this.friends});

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      friends:
          List.of(json["friends"]).map((i) => FriendItem.fromJson(i)).toList(),
    );
  }
}

class FriendItem {
  String name;
  String phone;
  String profile;

  FriendItem({this.name, this.phone, this.profile});

  FriendItem.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['profile'] = this.profile;
    return data;
  }
}
