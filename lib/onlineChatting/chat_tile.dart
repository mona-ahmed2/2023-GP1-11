import 'package:flutter/material.dart';
import 'package:wjjhni/onlineChatting/chat_dialouge_screen.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String id;
  final String msg;
  final String time;
  final String uid;
  final String img = "assets/user.png";

  const ChatTile({
    Key? key,
    required this.name,
    required this.id,
    required this.msg,
    required this.time,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            blurRadius: 5,
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatDialouge(otherUserUid:uid,isAdvisor: true,isStudent: false,)),
          );
        },
        tileColor: Colors.white,
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage(img), // Fixed typo
          radius: 25,
        ),
        title: Text(
          name + " " + id,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          msg,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
       
            Text(
              time,
              style: const TextStyle(fontSize: 12),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color.fromARGB(255, 17, 110, 187),
              size: 20,
            ),
           
            // Spacer(),
            

            // Add some spacing
          ],
        ),
      ),
    );
  }
}
