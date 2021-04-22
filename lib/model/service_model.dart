class ServiceModel {
  List<ServiceItem> services;

  ServiceModel({this.services});

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      services: List.of(json["getServices"])
          .map((i) => ServiceItem.fromJson(i))
          .toList(),
    );
  }
}

class ServiceItem {
  String id;
  bool is_deleted;
  String name;
  String overview;
  String poster_path;
  String release_date;
  String provider;
  String category;
  String address;
  String available_time;
  String profile;
  String title;
  String occupation;
  String website;
  String is_professional;
  String provider_username;

  ServiceItem({
    this.id,
    this.is_deleted,
    this.name,
    this.overview,
    this.poster_path,
    this.release_date,
    this.provider,
    this.category,
    this.address,
    this.available_time,
    this.profile,
    this.title,
    this.occupation,
    this.website,
    this.is_professional,
    this.provider_username,
  });

  ServiceItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    is_deleted = json['is_deleted'];
    name = json['name'];
    overview = json['overview'];
    poster_path = json['poster_path'];
    release_date = json['release_date'];
    provider = json['provider'];
    category = json['category'];
    address = json['address'];
    available_time = json['available_time'];
    profile = json['profile'];
    title = json['title'];
    occupation = json['occupation'];
    website = json['website'];
    is_professional = json['is_professional'];
    provider_username = json['provider_username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_deleted'] = this.is_deleted;
    data['name'] = this.name;
    data['overview'] = this.overview;
    data['poster_path'] = this.poster_path;
    data['release_date'] = this.release_date;
    data['provider'] = this.provider;
    data['category'] = this.category;
    data['address'] = this.address;
    data['available_time'] = this.available_time;
    data['profile'] = this.profile;
    data['title'] = this.title;
    data['occupation'] = this.occupation;
    data['website'] = this.website;
    data['is_professional'] = this.is_professional;
    data['provider_username'] = this.provider_username;
    return data;
  }
}
