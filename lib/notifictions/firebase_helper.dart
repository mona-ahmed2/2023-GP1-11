import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;
String uid = FirebaseAuth.instance.currentUser!.uid;
class FirebaseService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CustomeNotification>> fetchGeneralNotifications() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('genral_notifcation').orderBy("date").get();

    List<CustomeNotification> notifications = [];
    querySnapshot.docs.forEach((doc) {
      notifications.add(CustomeNotification.fromJson(doc.data()));
    });

    return notifications;
  }

  Future<List<CustomeNotification>> fetchSpeNotifications() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('specific_notification').where("uid",isEqualTo: uid).orderBy("date").get();

    List<CustomeNotification> notifications = [];
    querySnapshot.docs.forEach((doc) {
      notifications.add(CustomeNotification.fromJson(doc.data()));
    });

    return notifications;
  }
}
