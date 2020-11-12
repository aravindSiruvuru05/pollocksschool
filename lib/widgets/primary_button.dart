import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pollocksschool/enums/enums.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';

import '../utils/config/size_config.dart';

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
      onTap: LoadingState.NORMAL == state ? onTap : null,
      child: Container(
        padding: LoadingState.NORMAL == state
            ? EdgeInsets.all(SizeConfig.heightMultiplier * 1.7)
            : null,
        decoration: BoxDecoration(
          color: LoadingState.LOADING == state ? null : AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(SizeConfig.heightMultiplier * 3),
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
        style: AppTheme.lightTextTheme.button
            .copyWith(letterSpacing: SizeConfig.heightMultiplier / 3,color: Colors.white),
      );
    } else if (state == LoadingState.LOADING) {
      return SpinKitRipple(
        color: AppTheme.primaryColor,
        size: SizeConfig.heightMultiplier * 6,
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
