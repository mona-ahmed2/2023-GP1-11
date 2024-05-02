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

Future<List<CustomeNotification>> fetchMessageNotifications() async {
    bool isAdvisor = false;
    bool isStudent = false;

    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Check if the user is an advisor
    await FirebaseFirestore.instance
        .collection('academic_advisors')
        .where('uid', isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        isAdvisor = true;
      } else {
        isStudent = true;
      }
    });

    if (isAdvisor) {
      // Fetch notifications for advisor
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('chat')
              .where("adv_uid", isEqualTo: uid)
              .get();

      List<CustomeNotification> notifications = [];
      querySnapshot.docs.forEach((DocumentSnapshot doc) {
        if(doc['msg_num']>0)
        notifications.add(CustomeNotification(
          message:  " يوجد لديك "+doc['msg_num'].toString()+" رسالة غير مقروءة ",
          date: doc['last_time'].toDate(),
          title: "رسالة من طالبة",
        ));
      });

      return notifications;
    } else if (isStudent) {
       // Fetch notifications for advisor
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('chat')
              .where("stu_uid", isEqualTo: uid)
              .get();

      List<CustomeNotification> notifications = [];
      querySnapshot.docs.forEach((DocumentSnapshot doc) {
        if (doc['msg_num_stu'] > 0)
          notifications.add(CustomeNotification(
            message: " يوجد لديك "+doc['msg_num_stu'].toString()+ " رسالة غير مقروءة من مرشدتك "
                 ,
            date: doc['last_time'].toDate(),
            title: "رسالة من مرشدتك",
          ));
      });

      return notifications;
    }

    // Return an empty list if neither advisor nor student
    return [];
  }

}
