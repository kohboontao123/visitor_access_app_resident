import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:visitor_access_app_resident/screen/home_screen.dart';
import 'package:visitor_access_app_resident/screen/invitation_list_screen.dart';
import 'package:visitor_access_app_resident/screen/setting_screen.dart';

import 'invitation_screen.dart';

class BottomBar extends StatefulWidget {
  final int selectedIndex;
  const BottomBar( this.selectedIndex) ;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  late int _selectedIndex = widget.selectedIndex;
  void _onIndexChange(int index) {
    setState(() {
      this._selectedIndex = index;
    });
  }

  final List<Widget> _Pages = [
    HomeScreen(),
    InvitationScreen(),
    InvitationListScreen(),
    SettingScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this._Pages.elementAt(this._selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 1,
        type: BottomNavigationBarType.shifting,
        iconSize: 25,
        selectedItemColor: Color.fromARGB(255, 123, 0, 245),
        unselectedItemColor: Colors.grey.shade400,
        currentIndex: this._selectedIndex,
        onTap: this._onIndexChange,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded), label: "Tasks"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: "Invitation List"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Setting"),
        ],
      ),
    );
  }
}
