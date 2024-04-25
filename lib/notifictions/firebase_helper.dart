import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification.dart';

class FirebaseService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CustomeNotification>> fetchNotifications() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('genral_notifcation').orderBy("date").get();

    List<CustomeNotification> notifications = [];
    querySnapshot.docs.forEach((doc) {
      notifications.add(CustomeNotification.fromJson(doc.data()));
    });

    return notifications;
  }
}
