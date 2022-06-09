import 'package:chat_app/services/database.dart';
import 'package:chat_app/sigh_up.dart';
import 'package:chat_app/views/chatrooms.dart';
import 'package:chat_app/views/forgot_password.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'firebase_con.dart';
import 'helper/helperfunctions.dart';
import 'widgets/widgets.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  
  Auth auth = Auth();
  bool passwordVisible = false;

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  TextEditingController emailTEC = TextEditingController();
  TextEditingController passTEC = TextEditingController();

  signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await auth.signInFunc(
              emailTEC.text, passTEC.text)
          .then((result) async {
        if (result != null)  {
          QuerySnapshot userInfoSnapshot =
              await DatabaseMethods().getUserInfo(emailTEC.text);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              (userInfoSnapshot.docs[0].data()
                    as Map<String, dynamic>)["userName"]);
          HelperFunctions.saveUserEmailSharedPreference(
              (userInfoSnapshot.docs[0].data()
                    as Map<String, dynamic>)["userEmail"]);

                    print("sshhh");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const ChatRoom()));
        } else {
          setState(() {
            isLoading = false;
            //show snackbar
          });
        }
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Spacer(),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val) => EmailValidator.validate(val!)
                            ? null
                            : "Please enter a valid email",
                          style: getTextStyle(),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            prefixIcon  : const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white60)
                            ),
                          ),
                          controller: emailTEC,
                        ),
                        const SizedBox(height: 5,),
                        TextFormField(
                          obscureText: !passwordVisible,
                          validator: (val) {
                            RegExp regex = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");
                            if (val == null || val.isEmpty) {
                              return 'Please Enter Password!';
                            } else {
                              if (!regex.hasMatch(val)) {
                                return 'Password must have one specil char, number, upper and lower case with min length 8';
                              } else {
                                return null;
                              }
                            }
                          },
                          style: getTextStyle(),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white60)
                            ),
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            // Here is key idea
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                                color: Colors.black26,
                                ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                    passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                          ),
                          controller: passTEC,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgotPassword()));
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                        color: Colors.black54,
                      ),
                          )),
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                GestureDetector(
                  onTap: () {
                    signIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.blueGrey.shade500
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUp()));
                      },
                      child: const Text(
                        "Create Account!",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          decoration: TextDecoration.underline
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}