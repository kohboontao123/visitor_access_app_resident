import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:visitor_access_app_resident/class/class.dart';
import 'package:visitor_access_app_resident/function/auth.dart';

import 'edit_resident.dart';
import 'login_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        toolbarHeight: MediaQuery.of(context).size.height*0.1,
        title: Text('Setting'),
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        shadowColor: Colors.transparent,
      ) ,
      body:  ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(left:24),
            child: ListTile(
              leading: Icon(Icons.manage_accounts),
              title: Text('Edit Profile',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black
                ),
              ),
              onTap: (){
                Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => EditResidentScreen()), (route) => false);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:24),
            child: ListTile(
              leading: Icon(Icons.password_outlined),
              title: Text('Reset Password',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black
                ),
              ),
              onTap: (){
                resetPassword();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:24),
            child: ListTile(
              leading: Icon(Icons.exit_to_app_outlined),
              title: Text('Exit',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black
                ),
              ),
              onTap: (){
                logout(context);
              },
            ),
          ),
        ],

      ),
    );
  }
  Future<void> logout(BuildContext context) async {
    AuthClass authclass=AuthClass();
    await authclass.logout();
    await FirebaseAuth.instance.signOut();
    Fluttertoast.showToast(msg: "You have been logged out");
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Future resetPassword()async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: Resident.email);
      Fluttertoast.showToast(msg: "Password Reset Email Sent");
    } on FirebaseAuthException catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message.toString());
    }
  }
}
