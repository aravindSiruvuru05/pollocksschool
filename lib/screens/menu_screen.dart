import 'package:flutter/material.dart';
import 'package:pollocksschool/utils/config/styling.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({Key key}): super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("Comming Soon...", style: AppTheme.lightTextTheme.headline6,),
        ),
      ),
    );
  }
}
