import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../helper/constants.dart';
import '../services/database.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;

  // ignore: non_constant_identifier_names
  const Chat({Key? key, required this.chatRoomId, required String ChatPageId}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  late Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = TextEditingController();
  late AsyncSnapshot<dynamic> searchResultSnapshot;
  late QuerySnapshot searchSnapshot;

  Widget chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        searchResultSnapshot = snapshot;
        if (snapshot.hasData) {
          searchSnapshot = searchResultSnapshot.data;
          return ListView.builder(
          itemCount: searchSnapshot.docs.length,//snapshot.data.length,
            itemBuilder: (context, index){
              return MessageTile(
                message: searchResultSnapshot.data.docs[index].data()["message"],
                sendByMe: Constants.myName == searchResultSnapshot.data.docs[index].data()["sendBy"],
              );
            });
        } else {
          return Container();
        }
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: Stack(
        children: [
          chatMessages(),
          Container(alignment: Alignment.bottomCenter,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              color: const Color(0x54FFFFFF),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: messageEditingController,
                        style: simpleTextStyle(),
                        decoration: const InputDecoration(
                            hintText: "Message ...",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            border: InputBorder.none
                        ),
                      )),
                  const SizedBox(width: 16,),
                  GestureDetector(
                    onTap: () {
                      addMessage();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [
                                  Color(0x36FFFFFF),
                                  Color(0x0FFFFFFF)
                                ],
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight
                            ),
                            borderRadius: BorderRadius.circular(40)
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Image.asset("assets/images/send.png",
                          height: 25, width: 25,)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  const MessageTile({Key? key, required this.message, required this.sendByMe}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe ? const BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            const BorderRadius.only(
        topLeft: Radius.circular(23),
          topRight: Radius.circular(23),
          bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                  : [
                const Color(0x1AFFFFFF),
                const Color(0x1AFFFFFF)
              ],
            )
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'OverpassRegular',
            fontWeight: FontWeight.w300)),
      ),
    );
  }
}

