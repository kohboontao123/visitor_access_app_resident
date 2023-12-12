import 'package:firebase_auth/firebase_auth.dart';

class UserModel{
  String? uid;
  String? email;
  String? name;
  String? address;
  String? gender;
  String? phoneNumber;
  String? userImage;
  String? icNumber;

  UserModel({this.uid,this.email,this.name,this.address,this.gender,this.phoneNumber,this.userImage,this.icNumber});

  factory UserModel.fromMap(map){
    return UserModel(
      uid:map['uid'],
      email: map['email'],
      name: map['name'],
      address: map['address'],
      gender: map['gender'],
      phoneNumber: map['phoneNumber'],
      userImage: map['userImage'],
      icNumber: map['icNumber'],
    );
  }
  Map<String,dynamic> toMap(){
    return{
      'uid':uid,
      'email':email,
      'name':name,
      'address':address,
      'gender':gender,
      'phoneNumber':phoneNumber,
      'userImage':userImage,
      'icNumber':icNumber,
    };
  }


}