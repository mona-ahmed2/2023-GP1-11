
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<String?> getAuthUidStream() {
    return FirebaseAuth.instance.authStateChanges().map((user) {
      return user
          ?.uid; // If user is null, return null, otherwise return user's uid
    });
  }

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
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('specific_notification')
          .where("uid", isEqualTo: uid)
          .orderBy("date")
          .get();

      List<CustomeNotification> notifications = [];
      querySnapshot.docs.forEach((doc) {
        notifications.add(CustomeNotification.fromJson(doc.data()));
      });

      return notifications;
    } else {
      // Handle case when user is not signed in
      return [];
    }
  }

  Future<List<CustomeNotification>> fetchMessageNotifications() async {
    bool isAdvisor = false;
    bool isStudent = false;

    String? uid = FirebaseAuth.instance.currentUser?.uid;

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

      // Fetch student name for each document in the query snapshot
      for (DocumentSnapshot doc in querySnapshot.docs) {
        if (doc['msg_num'] > 0) {
          // Fetch student document
          DocumentSnapshot? studentDoc = await FirebaseFirestore.instance
              .collection('students')
              .where('uid',
                  isEqualTo: doc['stu_uid']) // Query based on stu_uid field
              .limit(
                  1) // Limit the query to 1 document, assuming stu_uid is unique
              .get()
              .then<DocumentSnapshot?>((querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              return querySnapshot.docs.first;
              // Return the first document if found
            } else {
              return null; // Return null if no document found
            }
          });

          // Check if student document exists and then add notification
          if (studentDoc != null) {
            String studentName = studentDoc[
                'name']; // Assuming 'name' is the field containing the student's name
            notifications.add(CustomeNotification(
              message: " يوجد لديك " +
                  doc['msg_num'].toString() +
                  " رسالة غير مقروءة من الطالبة " +
                  studentName,
              date: doc['last_time'].toDate(),
              title: "رسالة من طالبة",
            ));
          }
        }
      }

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
            message: " يوجد لديك " +
                doc['msg_num_stu'].toString() +
                " رسالة غير مقروءة من مرشدتك ",
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

