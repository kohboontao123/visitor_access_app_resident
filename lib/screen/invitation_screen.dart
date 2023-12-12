import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../widget/InvtitationList.dart';
import 'add_invitation_screen.dart';


class InvitationScreen extends StatefulWidget {
  const InvitationScreen({Key? key}) : super(key: key);

  @override
  State<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  DateTime _selectedDate = DateTime.now();

  void _onDateChange(DateTime date) {
    this.setState(() {
      this._selectedDate = date;
      Container(
        color: Colors.black,
        width: 200,
        height: 200,
      );
      InvitationList( DateTime.parse(DateFormat('yyyy-MM-dd').format(date)) );
    });
  }
  @override
  Widget build(BuildContext context) {
    var color = Color.fromARGB(190, 0, 0, 0);
    var statusIcon = Icon(Icons.pending, color: Colors.white,size: 15);
    return SafeArea(
      child: Container(
        color: Color.fromRGBO(242, 244, 255, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /*GestureDetector(
                        onTap: () {
                          widget.Goback(1);
                        },
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),*/
                      Icon(
                        Icons.search_rounded,
                        color: Colors.black,
                        size: 30,
                      )
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${DateFormat('MMM, d').format(this._selectedDate)}',
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddInvitationScreen()));
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 123, 0, 245),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                              Text(
                                "Send Invitation",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 25),
                  DatePicker(
                    DateTime.now(),
                      initialSelectedDate: this._selectedDate,
                    selectionColor: Color.fromARGB(255, 123, 0, 245),
                    onDateChange: this._onDateChange,
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Invitation List",
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                    child:  Container(
                      height:  MediaQuery.of(context).size.height* 0.45,
                      width: MediaQuery.of(context).size.width,
                      child: InvitationList( this._selectedDate),
                    ),
                  ),

                  /*SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(children: [
                      ProgressCard(
                          ProjectName: "Project", CompletedPercent: 30),
                      ProgressCard(
                          ProjectName: "Project", CompletedPercent: 30),
                      ProgressCard(
                          ProjectName: "Project", CompletedPercent: 30),
                      ProgressCard(
                          ProjectName: "Project", CompletedPercent: 30),
                    ]),
                  )*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
