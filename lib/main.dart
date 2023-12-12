import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:visitor_access_app_resident/screen/bottom_bar.dart';


import 'class/class.dart';
import 'function/auth.dart';
import 'screen/home_screen.dart';
import 'screen/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  /*WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( options: const FirebaseOptions(
    apiKey: "AAAA8eTjZ2c:APA91bEW1bmGlZIP59wnFfyVAUCfAb1e-6677HEo7WvVCTMUGrYOgeN18bSyWpiKiSvhsvSnGRNJ7OwNREGUbXK12dPACGrsJ-pihDzV3WHeSmK1r-ANafx0aCiKpLGjYLaazUPZfr3P", // Your apiKey
    appId: "1:1038927226727:android:227c7e95bd5301f59771c2", // Your appId
    messagingSenderId: "1038927226727", // Your messagingSenderId
    projectId: "fypproject-42f8d", // Your projectId
  ));*/
  runApp(const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState(){
    super.initState();
    checkLogin();
  }
  Widget currentPage =LoginScreen();
  AuthClass authclass=AuthClass();
  void checkLogin() async{

    String? token=await authclass.getToken();
    print(token);
    if (token!=null){
      Fluttertoast.showToast(msg:'logging...');
      FirebaseFirestore.instance
          .collection('resident').doc(token).get()
          .then((DocumentSnapshot documentSnapshot) =>{
        Resident.uid=documentSnapshot['uid'],
        Resident.userImage=documentSnapshot['userImage'],
        Resident.name=documentSnapshot['name'],
        Resident.icNumber=documentSnapshot['icNumber'],
        Resident.address=documentSnapshot['address'],
        Resident.phoneNumber=documentSnapshot['phoneNumber'],
        Resident.gender=documentSnapshot['gender'],
        Resident.email=documentSnapshot['email'],
        Resident.status=documentSnapshot['status'],
        if(documentSnapshot['status']=='active'){
          setState((){
            currentPage=BottomBar(0);
          }),
        }else{
          Fluttertoast.showToast(msg: 'Your account has been deactivated, please contact admin'),
          setState((){
            currentPage=LoginScreen();
          }),
        }


      }).catchError((error) =>
      {
        Fluttertoast.showToast(msg: error.toString()),
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: MaterialApp(
          title: 'Visitor Application',
          theme: ThemeData(

            primarySwatch: Colors.blue,
          ),
          home://LoginScreen(),
          currentPage,
          //IDTypeScreen(),
          //ScanFaceScreen(),
          //RegisterScreen(),
        ),
      onWillPop: () async {
        return false;
      },
    );
  }

}


