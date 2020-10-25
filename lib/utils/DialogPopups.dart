import 'package:flutter/material.dart';
import 'package:pollocksschool/widgets/primary_button.dart';

class DialogPopUps {
  static void showCommonDialog(
      {BuildContext context, String text, Function ok, Function cancel}) {
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
                    )
                  : SizedBox.shrink(),
            ],
          );
        });
  }
}
