import 'package:flutter/material.dart';
import 'size_config.dart';

class AppTheme {
  AppTheme._();

  static const Color appBackgroundColor = Colors.white;
  static const Color accentColor = Color(0xFF9ba4b4);
  static const Color primaryColor = Color(0xFF14274e);
  static const Color primaryshadeColor = Color(0xFF394867);
  static const Color primaryTextFieldColor = Color.fromRGBO(245, 242, 252, 1);


  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppTheme.appBackgroundColor,
    primaryColor: primaryColor,
    accentColor: accentColor,
    brightness: Brightness.light,
    textTheme: lightTextTheme,
    fontFamily: "HelveticaNeue"
  );

  static final TextTheme lightTextTheme = TextTheme(
    headline6: _titleLight,
    subtitle2: _subTitleLight2, // error text
    button: _buttonLight,
    headline4: _textFieldLabelLight,
    headline3: _searchLight,
    bodyText2: _selectedTabLight,
    bodyText1: _unSelectedTabLight,
  );

  static final TextStyle _titleLight = TextStyle(
    color: Colors.black,
    fontSize: 3 * SizeConfig.textMultiplier,
  );

  // Error text
  static final TextStyle _subTitleLight2 = TextStyle(
    color: Colors.black87,
    fontSize: 1.5 * SizeConfig.textMultiplier,
  );

  static final TextStyle otpsubtitle = TextStyle(
    color: AppTheme.accentColor,
    fontSize: 2 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w500
  );

  static final TextStyle _buttonLight = TextStyle(
    color: Colors.white,
    fontSize: 2.5 * SizeConfig.textMultiplier,
  );

  static final TextStyle _textFieldLabelLight = TextStyle(
    color: Colors.black,
    fontSize: 2.1 * SizeConfig.textMultiplier,
  );

  static final TextStyle _searchLight = TextStyle(
    color: Colors.black,
    fontSize: 2.3 * SizeConfig.textMultiplier,
  );

  static final TextStyle _selectedTabLight = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 2 * SizeConfig.textMultiplier,
  );

  static final TextStyle _unSelectedTabLight = TextStyle(
    color: Colors.grey,
    fontSize: 2 * SizeConfig.textMultiplier,
  );
}

//  static final ThemeData darkTheme = ThemeData(
//    scaffoldBackgroundColor: Colors.black,
//    brightness: Brightness.dark,
//    textTheme: darkTextTheme,
//  );

//  static final TextTheme darkTextTheme = TextTheme(
//    headline6: _titleDark,
//    subtitle2: _subTitleDark,
//    button: _buttonDark,
//    headline4: _greetingDark,
//    headline3: _searchDark,
//    bodyText2: _selectedTabDark,
//    bodyText1: _unSelectedTabDark,
//  );

//  static final TextStyle _titleDark = _titleLight.copyWith(color: Colors.white);
//
//  static final TextStyle _subTitleDark = _subTitleLight.copyWith(color: Colors.white70);
//
//  static final TextStyle _buttonDark = _buttonLight.copyWith(color: Colors.black);
//
//  static final TextStyle _greetingDark = _greetingLight.copyWith(color: Colors.black);
//
//  static final TextStyle _searchDark = _searchDark.copyWith(color: Colors.black);
//
//  static final TextStyle _selectedTabDark = _selectedTabDark.copyWith(color: Colors.white);
//
//  static final TextStyle _unSelectedTabDark = _selectedTabDark.copyWith(color: Colors.white70);
