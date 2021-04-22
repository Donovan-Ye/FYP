class AppliedModel {
  List<AppliedItem> services;

  AppliedModel({this.services});

  factory AppliedModel.fromJson(Map<String, dynamic> json) {
    return AppliedModel(
      services: List.of(json["getApplied"])
          .map((i) => AppliedItem.fromJson(i))
          .toList(),
    );
  }
}

class AppliedItem {
  String id;
  UserItem appliedUser;
  String firstName;
  String lastName;
  String address;
  String address2;
  String city;
  String state;
  String zip;
  String phone;
  String description;
  String serviceId;
  String status;

  AppliedItem(
      {this.id,
      this.appliedUser,
      this.firstName,
      this.lastName,
      this.address,
      this.address2,
      this.city,
      this.state,
      this.zip,
      this.phone,
      this.description,
      this.serviceId,
      this.status});

  AppliedItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appliedUser = json['appliedUser'] != null
        ? new UserItem.fromJson(json['appliedUser'])
        : null;
    firstName = json['firstName'];
    lastName = json['lastName'];
    address = json['address'];
    address2 = json['address2'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    phone = json['phone'];
    description = json['description'];
    serviceId = json['service_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['appliedUser'] = this.appliedUser.toJson();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['address'] = this.address;
    data['address2'] = this.address2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip'] = this.zip;
    data['phone'] = this.phone;
    data['description'] = this.description;
    data['service_id'] = this.serviceId;
    data['status'] = this.status;
    return data;
  }
}

class UserItem {
  String profile;
  String username;
  String password;
  String email;
  String gender;
  String phone;
  bool isVerified;
  String code;

  UserItem(
      {this.profile,
      this.username,
      this.password,
      this.email,
      this.gender,
      this.phone,
      this.isVerified,
      this.code});

  UserItem.fromJson(Map<String, dynamic> json) {
    profile = json['profile'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    gender = json['gender'];
    phone = json['phone'];
    isVerified = json['isVerified'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile'] = this.profile;
    data['username'] = this.username;
    data['password'] = this.password;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['phone'] = this.phone;
    data['isVerified'] = this.isVerified;
    data['code'] = this.code;
    return data;
  }
}
