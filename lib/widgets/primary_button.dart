import 'package:flutter/material.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function onTap;

  const PrimaryButton({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required this.text,
    this.onTap,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(SizeConfig.heightMultiplier * 1.7),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(SizeConfig.heightMultiplier * 3),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTheme.lightTextTheme.button,
        ),
      ),
    );
  }
}
