import 'package:flutter/material.dart';

import '../utils/config/size_config.dart';
import '../utils/config/styling.dart';

class CommonShadowCard extends StatelessWidget {
  final Widget child;
  const CommonShadowCard({
    Key key, this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: SizeConfig.heightMultiplier * 1.7,
          right: SizeConfig.heightMultiplier * 1.7,top: SizeConfig.heightMultiplier * 1.8),
      padding: EdgeInsets.all(SizeConfig.heightMultiplier * 1.2,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.heightMultiplier * 2),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: AppTheme.accentColor.withOpacity(0.3),
              blurRadius: 15.0,
              offset: Offset(0,0)
          ),
        ],
      ),
      child: child,
    );
  }
}
