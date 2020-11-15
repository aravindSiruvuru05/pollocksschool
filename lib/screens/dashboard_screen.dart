import 'package:flutter/material.dart';
import 'package:pollocksschool/utils/config/size_config.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(SizeConfig.heightMultiplier * 3),
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(7 ,(index){
            return Container(
              child: Card(
                color: Colors.blue,
              ),
            );
          }),
        )
      ),
    );
  }
}
