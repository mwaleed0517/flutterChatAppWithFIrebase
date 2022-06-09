import 'package:firebase_auth/firebase_auth.dart';

class Auth{
  
  // Auth(){
  //   buildFireBase();
  // }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<void> buildFireBase() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp();

  //   // Ideal time to initialize
  //   await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //   //...
  // }

  Future signInFunc(String email, String pass) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      final user = result.user;
      return user != null ? User(userID: user.uid) : null;
    }catch(err){
      // ignore: avoid_print
      print(err.toString());
    }
  }

  Future signUpFunc(String email, String pass) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      final user = result.user;
      return user != null ? User(userID: user.uid) : null;
    }catch(err){
      // ignore: avoid_print
      print(err.toString());
    }
  }

  Future resetPassFunc(String email) async {
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(err){
      // ignore: avoid_print
      print(err.toString());
    }
  }

  Future signOutFunc() async {
    try{
      return await _auth.signOut();
    }catch(err){
      // ignore: avoid_print
      print(err.toString());
    }
  }
}

class User{
  String userID;

  User({required this.userID});
}