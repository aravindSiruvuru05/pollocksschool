
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';

class CustomFlushBar {

  static Flushbar customFlushBar({@required String title,@required String message,@required GlobalKey scaffoldKey}) {
    return Flushbar(
      title:  title,
      barBlur: 5,
      animationDuration: Duration(milliseconds: 500),
      margin: EdgeInsets.all(SizeConfig.heightMultiplier * 2 ),
      borderRadius: SizeConfig.heightMultiplier,
      message:  message,
      duration:  Duration(seconds: 3),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      backgroundGradient: LinearGradient(
          colors: [AppTheme.primaryColor, Color(0xff4059F1)]),
      boxShadows: [
          BoxShadow(
              color: AppTheme.primaryTextFieldColor.withOpacity(0.2),
              spreadRadius: 4.0)
      ],
      leftBarIndicatorColor: Color(0xff4059F1),
      icon: Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
    )..show(scaffoldKey.currentContext);
  }
}