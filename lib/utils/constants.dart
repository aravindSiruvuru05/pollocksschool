import 'package:flutter/material.dart';
import 'package:pollocksschool/utils/config/size_config.dart';

class Constants {
  Constants._();

  static int fabItemIndex = 2;
  static String getFreightSansFamily = "FreightSans";
  static String getHelveticaNeueFamily = "HelveticaNeue";
  static double commonIconSize = SizeConfig.heightMultiplier * 4;
  static int getOtpLength = 6;


  static String getSettingString = "Settings";
  static String getLogoutString = "Logout";

  static String getDeleteString = "Delete";

  static List<String> getMenuChoices = [getSettingString,getLogoutString];
  static List<String> getCommentMenuChoices = [getDeleteString];


  static GlobalKey<ScaffoldState> mainScreenScaffoldKey = GlobalKey<ScaffoldState>();


}