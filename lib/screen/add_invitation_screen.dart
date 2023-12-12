import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../model/invitation_model.dart';


class AddInvitationScreen extends StatefulWidget {
  const AddInvitationScreen({Key? key}) : super(key: key);

  @override
  State<AddInvitationScreen> createState() => _AddInvitationScreenState();
}

class _AddInvitationScreenState extends State<AddInvitationScreen> {
  late TextEditingController _Titlecontroller;
  late TextEditingController _StartDatecontroller;
  late TextEditingController _EndDatecontroller;
  late TextEditingController _StartTime;
  late TextEditingController _EndTime;
  late TextEditingController visitorNameController;
  late TextEditingController visitorEmailController;
  late TextEditingController visitorIcController;
  late TextEditingController visitorNumberController;
  late TextEditingController visitorStartTimeController;
  late TextEditingController visitorEndTimeController;
  final _formKey=GlobalKey<FormState>();
  late DateTime startDate = DateTime.now();
  late DateTime endDate = DateTime.now();
  DateTime SelectedDate = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _Titlecontroller = new TextEditingController();
    _StartDatecontroller = new TextEditingController(
        text: '${DateFormat('EEE, MMM d, ' 'yy').format(this.SelectedDate)}');
    _EndDatecontroller = new TextEditingController(
        text: '${DateFormat('EEE, MMM d, ' 'yy').format(this.SelectedDate)}');
    _StartTime = new TextEditingController(
        text: '${DateFormat.jm().format(DateTime.now())}');
    _EndTime = new TextEditingController(
        text: '${DateFormat.jm().format(DateTime.now().add(
          Duration(hours: 1),
        ))}');
  }

  _selectDate(BuildContext context,date) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: SelectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2122),
    );
    if (selected != null && selected != SelectedDate &&date=="StartDate") {
      setState(() {
        SelectedDate = selected;
        startDate =selected;
        if(DateTime.parse(DateFormat('yyyy-MM-dd').format(selected)).isAfter(DateTime.parse(DateFormat('yyyy-MM-dd').format(endDate)))){
          startDate =selected;
          _StartDatecontroller.text =
          '${DateFormat('EEE, MMM d, ' 'yy').format(selected)}';
          endDate = selected;
          _EndDatecontroller.text =
          '${DateFormat('EEE, MMM d, ' 'yy').format(selected)}';
        }else{
          startDate =selected;
          _StartDatecontroller.text =
          '${DateFormat('EEE, MMM d, ' 'yy').format(selected)}';
        }
      });
    }else if (selected != null && selected != SelectedDate &&date=="EndDate" ){
      setState(() {
        SelectedDate = selected;
        endDate =selected;
        if(DateTime.parse(DateFormat('yyyy-MM-dd').format(selected)).isBefore(DateTime.parse(DateFormat('yyyy-MM-dd').format(startDate)))){
          _EndDatecontroller.text =
          '${DateFormat('EEE, MMM d, ' 'yy').format(selected)}';
          endDate =selected;
          startDate = selected;
          _StartDatecontroller.text =
          '${DateFormat('EEE, MMM d, ' 'yy').format(selected)}';
        }else{
          _EndDatecontroller.text =
          '${DateFormat('EEE, MMM d, ' 'yy').format(selected)}';
          endDate =selected;
        }
      });
    }
  }

  _selectTime(BuildContext context, String Timetype) async {
    final TimeOfDay? result =
    await showTimePicker(context: context, initialTime: TimeOfDay.now(),);
    if (result != null) {
      setState(() {
        if (Timetype == "StartTime") {
          _StartTime.text = result.format(context);
        } else {
          _EndTime.text = result.format(context);
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          color: Color.fromRGBO(130, 0, 255, 1),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                      EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back,
                                size: 30, color: Colors.white),
                          ),
                          SizedBox(
                            width: 50,
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height:MediaQuery.of(context).size.height*0.1,),
                    Text(
                      "Create a new invitation",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 20,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(height:MediaQuery.of(context).size.height*0.05,),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: TextFormField(

                        controller: _Titlecontroller,
                        cursorColor: Colors.white,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        validator: (value){
                          if (value!.isEmpty){
                            return ("Please Enter Visitor E-mail/Phone Number");
                          }
                          return null;
                        },
                        onSaved:(value){
                          _Titlecontroller.text=value!;
                        },
                        decoration: InputDecoration(
                          labelText: "E-mail/Phone Number",
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          fillColor: Colors.white,
                          labelStyle: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: TextFormField(
                        controller: _StartDatecontroller,
                        cursorColor: Colors.white,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Start Date",
                          suffixIcon: GestureDetector(
                            onTap: () {
                              _selectDate(context,'StartDate');
                            },
                            child: Icon(
                              Icons.calendar_month_outlined,
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          fillColor: Colors.white,
                          labelStyle: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: TextFormField(
                        controller: _EndDatecontroller,
                        cursorColor: Colors.white,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "End Date",
                          suffixIcon: GestureDetector(
                            onTap: () {
                              _selectDate(context,"EndDate");
                            },
                            child: Icon(
                              Icons.calendar_month_outlined,
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          fillColor: Colors.white,
                          labelStyle: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox( height:20),
                    SizedBox(
                      width:MediaQuery.of(context).size.width*0.9 ,
                      height:MediaQuery.of(context).size.height*0.08,
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<
                                Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(18.0),
                                ))),
                        onPressed: () {
                          _sendInvitation();
                        },
                        icon: Icon(
                          // <-- Icon
                          Icons.send,
                          size: 24.0,
                          color:Color.fromRGBO(130, 0, 255, 1) ,
                        ),
                        label: Text('Send',
                          style: GoogleFonts.montserrat(
                            color: Color.fromRGBO(130, 0, 255, 1),
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ), // <-- Text
                      ),
                    )
                  ],
                ),
              ),
            )
          ),
        ),
      ),
    );
  }
  _createInvitation(context,String visitorID) async {
    // calling our firestore
    // calling our user model
    // sedning these values
    Fluttertoast.showToast(msg: "Please wait...");
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    InvitationModel invitationMode = InvitationModel();
    // writing all the values
    invitationMode.startDate =DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(DateFormat('yyyy-MM-dd').format(startDate) + ' 00:00:00')));
    invitationMode.endDate = DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(DateFormat('yyyy-MM-dd').format(endDate) + ' 23:59:59')));
    invitationMode.inviteDate= DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()));
    invitationMode.gatekeeperRespondDate =DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse('1999-01-21 00:00:00')));
    invitationMode.residentID=user?.uid;
    invitationMode.visitorID= visitorID;
    invitationMode.status='Pending';
    invitationMode.checkInStatus='-';
    invitationMode.checkInBy='-';



    await firebaseFirestore
        .collection("invitation")
        .doc()
        .set(invitationMode.toMap());
    Fluttertoast.showToast(msg: "Successful to send an invitation.");
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }
  Future<void> _sendInvitation() async {
    if (_formKey.currentState!.validate()){
      String visitorID;
      int count = 0;
      var collection = FirebaseFirestore.instance.collection('visitor');
      var querySnapshot = await collection.get();
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        if (data['email'].toString() == _Titlecontroller.text ||
            data['phoneNumber'].toString() == _Titlecontroller.text) {
          visitorID = data['uid'].toString();
          visitorNameController =TextEditingController(text:data['name'].toString());
          visitorEmailController =TextEditingController(text:data['email'].toString());
          visitorIcController=TextEditingController(text:data['icNumber'].toString());
          visitorNumberController=  TextEditingController(text:data['phoneNumber'].toString());
          visitorStartTimeController=  TextEditingController(text: '${DateFormat('EEE, MMM d, ' 'yy').format(startDate)}');
          visitorEndTimeController = TextEditingController(text: '${DateFormat('EEE, MMM d, ' 'yy').format(endDate)}');
          {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    scrollable: true,
                    title: Text(
                      'Invitation Confirmation',
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
                              enabled: false,
                              controller:visitorNameController ,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                icon: Icon(Icons.account_box),
                              ),
                            ),
                            TextFormField(
                              enabled: false,
                              controller:visitorEmailController ,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                icon: Icon(Icons.email),
                              ),
                            ),
                            TextFormField(
                              enabled: false,
                              controller:visitorIcController,
                              decoration: InputDecoration(
                                labelText: 'IC number',
                                icon: Icon(Icons.perm_identity ),
                              ),
                            ),
                            TextFormField(
                              enabled: false,
                              controller:visitorNumberController,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                icon: Icon(Icons.phone ),
                              ),
                            ),
                            TextFormField(
                              enabled: false,
                              controller:visitorStartTimeController,
                              decoration: InputDecoration(
                                labelText: 'Start Date',
                                icon: Icon(Icons.access_time_outlined ),
                              ),
                            ),
                            TextFormField(
                              enabled: false,
                              controller:visitorEndTimeController,
                              decoration: InputDecoration(
                                labelText: 'End Date',
                                icon: Icon(Icons.access_time_outlined ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton.icon(
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<
                                    Color>(Colors.green),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(18.0),
                                    ))),
                            onPressed: () {
                              _createInvitation(context,visitorID);
                            },
                            icon: Icon(
                              // <-- Icon
                              Icons.check,
                              size: 24.0,
                            ),
                            label: Text('Send'), // <-- Text
                          ),
                          SizedBox(
                            width: 50,
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
                              Navigator.of(context, rootNavigator: true).pop('dialog');
                            },
                            icon: Icon(
                              // <-- Icon
                              Icons.close,
                              size: 24.0,
                            ),
                            label: Text('Cancel'), // <-- Text
                          ),
                        ],
                      ),
                    ],
                  );
                });
          }
          count++;
          break;
        }
      }
      if (count == 0)  {
        Fluttertoast.showToast(msg: 'User not found!');
      }
    }
  }
}
