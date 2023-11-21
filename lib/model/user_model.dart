class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.major,
    required this.completedHours,
  });
  late final String id;
  late final String name;
  late final String email;
  late final String bio;
  late final String major;
  late final String completedHours;

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    bio = json['bio'];
    major = json['major'];
    completedHours = json['complated_hours'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = id;
    data['name'] = name;
    data['email'] = email;
    data['bio'] = bio;
    data['major'] = major;
    data['complated_hours'] = completedHours;
    return data;
  }
}

  class AcademicAdvisorsModel {
  AcademicAdvisorsModel({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.major,
  });
  late final String id;
  late final String name;
  late final String email;
  late final String bio;
  late final String major;

  AcademicAdvisorsModel.fromJson(Map<String, dynamic> json) {
    id = json['uid'];
    name = json['name'];
    email = json['email'];
    bio = json['bio'];
    major = json['department'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = id;
    data['name'] = name;
    data['email'] = email;
    data['bio'] = bio;
    data['department'] = major;
    return data;
  }
}
