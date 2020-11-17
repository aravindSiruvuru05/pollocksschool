import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pollocksschool/enums/enums.dart';
import 'package:pollocksschool/widgets/widgets.dart';
import 'config/size_config.dart';

class DialogPopUps {
  static void showCommonDialog(
      {BuildContext context, String text, Function ok, Function cancel,}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Text(text),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            actions: [
              ok != null
                  ? PrimaryButton(
                      text: "OK",
                      onTap: ok,
                      state: LoadingState.NORMAL,
                    )
                  : SizedBox.shrink(),
            ],
          );
        });
  }

  static void showLoadingDialog(
      {BuildContext context}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SpinKitWave(
            color: Colors.white,
            size: SizeConfig.heightMultiplier * 6,
          );
        });
  }

  static void removeLoadingDialog(
      {BuildContext context}) {
    Navigator.pop(context);
  }
}
