import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('userName', isEqualTo: searchField)
        .get();
  }

  Future<bool> addChatRoom(chatRoom, chatRoomId) async {
    String err = '';
    FirebaseFirestore.instance
      .collection("chatRoom")
      .doc(chatRoomId)
      .set(chatRoom)
      .catchError((e) {
        err = e.toString();
        print(err);
      });
    return err == '' ? Future.value(false) : Future.value(true);
  }

  getChats(String chatRoomId) async{
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }


  Future<void> addMessage(String chatRoomId, chatMessageData)async {

    FirebaseFirestore.instance.collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
          print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

}
