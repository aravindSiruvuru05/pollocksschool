import 'package:flutter/material.dart';
import 'package:pollocksschool/screens/screens.dart';
import 'sidebar.dart';

class SideBarLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"),centerTitle: true,),
      body: Stack(
        children: <Widget>[
          ProfileScreen(),
          SideBar(),
        ],
      ),
    );
  }
}
