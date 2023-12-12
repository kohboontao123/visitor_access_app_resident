import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../class/class.dart';
import '../widget/OverviewScrollWidget.dart';
import '../widget/ProgressCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: Color.fromRGBO(242, 244, 255, 1),
          padding: const EdgeInsets.all(0),
          child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15,),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Hello,",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                TextSpan(
                                  text: Resident.name,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            "Have a nice day!",
                            style: GoogleFonts.montserrat(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 123, 0, 245),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (BuildContext context){
                                      return Scaffold(
                                        body: GestureDetector(
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Hero(
                                                tag:'Resident',
                                                child: Image.network(
                                                  Resident.userImage,
                                                  fit: BoxFit.fill,),
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                            }
                                        ),
                                      );
                                    }
                                )
                            );
                          },
                          child:Container(
                            color: Colors.transparent,
                            child: CircleAvatar(
                              radius: 90.0,
                              backgroundImage: Image.network(Resident.userImage).image, //here
                            ),

                          ),
                        ),
                      ),
                    ],
                  )
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 0),
                  child: OverViewWidget(),
                ),
          ]),
        ),
      ),
    );
  }

}
