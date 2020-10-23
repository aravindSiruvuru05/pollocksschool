import 'package:flutter/material.dart';
import 'package:pollocksschool/utils/config/styling.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            "Home Screen", style: AppTheme.lightTheme.textTheme.headline4,
          ),
        ),
      ),
    );
  }
}
