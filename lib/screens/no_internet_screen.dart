
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';

class NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Please make sure you are connected to the internet...",textAlign: TextAlign.center,)),
          SizedBox(height: SizeConfig.heightMultiplier * 2,),
          SpinKitPouringHourglass(
            color: AppTheme.primaryshadeColor,
            size: SizeConfig.heightMultiplier * 6,
          ),
        ],
      );
  }
}
