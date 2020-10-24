import 'package:flutter/material.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';

class PrimaryTextFormField extends StatefulWidget {
  final IconData prefixIcon;
  final Function validator;
  final String labelText;
  final bool isObscureText;
  final TextEditingController controller;

  const PrimaryTextFormField(
      {Key key,
      @required this.prefixIcon,
      @required this.validator,
      @required this.labelText,
      @required this.isObscureText,
      this.controller})
      : super(key: key);

  @override
  _PrimaryTextFormFieldState createState() => _PrimaryTextFormFieldState();
}

class _PrimaryTextFormFieldState extends State<PrimaryTextFormField> {
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 5),
      padding: EdgeInsets.all(SizeConfig.heightMultiplier * 0.7),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppTheme.primaryTextFieldColor,
          boxShadow: [
            BoxShadow(
                color: AppTheme.primaryTextFieldColor.withOpacity(0.2),
                spreadRadius: 4.0)
          ]),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isObscureText,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: widget.labelText,
          hintStyle: TextStyle(
              color: AppTheme.primaryColor.withOpacity(0.5),
              fontSize: AppTheme.lightTextTheme.headline4.fontSize),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          prefixIcon: Icon(
            widget.prefixIcon,
            color: focusNode.hasFocus
                ? AppTheme.primaryColor
                : AppTheme.primaryColor.withOpacity(0.4),
            size: AppTheme.lightTextTheme.headline4.fontSize * 1.3,
          ),
          fillColor: Colors.transparent,
          filled: true,
          errorStyle: AppTheme.lightTextTheme.subtitle2,
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        validator: widget.validator,
      ),
    );
  }
}
