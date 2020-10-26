import 'package:flutter/material.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';
import 'dart:ui' as ui;

class DashboardCard extends StatelessWidget {
  final String text;

  const DashboardCard({
    Key key,this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Stack(
        overflow: Overflow.clip,
        children: [
          Container(
            height: 200,
            width: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              gradient: LinearGradient(
                colors: [Colors.pink,Colors.red],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                    color: AppTheme.accentColor.withOpacity(0.5),
                    blurRadius: 12.0,
                    offset: Offset(3, 10)
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: CustomPaint(
              size: Size(100, 150),
              painter: CustomCardRightShapePainter(20,Colors.red,Colors.pink),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: SizeConfig.heightMultiplier * 2,left: SizeConfig.heightMultiplier * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text,
                    style: AppTheme.lightTextTheme.headline6
                        .copyWith(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500
                    ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier,
                ),
                Text("some random discription",
                  style: AppTheme.lightTextTheme.headline3
                      .copyWith(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomCardRightShapePainter extends CustomPainter{
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardRightShapePainter(this.radius, this.startColor, this.endColor);
  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;
    var paint = Paint();

    paint.shader = ui.Gradient.linear(
      Offset(0,0), Offset(size.width, size.height) , [
        HSLColor.fromColor(startColor).withLightness(0.8).toColor(),endColor
    ]
    );

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width,0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius , 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
