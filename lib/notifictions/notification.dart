class Notification{
 late final String message;
  late final String title;
    late final DateTime date;

    Notification({required this.message,required this.date,required this.title});
      Notification.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    title = json['title'];
   date = DateTime.parse(json['date']); // Convert string to DateTime
  
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['title'] = title;
   data['date'] = date.toIso8601String(); // Convert DateTime to string
    return data;
  }

  
}