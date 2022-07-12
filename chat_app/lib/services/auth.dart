import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/models/user.dart' as u;
import'package:chat_app/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
class AuthMethods {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  u.User? _userFromFirebaseUser(u.User user) {
    if (user != null) {
      return u.User(uid: user.uid);
    } else {
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      u.User user = result.user as u.User;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;

    }

  }
  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      u.User user = result.user as u.User;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Future<u.User> signInWithGoogle(BuildContext context) async {
  //   final GoogleSignIn _googleSignIn = new GoogleSignIn();
  //
  //   final GoogleSignInAccount googleSignInAccount =
  //   await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleSignInAuthentication =
  //   await googleSignInAccount.authentication;
  //
  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //       idToken: googleSignInAuthentication.idToken,
  //       accessToken: googleSignInAuthentication.accessToken);
  //
  //   AuthResult result = await _auth.signInWithCredential(credential);
  //   FirebaseUser userDetails = result.user;
  //
  //   if (result == null) {
  //   } else {
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => Chat()));
  //   }
  // }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}



