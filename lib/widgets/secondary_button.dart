import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pollocksschool/enums/enums.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final LoadingState state;

  const SecondaryButton({
    @required this.text,
    this.onTap,
    this.state,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(SizeConfig.heightMultiplier * 1),
        child: buildSecondaryButtonChild(),
      ),
    );
  }

  Widget buildSecondaryButtonChild() {
    print(state);
    if (state == LoadingState.NORMAL) {
      return Text(
        text,
        textAlign: TextAlign.center,
        style: AppTheme.lightTextTheme.button
            .copyWith(color: AppTheme.primaryColor),
      );
    } else if (state == LoadingState.LOADING) {
      return SpinKitRipple(
        color: AppTheme.primaryColor,
        size: SizeConfig.heightMultiplier * 5,
      );
    } else {
      return Icon(
        Icons.check_circle,
        color: AppTheme.primaryColor,
        size:  SizeConfig.heightMultiplier * 5,
      );
    }
  }
}
