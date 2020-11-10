import 'dart:async';
import 'dart:math';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/blocs.dart';
import 'package:pollocksschool/enums/enums.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';
import 'package:provider/provider.dart';

import '../sidebar/menu_item.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>
    with SingleTickerProviderStateMixin<SideBar> {
  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = StreamController<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    AuthBloc authBloc = Provider.of<AuthBloc>(context);

    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSideBarOpenedAsync) {
        return AnimatedPositioned(
          curve: Curves.easeOutSine,
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left:
          isSideBarOpenedAsync.data ? screenWidth * 0.32 : screenWidth - 45,
          right: isSideBarOpenedAsync.data ? -screenWidth * 0.32 : -screenWidth,
          child: Row(
            children: <Widget>[
//              Align(
//                alignment: Alignment(0, -1.05),
//                child: GestureDetector(
//                  onTap: () {
//                    onIconPressed();
//                  },
//                  child: Transform.rotate(
//                    angle: pi,
//                    child: ClipPath(
//                      clipper: CustomMenuClipper(),
//                      child: Container(
//                        padding: EdgeInsets.only(right: SizeConfig.heightMultiplier * 5),
//                        width: 38,
//                        height: 110,
//                        color: Colors.transparent,
//                        alignment: Alignment.centerLeft,
//                        child: AnimatedIcon(
//                          progress: _animationController.view,
//                          icon: AnimatedIcons.menu_close,
//                          color: Colors.white,
//                          size: 26,
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//              SizedBox(width: SizeConfig.heightMultiplier * 5,),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: AppTheme.primaryColor,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: SizeConfig.heightMultiplier * 6,),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left:SizeConfig.heightMultiplier *6),
                          child: CircleAvatar(
                                child: Icon(
                                  Icons.perm_identity,
                                  color: Colors.white,
                                ),
                                radius: SizeConfig.heightMultiplier * 7,
                              ),
                        ),
                      ],
                    ),
//                      ListTile(
//                        contentPadding: EdgeInsets.all(0),
//                        title: Text(
//                          "${authBloc.getCurrentUser.firstname} ${authBloc.getCurrentUser.lastname}",
//                          style: TextStyle(
//                              color: Colors.white,
//                              fontSize: SizeConfig.heightMultiplier * 4,
//                              fontWeight: FontWeight.w800),
//                        ),
//                        subtitle: Text(
//                          "class : 1A",
//                          style: TextStyle(
//                            color: AppTheme.primaryshadeColor,
//                            fontSize: SizeConfig.heightMultiplier * 2,
//                          ),
//                        ),
//                        leading: CircleAvatar(
//                          child: Icon(
//                            Icons.perm_identity,
//                            color: Colors.white,
//                          ),
//                          radius: 40,
//                        ),
//                      ),
                      SizedBox(height: SizeConfig.heightMultiplier * 6,),

                      MenuItem(
                        icon: Icons.account_circle,
                        title: "My Profile",
                        onTap: () {
                          onIconPressed();
                        },
                      ),
                      MenuItem(
                        icon: Icons.person,
                        title: "My Account",
                        onTap: () {
                          onIconPressed();
                        },
                      ),
                      Divider(
                        height: 64,
                        thickness: 0.5,
                        color: Colors.white.withOpacity(0.3),
                        indent: 32,
                        endIndent: 32,
                      ),
                      MenuItem(
                        icon: Icons.settings,
                        title: "Settings",
                      ),
                      MenuItem(
                        icon: Icons.exit_to_app,
                        title: "Logout",
                        onTap: () {
                          authBloc.signOut();
                          authBloc.loginButtonStateSink(LoadingState.NORMAL);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}