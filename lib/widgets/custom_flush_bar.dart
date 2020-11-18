import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/enums/enums.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';
import 'package:pollocksschool/utils/constants.dart';
import '../utils/config/size_config.dart';

class CustomFlushBar {
  static Flushbar customFlushBar(
      {@required String message, @required FlushBarType type}) {
    IconData icon;
    LinearGradient gradient;
    switch (type) {
      case FlushBarType.SUCCESS:
        {
          icon = Icons.check_circle_outline;
          gradient =
              LinearGradient(colors: [Color(0xFF233329), Color(0xFF6A9113)]);
        }
        break;
      case FlushBarType.FAILURE:
        {
          icon = Icons.error_outline;
          gradient =
              LinearGradient(colors: [Color(0xFF3F0D12), Color(0xFFA71D31)]);
        }
        break;
      case FlushBarType.UPDATE:
        {
          icon = Icons.update;
          gradient = LinearGradient(
              colors: [AppTheme.primaryColor, Color(0xFF5F0A87)]);
        }
        break;
      default:
        {
          icon = Icons.info_outline;
          gradient =
              LinearGradient(colors: [Color(0xFF3F0D12), Color(0xFFA71D31)]);
        }
    }
    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      barBlur: 5,
      animationDuration: Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier * 2),
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.heightMultiplier * 1,vertical: SizeConfig.heightMultiplier * 3),
      borderRadius: SizeConfig.heightMultiplier * 3,
      messageText: Text(
        message,
        style: AppTheme.lightTextTheme.subtitle2.copyWith(
            color: Colors.white, fontFamily: Constants.getFreightSansFamily),
      ),
      duration: Duration(milliseconds: 2000),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      backgroundGradient: gradient,
      boxShadows: [
        BoxShadow(
            color: AppTheme.primaryTextFieldColor.withOpacity(0.8),
            spreadRadius: 5.0)
      ],
      icon: Icon(
        icon,
        color: Colors.white,
      ),
    )..show(Constants.authToggleScreenScaffoldKey.currentContext);
  }
}
