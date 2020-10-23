import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/screens/screens.dart';
import 'package:pollocksschool/utils/config/strings.dart';
import 'package:pollocksschool/utils/constants.dart';
import 'package:pollocksschool/widgets/widgets.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex;
  PageController _pageNavigationController;
  List<BottomBarItem> _bottomBarItemList;

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
    _pages = [
      HomeScreen(),
      MenuScreen(),
      DashboardScreen(),
      MenuScreen(),
      MenuScreen(),
    ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: _pages,
        onPageChanged: onPageChange,
        controller: _pageNavigationController,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ImageFloatingActionButton(
          onPressed: () => _onTap(Constants.fabItemIndex),
          path: Strings.getLogoImagePath),
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
}
