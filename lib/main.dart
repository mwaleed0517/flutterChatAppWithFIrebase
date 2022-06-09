import 'package:chat_app/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'helper/helperfunctions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: const FirebaseOptions(
      apiKey: "AIzaSyCdTCQCmGVAkgute62epB1A8qAL5X8DEsU",
      authDomain: "chatapp-c0ee4.firebaseapp.com",
      databaseURL: "https://chatapp-c0ee4.firebaseio.com",
      projectId: "chatapp-c0ee4",
      storageBucket: "chatapp-c0ee4.appspot.com",
      messagingSenderId: "716512719757",
      appId: "1:716512719757:web:4bfc2c064d0b3354d083c4",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  late bool userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn  = value!;
      });
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        scaffoldBackgroundColor: const Color.fromARGB(255, 172, 207, 212),
        primarySwatch: Colors.blueGrey,
      ),
      home: FutureBuilder(
        future: _initialization,
        // initialData: InitialData,
        builder: (context, snapshot) {
          if (snapshot.hasError){
            // ignore: avoid_print
            print("Error");
          }
          if(snapshot.connectionState == ConnectionState.done){
            return const SignIn();
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}