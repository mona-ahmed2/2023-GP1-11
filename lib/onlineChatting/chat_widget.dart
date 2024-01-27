// import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:wjjhni/onlineChatting/chat_tile.dart';
import '../widgets/search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance;
  Stream<dynamic>? getStudentsStream() {
    final snapshot = db //getting from the firebase database
        .collection('students')
        .where('advisor_uid', isEqualTo: uid)
        .snapshots();
    return snapshot;
  }
 
  TextEditingController editingController = TextEditingController();
  List<String> names = [
    "ابتهال",
    "أروى",
    "منيرة",
    "جنا",
    "سارة",
    "خولة",
    "خولة",
    "سعاد",
    "راما"
  ];

  List<String> searchResults = [];
  void filterSearchResults(String query) {
    setState(() {
      searchResults = names
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    searchResults = names;
  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    void onQueryChanged(String query) {
      setState(() {
        searchResults = names
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: TextField(
                  onChanged: (value) {
                    filterSearchResults(value);
                    // print(getStudentsStream());
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'بحث بالاسم',
                    border: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16.0))),
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                controller: scrollController,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: searchResults.length,
                itemBuilder: (context, i) {
                  return ChatTile(
                      name: searchResults[i],
                      id: "442202323",
                      msg: "مرحبا",
                      time: "6:00مساء ");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

