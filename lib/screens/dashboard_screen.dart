import 'package:flutter/material.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/strings.dart';
import 'package:pollocksschool/utils/config/styling.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(SizeConfig.heightMultiplier * 3),
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(8,(index){
            return InkWell(
              onTap: () =>  _onCardTapped(context),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  shadowColor: AppTheme.primaryColor,
                  elevation: 5,
                  color: Colors.white,
                  child: Image(image: AssetImage(Strings.getLogoImagePath),),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _onCardTapped(BuildContext context) {
//    Navigator.push(context, MaterialPageRoute(builder: (context) => WebScreen()));
  }
}
