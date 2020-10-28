import 'package:flutter/material.dart';
import 'package:pollocksschool/utils/config/strings.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        image:  DecorationImage(
          image: AssetImage(Strings.getSplashImagePath),
          fit: BoxFit.cover,
        ),

      ),
    );
  }
}
