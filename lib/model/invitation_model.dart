
import 'package:cloud_firestore/cloud_firestore.dart';

class InvitationModel{
  DateTime? startDate;
  DateTime? endDate;
  DateTime? inviteDate;
  DateTime? gatekeeperRespondDate;
  String? residentID;
  String? visitorID;
  String? status;
  String? checkInStatus;
  String? checkInBy;

  InvitationModel({this.startDate,this.endDate,this.inviteDate,this.residentID,this.visitorID,this.status,this.checkInStatus,this.checkInBy,this.gatekeeperRespondDate});

  factory InvitationModel.fromMap(map){
    return InvitationModel(
      startDate:map['startDate'],
      endDate: map['endDate'],
      inviteDate: map['inviteDate'],
      residentID: map['residentID'],
      visitorID: map['visitorID'],
      status: map['status'],
      checkInStatus:map['checkInStatus'],
      checkInBy:map['checkInBy'],
        gatekeeperRespondDate:map['gatekeeperRespondDate']
    );
  }
  Map<String,dynamic> toMap(){
    return{
      'startDate':Timestamp.fromDate(startDate!),
      'endDate':Timestamp.fromDate(endDate!),
      'inviteDate':inviteDate,
      'residentID':residentID,
      'visitorID':visitorID,
      'status':status,
      'checkInStatus':checkInStatus,
      'checkInBy':checkInBy,
      'gatekeeperRespondDate':gatekeeperRespondDate
    };
  }

}