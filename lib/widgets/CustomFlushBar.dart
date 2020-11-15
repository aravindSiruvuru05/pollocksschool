
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/enums/flushbar_type.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';
import 'package:pollocksschool/utils/constants.dart';

class CustomFlushBar {

  static Flushbar customFlushBar({@required String message,@required GlobalKey scaffoldKey,@required FlushBarType type}) {
    IconData icon;
    LinearGradient gradient;
    switch(type){
      case FlushBarType.SUCCESS:{
        icon = Icons.check_circle_outline;
        gradient =  LinearGradient(
            colors: [Color(0xFF233329), Color(0xFF6A9113)]);
      }break;
      case FlushBarType.FAILURE:{
        icon = Icons.error_outline;
        gradient =  LinearGradient(
            colors: [Color(0xFFA71D31), Color(0xFF3F0D12)]);
      } break;
      case FlushBarType.UPDATE:{
        icon = Icons.update;
        gradient =  LinearGradient(
            colors: [AppTheme.primaryColor, Color(0xFF5F0A87)]);
      } break;
      default:{
        icon = Icons.update;
        gradient =  LinearGradient(
            colors: [Color(0xFFB91372), Color(0xFF6B0F1A)]);
      }
    }
    return Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
      barBlur: 5,
      animationDuration: Duration(milliseconds: 300),
      padding: EdgeInsets.all(SizeConfig.heightMultiplier * 2 ),
      margin: EdgeInsets.all(SizeConfig.heightMultiplier * 2 ),
      borderRadius: SizeConfig.heightMultiplier *3,
      messageText:  Text(message,style: AppTheme.lightTextTheme.button.copyWith(color: Colors.white,fontFamily: Constants.getFreightSansFamily),),
      duration:  Duration(seconds: 3),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      backgroundGradient: gradient,
      boxShadows: [
          BoxShadow(
              color: AppTheme.primaryTextFieldColor.withOpacity(0.8),
              spreadRadius: 5.0)
      ],
      icon: Icon(icon, color: Colors.white),
    )..show(scaffoldKey.currentContext);
  }
}