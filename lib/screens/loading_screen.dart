
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
       child: Center(
          child: SpinKitRipple(
            color: AppTheme.primaryColor,
            size: SizeConfig.heightMultiplier * 6,
          ),
        )
      )
    );
  }
}
