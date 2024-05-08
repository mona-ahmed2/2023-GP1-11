import 'package:flutter/material.dart';
import 'package:wjjhni/onlineChatting/chat_dialouge_screen.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String id;
  final String msg;
  final String time;
  final String uid;
  final String img = "assets/user.png";
<<<<<<< HEAD

  const ChatTile({
=======
  int numberOfmessages;

  ChatTile({
>>>>>>> c8b7ab0cc01ebb7471171d17c8100898c11a9ff8
    Key? key,
    required this.name,
    required this.id,
    required this.msg,
    required this.time,
    required this.uid,
<<<<<<< HEAD
=======
    required this.numberOfmessages,
>>>>>>> c8b7ab0cc01ebb7471171d17c8100898c11a9ff8
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
<<<<<<< HEAD
            MaterialPageRoute(builder: (context) => ChatDialouge(otherUserUid:uid,isAdvisor: true,isStudent: false,)),
=======
            MaterialPageRoute(
                builder: (context) => ChatDialouge(
                      otherUserUid: uid,
                      isAdvisor: true,
                      isStudent: false,
                    )),
>>>>>>> c8b7ab0cc01ebb7471171d17c8100898c11a9ff8
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
<<<<<<< HEAD
       
=======
>>>>>>> c8b7ab0cc01ebb7471171d17c8100898c11a9ff8
            Text(
              time,
              style: const TextStyle(fontSize: 12),
            ),
<<<<<<< HEAD
            const Icon(
              Icons.arrow_forward_ios,
              color: Color.fromARGB(255, 17, 110, 187),
              size: 20,
            ),
           
            // Spacer(),
            
=======
            // const Icon(
            //   Icons.arrow_forward_ios,
            //   color: Color.fromARGB(255, 17, 110, 187),
            //   size: 20,
            // ),

            numberOfmessages != 0
                ? Container(
                    width: 15, // Adjust width as needed
                    height: 15, // Adjust height as needed
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue, // Adjust color as needed
                    ),
                    child: Center(
                      child: Text(
                        numberOfmessages == 0 ? "" : "$numberOfmessages",
                        style:
                            const TextStyle(fontSize: 13, color: Colors.white),
                      ),
                    ),
                  )
                : Text(""),

            // Spacer(),
>>>>>>> c8b7ab0cc01ebb7471171d17c8100898c11a9ff8

            // Add some spacing
          ],
        ),
      ),
    );
  }
}
