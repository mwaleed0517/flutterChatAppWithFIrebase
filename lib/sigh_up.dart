import 'package:chat_app/services/database.dart';
import 'package:chat_app/sign_in.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'firebase_con.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  Auth auth = Auth();
  DatabaseMethods databaseMethods = DatabaseMethods();
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  bool pageLoading = false;
  TextEditingController userNameTEC = TextEditingController();
  TextEditingController emailTEC = TextEditingController();
  TextEditingController passTEC = TextEditingController();
  TextEditingController rePassTEC = TextEditingController();

  signUpFuncCall(){
    if(_formKey.currentState!.validate()){
      Map<String,String> userDataMap = {
        "userName" : userNameTEC.text,
        "userEmail" : emailTEC.text
      };

      setState(() {        
        pageLoading = true;
      });

      databaseMethods.addUserInfo(userDataMap);

      auth.signUpFunc(emailTEC.text, passTEC.text).then((value){
        if(value != null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignIn()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: pageLoading 
      ?
      const Center(child: CircularProgressIndicator())
      :
      SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          return val!.isEmpty || val.length < 2 ? "User name needed!" : null;
                        },
                        style: getTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'User Name',
                          hintText: 'Enter user name',
                          prefixIcon  : const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white60)
                          ),
                        ),
                        controller: userNameTEC,
                      ),
                      const SizedBox(height: 5,),
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
                      const SizedBox(height: 5,),
                      TextFormField(
                        obscureText: !passwordVisible,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please Repeat Password!';
                          } else {
                            if (passTEC.text != val) {
                              return 'Password does not match!';
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
                          labelText: 'Repeat Password',
                          hintText: 'Repeat your password',
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
                        controller: rePassTEC,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Text(
                      "Forgot Password?",
                      style: getTextStyle(),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                GestureDetector(
                  onTap: (){
                    signUpFuncCall();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color.fromARGB(255, 91, 110, 119)
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white60,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    GestureDetector(
                      onTap: (() {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignIn()));
                      }),
                      child: const Text(
                        "Login Now!",
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