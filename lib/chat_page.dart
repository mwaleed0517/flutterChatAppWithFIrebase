import 'package:chat_app/services/database.dart';
import 'package:chat_app/sign_in.dart';
import 'package:chat_app/views/chat.dart';
import 'package:chat_app/views/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'helper/constants.dart';
import 'helper/helperfunctions.dart';
import 'helper/theme.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // ignore: non_constant_identifier_names
  late Stream ChatPages;
  late QuerySnapshot searchResultSnapshot;

  // ignore: non_constant_identifier_names
  Widget ChatPagesList() {
    return StreamBuilder(
      stream: ChatPages,
      builder: (context, snapshot) {
        searchResultSnapshot = snapshot as QuerySnapshot<Object?>;
        return snapshot.hasData
            ? ListView.builder(
                itemCount: searchResultSnapshot.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatPagesTile(
                    userName: (searchResultSnapshot.docs[index].data()
                    as Map<String, dynamic>)['ChatPageId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    ChatPageId: (searchResultSnapshot.docs[index].data()
                    as Map<String, dynamic>)["ChatPageId"],
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        ChatPages = snapshots;
        print(
            "we got the data + ${ChatPages.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 40,
        ),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const SignIn()));
            },
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
        child: ChatPagesList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Search()));
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class ChatPagesTile extends StatelessWidget {
  String userName = '';
  // ignore: non_constant_identifier_names
  String ChatPageId = '';

  // ignore: non_constant_identifier_names
  ChatPagesTile({Key? key, required this.userName,required this.ChatPageId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => Chat(
            ChatPageId: ChatPageId, chatRoomId: '',
          )
        ));
      },
      child: Container(
        color: Colors.black26,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: CustomTheme.colorAccent,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}