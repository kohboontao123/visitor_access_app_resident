import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class InvitationList extends StatefulWidget {
  final DateTime StartTime;

  InvitationList(this.StartTime);

  @override
  State<InvitationList> createState() => _InvitationListState();
}

class _InvitationListState extends State<InvitationList> {
  var status='';
  @override
  Widget build(BuildContext context) {
    var color = Color.fromARGB(190, 0, 0, 0);
    var statusIcon = Icon(Icons.pending, color: Colors.white,size: 15);
      return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('invitation')
            .where("residentID",isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .where("startDate",isGreaterThanOrEqualTo: DateTime.parse(DateFormat('yyyy-MM-dd').format(widget.StartTime)))
            .where("startDate",isLessThanOrEqualTo: DateTime.parse(DateFormat('yyyy-MM-dd').format(widget.StartTime.add(Duration(days:1)))))
            .snapshots(),
        builder: (BuildContext context , AsyncSnapshot<QuerySnapshot> snapshot){
          if (!snapshot.hasData) return new Center(child: Text('Loading...'),);
          if (snapshot.data!.docs.length==0){
            return new Center(child: Text('no invitation'),);
          }else{
            return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('visitor').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount:snapshot.data!.docs.length,
                      itemBuilder:(context,index){
                        for(int i = 0 ; i< streamSnapshot.data!.docs.length ;i++){
                          if (snapshot.data!.docs[index]['visitorID']==streamSnapshot.data!.docs[i]['uid']){
                            if(snapshot.data!.docs[index]['status']=="Pending"){
                              statusIcon=Icon(Icons.pending, color: Colors.white,size: 15);
                              color = Color.fromARGB(190, 35, 35, 35);
                            }else if(snapshot.data!.docs[index]['status']=="Accepted"){
                              statusIcon=Icon(Icons.check, color: Colors.white,size: 15);
                              color = Color.fromARGB(190, 30, 213, 90);
                            }else if(snapshot.data!.docs[index]['status']=="Rejected"){
                              statusIcon=Icon(Icons.close, color: Colors.white,size: 15);
                              color = Color.fromARGB(190, 236, 21, 21);
                            }else if(snapshot.data!.docs[index]['status']=="Cancel"){
                              statusIcon=Icon(Icons.close, color: Colors.white,size: 15);
                              color = Color.fromARGB(190, 11, 30, 38);
                            }
                            return FlipCard(
                              front: Container(
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
                                width: 250,
                                height: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Invitation Details",
                                      style: GoogleFonts.montserrat(color: Colors.white,fontSize: 24),
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 45.0,
                                          backgroundImage: Image.network( streamSnapshot.data!.docs[i]['userImage']).image, //here
                                        ),
                                        SizedBox( width: 5,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(height: 5,),
                                            Text(
                                              streamSnapshot.data!.docs[i]['name'],
                                              style: GoogleFonts.montserrat(color: Colors.white),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              children: [
                                                Icon(Icons.access_time_sharp, color: Colors.white,size: 15,),
                                                SizedBox(width: 5,),
                                                Text(
                                                  "Start Date:",
                                                  style: GoogleFonts.montserrat(color: Colors.white, fontSize: 12),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '${DateFormat.yMMMMEEEEd().format(snapshot.data!.docs[index]['startDate'].toDate())}',
                                              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 12),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.access_time_sharp, color: Colors.white,size: 15),
                                                SizedBox(width: 5,),
                                                Text(
                                                  "End Date:",
                                                  style: GoogleFonts.montserrat(color: Colors.white, fontSize: 12),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '${DateFormat.yMMMMEEEEd().format(snapshot.data!.docs[index]['startDate'].toDate())}',
                                              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 12),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 2,),
                                            Row(
                                              children: [
                                                statusIcon,
                                                SizedBox(width: 5,),
                                                Text(
                                                  "Status:",
                                                  style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(width: 10,),
                                                Text(
                                                  snapshot.data!.docs[index]['status'],
                                                  style: GoogleFonts.montserrat(color: Colors.white, fontSize: 15),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),

                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: color),
                              ),
                              back: Container(
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                                width: 250,
                                height: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Visitor Details",
                                      style: GoogleFonts.montserrat(color: Colors.white,fontSize: 24),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 45.0,
                                          backgroundImage: Image.network( streamSnapshot.data!.docs[i]['userImage']).image, //here
                                        ),
                                        SizedBox( width: 20,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(height: 5,),
                                            Text(
                                              streamSnapshot.data!.docs[i]['name'],
                                              style: GoogleFonts.montserrat(color: Colors.white),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              children: [
                                                Icon(Icons.email, color: Colors.white,),
                                                SizedBox(width: 5,),
                                                Text(
                                                  "Email:",
                                                  style: GoogleFonts.montserrat(color: Colors.white, fontSize: 12),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              streamSnapshot.data!.docs[i]['email'],
                                              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 10),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.phone, color: Colors.white,),
                                                SizedBox(width: 5,),
                                                Text(
                                                  "Phone Number:",
                                                  style: GoogleFonts.montserrat(color: Colors.white, fontSize: 12),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              streamSnapshot.data!.docs[i]['phoneNumber'],
                                              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 10),
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        )
                                      ],
                                    ),

                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: color),
                              ),
                            );
                          }

                        }
                        return Row();
                      }
                  );
                }
            );
          }
        },

      );
    }

  }

