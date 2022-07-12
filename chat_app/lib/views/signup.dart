import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import'package:firebase_auth/firebase_auth.dart';

import '../helper/helperfunctions.dart';
import '../services/auth.dart';
import 'chatRooms.dart';

class SignUp extends StatefulWidget {
  final Function toogle;
  SignUp(this.toogle);
  // const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  signMeUP() async {
    if(formKey.currentState!.validate()){
      setState(() {
        isLoading = true;
      });
      await authMethods.signUpWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((result){
        if(result != null){

          Map<String,String> userDataMap = {
            "name" : userNameTextEditingController.text,
            "email" : emailTextEditingController.text
          };

          databaseMethods.addUserInfo(userDataMap);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);
          HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);

          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoom()
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Message_App")),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator())
      ): SingleChildScrollView(
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
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          return val!.isEmpty || val.length < 2? "Please Provide a valid UserName" : null;

                        },
                        controller: userNameTextEditingController,
                        decoration: InputDecoration(
                            hintText: "User Name"
                        ),
                      ),
                      TextFormField(
                        validator: (val){return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!) ?
                        null : "Enter correct email";
                        },
                        controller: emailTextEditingController,
                        decoration: InputDecoration(
                            hintText: "Email_Id"
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val){
                          return val!.length > 6? null:"please enter correct password";
                      },
                        controller: passwordTextEditingController,
                        decoration: InputDecoration(
                            hintText: "Password"
                        ),
                      ),
                    ],
                  ),
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
                    signMeUP();
                    },
                  child: Container(
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
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.greenAccent
                      ),
                      textAlign: TextAlign.center,
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

                  child: Text("Sign up Google",style: TextStyle(
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
                    children:  [
                      Text(
                        "Already have account? ",
                        style: TextStyle(
                            fontSize: 17
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.toogle();
                        },
                        child: Text(
                          "SignIn now",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
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
