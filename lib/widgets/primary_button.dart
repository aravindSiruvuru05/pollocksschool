import 'package:flutter/material.dart';
import 'package:pollocksschool/enums/enums.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final LoadingState state;

  const PrimaryButton({
    @required this.text,
    @required this.onTap,
    @required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: LoadingState.NORMAL != state
            ? null
            : EdgeInsets.all(SizeConfig.heightMultiplier * 1.7),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius:
          BorderRadius.circular(SizeConfig.heightMultiplier * 3),
        ),
        child: buildPrimaryButtonChild(),
      ),
    );
  }

  Widget buildPrimaryButtonChild() {
    print(state);
    if (state == LoadingState.NORMAL) {
      return Text(
        text,
        textAlign: TextAlign.center,
        style: AppTheme.lightTextTheme.button,
      );
    } else if (state == LoadingState.LOADING) {
      return CircularProgressIndicator(
        backgroundColor: AppTheme.accentColor,
        valueColor: new AlwaysStoppedAnimation<Color>(
            AppTheme.primaryColor),
      );
    } else {
      return Icon(
        Icons.check_circle,
        color: Colors.white,
        size: SizeConfig.heightMultiplier * 5,
      );
    }
  }
}
