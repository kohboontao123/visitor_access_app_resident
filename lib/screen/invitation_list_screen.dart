import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../class/class.dart';

class InvitationListScreen extends StatefulWidget {
  const InvitationListScreen({Key? key}) : super(key: key);

  @override
  State<InvitationListScreen> createState() => _InvitationListScreenState();
}

class _InvitationListScreenState extends State<InvitationListScreen> {
  TextEditingController _searchTextController = TextEditingController();
  List<DocumentSnapshot> documents = [];
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight:  MediaQuery
            .of(context)
            .size
            .height * 0.01,
        toolbarOpacity: 0.8,
        elevation: 0.00,

      ),
      body: SafeArea(
        child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 16 , right: 16 ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.1,
                    child:Center(
                      child:  TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(color: Colors.black),
                        controller: _searchTextController,
                        onChanged: (value) {
                          setState(() {
                            searchText = value;
                          });
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white60,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.blue,
                                  width: 0.0),

                            ),
                            hintText: "Visitor Name/PhoneNumber",
                            prefixIcon: Icon(Icons.search),
                            prefixIconColor: Colors.black
                        ),
                      ),
                    )
                  ),
                  SizedBox(height: 20,),
                  Expanded(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection(
                            'invitation')
                            .where("residentID", isEqualTo: Resident.uid)
                            .orderBy('startDate', descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          return StreamBuilder(
                              stream: FirebaseFirestore.instance.collection(
                                  'visitor').snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<
                                  QuerySnapshot> streamSnapshot) {
                                documents = streamSnapshot.data!.docs;
                                if (searchText.length > 0) {
                                  if (RegExp(r'^[0-9]+$').hasMatch(
                                      searchText)) {
                                    documents = documents.where((element) {
                                      return element.get('phoneNumber')
                                          .toString()
                                          .toLowerCase()
                                          .contains(searchText.toLowerCase());
                                    }).toList();
                                  } else {
                                    documents = documents.where((element) {
                                      return element.get('name')
                                          .toString()
                                          .toLowerCase()
                                          .contains(searchText.toLowerCase());
                                    }).toList();

                                  }
                                }
                                return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      for (int i = 0; i < documents.length; i++) {
                                        if (documents[i]['uid'] == snapshot.data!.docs[index]['visitorID'] ) {
                                          var iconStatus;
                                          if (snapshot.data!.docs[index]['status']=='Accepted' ){
                                            if(snapshot.data!.docs[index]['checkInStatus']=='-'){
                                              if (DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(snapshot.data!.docs[index]['endDate'].toDate())).isBefore(DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())))==true){
                                                updateInvitationInformation(snapshot.data!.docs[index].id);
                                              }
                                            }
                                            if(snapshot.data!.docs[index]['checkInStatus']=='CheckIn'){
                                              iconStatus=Icon(
                                                Icons.check_box_rounded,
                                                color: Colors.white,
                                              );
                                            }else{
                                              iconStatus=Icon(
                                                Icons.check_box_outline_blank,
                                                color: Colors.white,
                                              );
                                            }
                                          }else if (snapshot.data!.docs[index]['status']=='Rejected'){
                                            iconStatus=Icon(
                                              Icons.browser_not_supported,
                                              color: Colors.white,
                                            );
                                          }else if (snapshot.data!.docs[index]['status']=='Pending'){
                                            if (DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(snapshot.data!.docs[index]['endDate'].toDate())).isBefore(DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())))==true){
                                              updateInvitationInformation(snapshot.data!.docs[index].id);
                                            }
                                            iconStatus=Icon(
                                              Icons.schedule,
                                              color: Colors.white,
                                            );
                                          }else{
                                            iconStatus=Icon(
                                              Icons.cancel,
                                              color: Colors.white,
                                            );
                                          }
                                          return GestureDetector(
                                            onTap:(){
                                              _showInvitationDetails(snapshot.data!.docs[index].id,  documents![i]['uid']);
                                            },
                                            child: Column(
                                                children: [
                                                  ListTile(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .only(
                                                            topLeft: Radius
                                                                .circular(25),
                                                            topRight: Radius
                                                                .circular(25),
                                                            bottomRight: Radius
                                                                .circular(25),
                                                            bottomLeft: Radius
                                                                .circular(25))),
                                                    tileColor: snapshot.data!.docs[index]['status'] == 'Accepted' ? Colors.green :
                                                    snapshot.data!.docs[index]['status'] == 'Rejected' ? Colors.red:
                                                    snapshot.data!.docs[index]['status'] == 'Pending' ? Colors.grey:
                                                    Color.fromARGB(190, 11, 30, 38),
                                                    textColor: Colors.white,
                                                    contentPadding: EdgeInsets
                                                        .only(top: 4,
                                                        bottom: 10,
                                                        left: 0,
                                                        right: 6),
                                                    title: Text(
                                                      documents![i]['name'],
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    subtitle: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(height: 10,),
                                                          Row(
                                                            children: [
                                                              Icon(Icons
                                                                  .phone,
                                                                color: Colors
                                                                    .white,
                                                                size: 15,),
                                                              SizedBox(width: 5,),
                                                              Text(
                                                                "Phone Number:",
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 12),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 5,),
                                                          Text(
                                                            documents[i]['phoneNumber'],
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12),
                                                          ),
                                                          SizedBox(height: 10,),
                                                          Row(
                                                            children: [
                                                              Icon(Icons
                                                                  .access_time_sharp,
                                                                color: Colors
                                                                    .white,
                                                                size: 15,),
                                                              SizedBox(width: 5,),
                                                              Text(
                                                                "Start Date:",
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 12),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 5,),
                                                          Text(
                                                            '${DateFormat
                                                                .yMMMMEEEEd()
                                                                .format(
                                                                snapshot.data!
                                                                    .docs[index]['startDate']
                                                                    .toDate())}',
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12),
                                                          ),
                                                          SizedBox(height: 10,),
                                                          Row(
                                                            children: [
                                                              Icon(Icons
                                                                  .access_time_sharp,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 15),
                                                              SizedBox(width: 5,),
                                                              Text(
                                                                "End Date:",
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 12),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 5,),
                                                          Text(
                                                            '${DateFormat
                                                                .yMMMMEEEEd()
                                                                .format(
                                                                snapshot.data!
                                                                    .docs[index]['endDate']
                                                                    .toDate())}',
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12),
                                                          ),
                                                          SizedBox(height: 10,),
                                                          Row(
                                                            children: [
                                                              Icon(Icons
                                                                  .library_add_check,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 15),
                                                              SizedBox(width: 5,),
                                                              Text(
                                                                "Check In Status:",
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 12),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 5,),
                                                          Text(

                                                                snapshot.data!
                                                                    .docs[index]['checkInStatus'],
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12),
                                                          ),
                                                        ]
                                                    ),
                                                    trailing:  Container(
                                                        height: double.infinity,
                                                        child:Tooltip(
                                                          message: 'Check in status',
                                                          child:  iconStatus,
                                                        )
                                                    ),
                                                    leading: CircleAvatar(
                                                      radius: 45.0,
                                                      backgroundImage: Image
                                                          .network(
                                                          documents![i]['userImage'])
                                                          .image, //here
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,)
                                                ]
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

                    ),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
  Future<void> _showInvitationDetails(String invitationID,String visitorID) async {
    var collection = FirebaseFirestore.instance.collection('visitor') .where("uid", isEqualTo: visitorID);
    var querySnapshot = await collection.get();
    var iconButton ;
    Map<String, dynamic> data;
    FirebaseFirestore.instance
        .collection('invitation').doc(invitationID).get()
        .then((DocumentSnapshot documentSnapshot) =>{
      if (documentSnapshot.exists){
        for(var queryDocumentSnapshot in querySnapshot.docs){
          data = queryDocumentSnapshot.data(),
          if (documentSnapshot['status']=='Pending'){
            iconButton=Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<
                          Color>(Colors.pink),
                      shape: MaterialStateProperty.all<
                          RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(18.0),
                          ))),
                  onPressed: () {
                    updateInvitationStatus(invitationID,data['name'].toString(), 'Cancel');
                  },
                  icon: Icon(
                    // <-- Icon
                    Icons.highlight_remove,
                    size: 24.0,
                  ),
                  label: Text('Cancel Invitation'), // <-- Text
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<
                          Color>(Colors.red),
                      shape: MaterialStateProperty.all<
                          RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(18.0),
                          ))),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop(
                        'dialog');
                  },
                  icon: Icon(
                    // <-- Icon
                    Icons.cancel,
                    size: 24.0,
                  ),
                  label: Text('Close'), // <-- Text
                ),
              ],
            ),
          }else{
            iconButton=Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<
                          Color>(Colors.red),
                      shape: MaterialStateProperty.all<
                          RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(18.0),
                          ))),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop(
                        'dialog');
                  },
                  icon: Icon(
                    // <-- Icon
                    Icons.cancel,
                    size: 24.0,
                  ),
                  label: Text('Close'), // <-- Text
                ),
              ],
            ),
          },
          data = queryDocumentSnapshot.data(),
          if (data['uid'].toString()== documentSnapshot['visitorID'].toString()){
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    scrollable: true,
                    title: Text(
                      'Invitation Details',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 20,
                        decoration: TextDecoration.none,
                      ),),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 50.0,
                              backgroundImage: Image.network(data['userImage'].toString()).image, //here
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 3,
                              enabled: false,
                              controller:TextEditingController(text:data['name'].toString()) ,
                              decoration: InputDecoration(
                                labelText: 'Visitor Name',
                                icon: Icon(Icons.account_box),
                              ),
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 3,
                              enabled: false,
                              controller:TextEditingController(text:data['address'].toString()) ,
                              decoration: InputDecoration(
                                labelText: 'Visitor Address',
                                icon: Icon(Icons.location_on),
                              ),
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 3,
                              enabled: false,
                              controller:TextEditingController(text:data['phoneNumber'].toString()),
                              decoration: InputDecoration(
                                labelText: 'Visitor Phone Number',
                                icon: Icon(Icons.phone ),
                              ),
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 3,
                              enabled: false,
                              controller:TextEditingController(text: '${DateFormat('EEE, MMM d, ' 'yy').format(documentSnapshot['startDate'].toDate())}'),
                              decoration: InputDecoration(
                                labelText: 'Start Date',
                                icon: Icon(Icons.access_time_outlined ),
                              ),
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 3,
                              enabled: false,
                              controller:TextEditingController(text: '${DateFormat('EEE, MMM d, ' 'yy').format(documentSnapshot['endDate'].toDate())}'),
                              decoration: InputDecoration(
                                labelText: 'End Date',
                                icon: Icon(Icons.access_time_outlined ),
                              ),
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 3,
                              enabled: false,
                              controller:TextEditingController(text: '${ documentSnapshot['status'].toString()}'),
                              decoration: InputDecoration(
                                labelText: 'Status',
                                icon: Icon(Icons.list ),
                              ),
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 3,
                              enabled: false,
                              controller:TextEditingController(text: '${ documentSnapshot['checkInStatus'].toString()}'),
                              decoration: InputDecoration(
                                labelText: 'Status',
                                icon: Icon(Icons.library_add_check ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      iconButton,
                    ],
                  );
                }
            )
          }
          else{
            Row(),
          }
        }

      }else{
        Row(),
      }
    });

  }

  void updateInvitationStatus(String documentID,String name, String status){

    var collection = FirebaseFirestore.instance.collection('invitation');
    collection
        .doc(documentID) // <-- Doc ID where data should be updated.
        .update({'status':status}) // <-- Nested value
        .then((_) => Fluttertoast.showToast(msg: "You have successfully uninvited $name"),

    )
        .catchError((error) =>  Fluttertoast.showToast(msg: 'Update failed: $error'));
    Navigator.of(context, rootNavigator: true).pop(
        'dialog');
  }
  updateInvitationInformation(String docID){
    var collection = FirebaseFirestore.instance.collection('invitation');
    collection
        .doc(docID) // <-- Doc ID where data should be updated.
        .update({'checkInStatus':'Expired',
      'status':'Rejected'
    }); // <-- Nested value;
  }
}
