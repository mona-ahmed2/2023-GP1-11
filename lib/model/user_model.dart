class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.major,
    required this.phone,
  });
  late final String id;
  late final String name;
  late final String email;
  late final String major;
  late final String phone;

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    major = json['major'];
    phone = json['phone'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = id;
    data['name'] = name;
    data['email'] = email;
    data['major'] = major;
    data['phone']= phone;
    return data;
  }
}
//model
  class AcademicAdvisorsModel {
  AcademicAdvisorsModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.major,
  });
  late final String id;
  late final String name;
  late final String email;
  late final String phone;
  late final String major;

  AcademicAdvisorsModel.fromJson(Map<String, dynamic> json) {
    id = json['uid'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    major = json['department'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['department'] = major;
    return data;
  }
}
