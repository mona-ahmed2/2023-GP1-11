import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl,
     child:  SafeArea(
       child:  Padding(
         padding: const EdgeInsets.all(8.0),
         child: Column(children: [
            SvgPicture.asset(
                'assets/undraw_develop_app_re_bi4i.svg',
                width: MediaQuery.of(context).size.width,
                height: 0.5* MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
              ),
               SizedBox(
                height: 0.05* MediaQuery.of(context).size.height,
              ),
             Container(
            width: MediaQuery.of(context).size.width,
               child: Card(
                 child: Column(
                   children:[
                    const Text(
                        "\nأهلاً بك في تطبيق وجهنَي ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          height: 1.15,
                          color: Color.fromRGBO(55, 94, 152, 1),
                        ),
                      ),
                     
               const Text("\n الإرشاد الأكاديمي بين يديك \n ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.15,
                            color: Color.fromRGBO(156, 180, 204, 1),
                          ),),
                   ], 
                 ),
               ),
             ),
             
            
         ],
         ),
       ),
     ),
     );
  }
}

import 'package:stacked_notification_cards/stacked_notification_cards.dart';
import "package:wjjhni/notifictions/firebase_helper.dart";
import 'package:wjjhni/notifictions/notification.dart';
import 'package:wjjhni/notifictions/custome_cards.dart';

import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  //  List<NotificationCard> _listOfNotification = [
  //   NotificationCard(
  //     date: DateTime.now(),
  //     leading: Icon(
  //       Icons.account_circle,
  //       size: 48,
  //     ),
  //     title: 'OakTree 1',
  //     subtitle: 'We believe in the power of mobile computing.',
  //   ),
  //   NotificationCard(
  //     date: DateTime.now().subtract(
  //       const Duration(minutes: 4),
  //     ),
  //     leading: Icon(
  //       Icons.account_circle,
  //       size: 48,
  //     ),
  //     title: 'OakTree 2',
  //     subtitle: 'We believe in the power of mobile computing.',
  //   ),
  //   NotificationCard(
  //     date: DateTime.now().subtract(
  //       const Duration(minutes: 10),
  //     ),
  //     leading: Icon(
  //       Icons.account_circle,
  //       size: 48,
  //     ),
  //     title: 'OakTree 3',
  //     subtitle: 'We believe in the power of mobile computing.',
  //   ),
  //   NotificationCard(
  //     date: DateTime.now().subtract(
  //       const Duration(minutes: 30),
  //     ),
  //     leading: Icon(
  //       Icons.account_circle,
  //       size: 48,
  //     ),
  //     title: 'OakTree 4',
  //     subtitle: 'We believe in the power of mobile computing.',
  //   ),
  //   NotificationCard(
  //     date: DateTime.now().subtract(
  //       const Duration(minutes: 44),
  //     ),
  //     leading: Icon(
  //       Icons.account_circle,
  //       size: 48,
  //     ),
  //     title: 'OakTree 5',
  //     subtitle: 'We believe in the power of mobile computing.',
  //   ),
  // ];

  final FirebaseService _firebaseService = FirebaseService();
  List<CustomNotificationCard> _listGeneralOfNotification = [];
  List<CustomNotificationCard> _listSpecificfNotification = [];
  List<CustomNotificationCard> _listMessageNotification = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    //get general notifivations
    print("Loading notifications...");
    List<CustomeNotification> notifications =
        await _firebaseService.fetchGeneralNotifications();
    print("Notifications loaded: $notifications");
    List<CustomNotificationCard> notificationCards =
        notifications.map((notification) {
      return CustomNotificationCard(
        date: notification.date,
        leading: Icon(
          Icons.notifications,
          size: 32,
        ),
        title: notification.title,
        subtitle: notification.message +
            "\n" +
            DateFormat('MMM d, yyyy h:mm a').format(notification.date),
      );
    }).toList();

    List<CustomeNotification> notifications2 =
        await _firebaseService.fetchSpeNotifications();

    List<CustomNotificationCard> notificationCards2 =
        notifications2.map((notification2) {
      return CustomNotificationCard(
        date: notification2.date,
        leading: Icon(
          Icons.notifications,
          size: 32,
        ),
        title: notification2.title,
        subtitle: notification2.message +
            "\n" +
            DateFormat('MMM d, yyyy h:mm a').format(notification2.date),
      );
    }).toList();

    List<CustomeNotification> notifications3 =
        await _firebaseService.fetchMessageNotifications();

    List<CustomNotificationCard> notificationCards3 =
        notifications3.map((notification3) {
      return CustomNotificationCard(
        date: notification3.date,
        leading: Icon(
          Icons.notifications,
          size: 32,
        ),
        title: notification3.title,
        subtitle: notification3.message +
            "\n" +
            DateFormat('MMM d, yyyy h:mm a').format(notification3.date),
      );
    }).toList();

    setState(() {
      _listGeneralOfNotification = notificationCards;
      _listSpecificfNotification = notificationCards2;
      _listMessageNotification = notificationCards3;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<NotificationCard> notificationCards =
        _listGeneralOfNotification.map((customNotificationCard) {
      return NotificationCard(
        date: customNotificationCard.date,
        leading: customNotificationCard.leading,
        title: customNotificationCard.title,
        subtitle: customNotificationCard.subtitle,
      );
    }).toList();

    List<NotificationCard> notificationCards2 =
        _listSpecificfNotification.map((customNotificationCard) {
      return NotificationCard(
        date: customNotificationCard.date,
        leading: customNotificationCard.leading,
        title: customNotificationCard.title,
        subtitle: customNotificationCard.subtitle,
      );
    }).toList();

List<NotificationCard> notificationCards3 =
        _listMessageNotification.map((customNotificationCard) {
      return NotificationCard(
        date: customNotificationCard.date,
        leading: customNotificationCard.leading,
        title: customNotificationCard.title,
        subtitle: customNotificationCard.subtitle,
      );
    }).toList();




    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                StackedNotificationCards(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 2.0,
                    )
                  ],
                  notificationCardTitle: 'تنبيه',
                  notificationCards: [...notificationCards],
                  cardColor: Color(0xFFF1F1F1),
                  padding: 16,
                  actionTitle: Text(
                    ' التنبيهات العامة',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  showLessAction: Text(
                    'إظهار أقل',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  onTapClearAll: () {
                    setState(() {
                      // _listOfNotification.clear();
                    });
                  },
                  clearAllNotificationsAction: Icon(Icons.close),
                  clearAllStacked: Text('Clear All'),
                  cardClearButton: Text('clear'),
                  cardViewButton: Text('view'),
                  onTapClearCallback: (index) {
                    print(index);
                    setState(() {
                      // _listOfNotification.removeAt(index);
                    });
                  },
                  onTapViewCallback: (index) {
                    print(index);
                  },
                ),
                StackedNotificationCards(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 2.0,
                    )
                  ],
                  notificationCardTitle: 'تنبيه',
                  notificationCards: [...notificationCards2],
                  cardColor: Color(0xFFF1F1F1),
                  padding: 16,
                  actionTitle: Text(
                    ' التنبيهات الخاصة بي',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  showLessAction: Text(
                    'إظهار أقل',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  onTapClearAll: () {
                    setState(() {
                      // _listOfNotification.clear();
                    });
                  },
                  clearAllNotificationsAction: Icon(Icons.close),
                  clearAllStacked: Text('Clear All'),
                  cardClearButton: Text('clear'),
                  cardViewButton: Text('view'),
                  onTapClearCallback: (index) {
                    print(index);
                    setState(() {
                      // _listOfNotification.removeAt(index);
                    });
                  },
                  onTapViewCallback: (index) {
                    print(index);
                  },
                ),
                StackedNotificationCards(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 2.0,
                    )
                  ],
                  notificationCardTitle: 'تنبيه',
                  notificationCards: [...notificationCards3],
                  cardColor: Color(0xFFF1F1F1),
                  padding: 16,
                  actionTitle: Text(
                    'تنبيهات الرسائل',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  showLessAction: Text(
                    'إظهار أقل',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  onTapClearAll: () {
                    setState(() {
                      // _listOfNotification.clear();
                    });
                  },
                  clearAllNotificationsAction: Icon(Icons.close),
                  clearAllStacked: Text('Clear All'),
                  cardClearButton: Text('clear'),
                  cardViewButton: Text('view'),
                  onTapClearCallback: (index) {
                    print(index);
                    setState(() {
                      // _listOfNotification.removeAt(index);
                    });
                  },
                  onTapViewCallback: (index) {
                    print(index);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

