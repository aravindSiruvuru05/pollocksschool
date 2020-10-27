import 'package:flutter/material.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/strings.dart';
import 'package:pollocksschool/utils/config/styling.dart';
import 'package:pollocksschool/widgets/widgets.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(SizeConfig.heightMultiplier * 3),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier),
              child: DashboardCard(text: "Pollocks Intilli",),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier),
              child: DashboardCard(text: "Pollocks children",),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier),
              child: DashboardCard(text: "Pollocks Intilli",),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier),
              child: DashboardCard(text: "Pollocks Intilli",),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier),
              child: DashboardCard(text: "Pollocks Intilli",),
            ),

          ],
        )
      ),
    );
  }

  void _onCardTapped(BuildContext context) {
//    Navigator.push(context, MaterialPageRoute(builder: (context) => WebScreen()));
  }
}
