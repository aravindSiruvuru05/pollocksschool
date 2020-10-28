import 'package:flutter/material.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;

  const MenuItem({Key key, this.icon, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.heightMultiplier),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: AppTheme.accentColor,
              size: 30,
            ),
            SizedBox(
              width: SizeConfig.heightMultiplier * 2,
            ),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: SizeConfig.textMultiplier * 2.5, color: AppTheme.accentColor),
            )
          ],
        ),
      ),
    );
  }
}
