import 'package:chat_app/Widget/widget.dart';
import 'package:chat_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import'package:flutter/material.dart';

import '../helper/helperfunctions.dart';
import '../services/database.dart';
import 'chatRooms.dart';

class SignIn extends StatefulWidget {
  final Function toogle;
  SignIn(this.toogle);
  // const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  AuthMethods authMethods = new AuthMethods();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  signIn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await authMethods.signInWithEmailAndPassword(emailEditingController.text,
          passwordEditingController.text).then((result) async {
        if (result != null)  {
          QuerySnapshot userInfoSnapshot =
          await DatabaseMethods().getUserInfo(emailEditingController.text);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
            userInfoSnapshot.docs[0].data()["name"]);
          HelperFunctions.saveUserEmailSharedPreference(
              userInfoSnapshot.docs[0].data()["email"]);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
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
    appBar: AppBar(title: Text("Message_App")),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height-55,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               Form(
                 key: formKey,
                 child: Column(children: [
                   TextFormField(
                     validator: (val){return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!) ?
                     null : "Enter correct email";
                     },
                     controller: emailEditingController,
                     decoration: InputDecoration(
                         hintText: "Email_Id"
                     ),
                   ),
                   TextFormField(
                     obscureText: true,
                     validator: (val){
                       return val!.length > 6? null:"please enter correct password";
                     },
                     controller: passwordEditingController,
                     decoration: InputDecoration(
                         hintText: "Password"
                     ),
                   ),
                 ],),
               ),
                SizedBox(height: 8,),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                    child: Text("Forgot Password?"),
                  ),
                ),
                SizedBox(height: 8,),
                  GestureDetector(
                    onTap: (){
                      signIn();
                    },
                    child: Container(child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xff007EF4),
                        const Color(0xff2A75BC)
                      ],
                    )),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.greenAccent
                    ),
                    textAlign: TextAlign.center,
              ),
            ),
          ),
                  ),
              SizedBox(
              height: 16,
              ),
              Container(
                alignment: Alignment.center,
                width:MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.lightBlueAccent),

                child: Text("Sign With Google",style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 17
                )
               ),
              ),
              SizedBox(
              height: 16,
                 ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have account? ",
                    style: TextStyle(
                      fontSize: 17
                    ),
                  ),

              GestureDetector(
                onTap: (){
                  widget.toogle();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                      "Register now",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          decoration: TextDecoration.underline),
                    ),
                ),
              ),
                  ]
              ),
                SizedBox(height: 55,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
