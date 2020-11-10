import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/upload_bloc.dart';
import 'package:pollocksschool/enums/user_type.dart';
import 'package:pollocksschool/screens/screens.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/strings.dart';
import 'package:pollocksschool/utils/config/styling.dart';
import 'package:pollocksschool/utils/constants.dart';
import 'package:pollocksschool/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'sidebar/sidebar_layout.dart';

class MainScreen extends StatefulWidget {
  MainScreen({this.userType}) : super();
  final UserType userType;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>  with AutomaticKeepAliveClientMixin<MainScreen>{
  int _currentIndex;
  PageController _pageNavigationController;
  List<BottomBarItem> _bottomBarItemList;
  final PageStorageBucket bucket = PageStorageBucket();
  List<Widget> _pages;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {

    _populatePagesAndbottomBarItemsData();
    _currentIndex = 0;
    _bottomBarItemList[_currentIndex].isSelected = true;
    _pageNavigationController = PageController(initialPage: _currentIndex);
  }

  void _populatePagesAndbottomBarItemsData() {
    _pages = _getPages();

    _bottomBarItemList = [
      BottomBarItem(iconData: Icons.home, isSelected: false, title: "Feed"),
      BottomBarItem(
          iconData: Icons.dashboard, isSelected: false, title: "Feed"),
      BottomBarItem(iconData: null, isSelected: false, title: ""),
      BottomBarItem(
          iconData: Icons.notifications_active,
          isSelected: false,
          title: "Chat"),
      BottomBarItem(
          iconData: Icons.account_box, isSelected: false, title: "Profile"),
    ];
  }

  List<Widget> _getPages(){
    if(widget.userType == UserType.STUDENT)
      return [
        TimelineScreen(key: PageStorageKey("TimelineScreen"),),
        MenuScreen(),
        DashboardScreen(),
        MenuScreen(),
        ProfileScreen()
      ];
    else
      return [
        TimelineScreen(key: PageStorageKey("TimelineScreen"),),
        MenuScreen(key: PageStorageKey("jgd"),),
        Provider(
          create: (_) => UploadBloc(),
          child: UploadPostScreen(),
        ),
        MenuScreen(key: PageStorageKey("MenuScreen"),),
//        SideBarLayout()
        ProfileScreen(key: PageStorageKey("ProfileScreen"),),
      ];
  }

  Widget getFloatingActionButton(){
    if(widget.userType == UserType.STUDENT)
      return ImageFloatingActionButton(
          onPressed: () => _onTap(Constants.fabItemIndex),
          path: Strings.getLogoImagePath);
    else
      return CircleAvatar(
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(Icons.file_upload),
          color: _currentIndex == Constants.fabItemIndex ? AppTheme.primaryColor : AppTheme.accentColor,
          onPressed: () => _onTap(Constants.fabItemIndex),
        ),
        radius: SizeConfig.heightMultiplier * 4,
      );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomPadding: false,
      body: PageStorage(
        bucket: bucket,
        child: PageView(
          children: _pages,
          onPageChanged: onPageChange,
          controller: _pageNavigationController,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: getFloatingActionButton(),
      bottomNavigationBar: BottomAppBarWithNotch(
        onItemTap: _onTap,
        bottomBarItemList: _bottomBarItemList,
      ),

    );
  }

  void _onTap(int index) {
    if ((_currentIndex - index).abs() == 1) {
      _pageNavigationController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      _pageNavigationController.jumpToPage(index);
    }
    changeBottomBarIconsState(index);
  }

  void changeBottomBarIconsState(int index) {
    setState(() {
      _bottomBarItemList[_currentIndex].isSelected = false;
      _currentIndex = index;
      _bottomBarItemList[_currentIndex].isSelected = true;
    });
  }

  void onPageChange(int index) {
    _pageNavigationController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    changeBottomBarIconsState(index);
  }

  @override
  void dispose() {
    _pageNavigationController.dispose();
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}