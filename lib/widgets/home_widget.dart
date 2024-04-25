import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  List<CustomNotificationCard> _listOfNotification = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }


  Future<void> _loadNotifications() async {
    print("Loading notifications...");
    List<CustomeNotification> notifications =
        await _firebaseService.fetchNotifications();
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
        subtitle: notification.message+"\n"+
            DateFormat('MMM d, yyyy h:mm a').format(notification.date),
      );
    }).toList();

    setState(() {
      _listOfNotification = notificationCards;
    });
  }



  @override
  Widget build(BuildContext context) {
    List<NotificationCard> notificationCards =
        _listOfNotification.map((customNotificationCard) {
      return NotificationCard(
        date: customNotificationCard.date,
        leading: customNotificationCard.leading,
        title: customNotificationCard.title,
        subtitle: customNotificationCard.subtitle,
      );
    }).toList();
    return Directionality(
      textDirection:  ui.TextDirection.rtl,
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
                  notificationCardTitle: 'Message',
                  
                  notificationCards: [...notificationCards],
                  cardColor: Color(0xFFF1F1F1),
                  padding: 16,
                  actionTitle: Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  showLessAction: Text(
                    'Show less',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  onTapClearAll: () {
                    setState(() {
                      // _listOfNotification.clear();
                    });
                  },
                  clearAllNotificationsAction: Icon(Icons.close),
                  clearAllStacked: Text(''),
                  cardClearButton: Text(''),
                  cardViewButton: Text(''),
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
