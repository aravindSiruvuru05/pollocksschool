import 'package:flutter/material.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/strings.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(SizeConfig.heightMultiplier * 3),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: SizeConfig.heightMultiplier * 3,
          crossAxisSpacing: SizeConfig.heightMultiplier * 3,
          children: List.generate(7 ,(index){
            return InkWell(
              onTap: () => print("tappeed"),
              child: Container(
                margin: EdgeInsets.all(SizeConfig.heightMultiplier),
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(Strings.getLogoImagePath))
                ),
              ),
            );
          }),
        )
      ),
    );
  }
}
