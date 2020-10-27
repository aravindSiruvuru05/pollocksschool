import 'package:flutter/material.dart';
import 'package:pollocksschool/screens/profile_screen.dart';
import 'sidebar.dart';

class SideBarLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ProfileScreen(),
          SideBar(),
        ],
      ),
    );
  }
}
