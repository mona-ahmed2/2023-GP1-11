// class Notification{
//  late final String message;
//   late final String title;
//     late final DateTime date;

//     Notification({required this.message,required this.date,required this.title});
//       Notification.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//     title = json['title'];
//    date = DateTime.parse(json['date']); // Convert string to DateTime
  
//   }
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['message'] = message;
//     data['title'] = title;
//    data['date'] = date.toIso8601String(); // Convert DateTime to string
//     return data;
//   }
// String get message => message;
//   String get title => _title;
//   DateTime get date => _date;
  
// }
import 'package:cloud_firestore/cloud_firestore.dart';
class CustomeNotification {
  late final String _message;
  late final String _title;
  late final DateTime _date;

  CustomeNotification({
    required String message,
    required DateTime date,
    required String title,
  })  : _message = message,
        _date = date,
        _title = title;

  CustomeNotification.fromJson(Map<String, dynamic> json)
      : _message = json['message'],
        _title = json['title'],
        _date = (json['date'] as Timestamp).toDate();

  String get message => _message;
  String get title => _title;
  DateTime get date => _date;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = _message;
    data['title'] = _title;
    data['date'] = _date.toIso8601String();
    return data;
  }
}
