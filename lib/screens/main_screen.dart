import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pollocksschool/blocs/upload_bloc.dart';
import 'package:pollocksschool/enums/flushbar_type.dart';
import 'package:pollocksschool/enums/user_type.dart';
import 'package:pollocksschool/models/models.dart';
import 'package:pollocksschool/screens/no_internet_screen.dart';
import 'package:pollocksschool/screens/screens.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/strings.dart';
import 'package:pollocksschool/utils/config/styling.dart';
import 'package:pollocksschool/utils/constants.dart';
import 'package:pollocksschool/widgets/CustomFlushBar.dart';
import 'package:pollocksschool/widgets/widgets.dart';
import 'package:provider/provider.dart';

GlobalKey<ScaffoldState> mainScreenScaffoldKey = GlobalKey<ScaffoldState>();


Future<dynamic> myBackgroundHandler(Map<String, dynamic> message) {
  return _MainScreenState()._showNotification(message);
}


class MainScreen extends StatefulWidget {
  MainScreen({this.currentuser}) : super();
  final UserModel currentuser;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with AutomaticKeepAliveClientMixin<MainScreen> {
  int _currentIndex;
  bool isConnectedToInternet = true;
  PageController _pageNavigationController;
  List<BottomBarItem> _bottomBarItemList;
  final PageStorageBucket bucket = PageStorageBucket();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
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
    enablePushtoken();
    fcmConfiguration();
    _initFLN();
  }

  Future _showNotification(Map<String, dynamic> message) async {
    print("hi-==-=-=-=-=-=");
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel desc',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics =
    new NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      'new message arived',
      'i want ${message['data']['title']} for ${message['data']['price']}',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  _initFLN() {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
//    final IOSInitializationSettings initializationSettingsIOS =
//    IOSInitializationSettings(
//        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//    final InitializationSettings initializationSettings = InitializationSettings(
//        android: initializationSettingsAndroid,
//        iOS: initializationSettingsIOS);
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: null);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async{
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  fcmConfiguration(){
    _firebaseMessaging.configure(
      onBackgroundMessage: myBackgroundHandler,
      // ignore: missing_return
      onMessage: (Map<String,dynamic> map) {
        print("onmessage");
        // ignore: missing_return
        CustomFlushBar.customFlushBar(message: "new Post arrived !", scaffoldKey: mainScreenScaffoldKey, type: FlushBarType.UPDATE);
      }
    );
  }

  enablePushtoken(){
    CollectionReference userRef = FirebaseFirestore.instance.collection("user");
    _firebaseMessaging.getToken().then((value){
      userRef
          .doc(widget.currentuser.id)
          .update({'pushToken': value});
    });
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

  List<Widget> _getPages() {
    print(widget.currentuser.id);
    if (widget.currentuser.userType == UserType.STUDENT)
      return [
        TimelineScreen(
          key: PageStorageKey("TimelineScreen"),
        ),
        MenuScreen(),
        DashboardScreen(),
        MenuScreen(),
        ProfileScreen()
      ];
    else
      return [
        TimelineScreen(
          key: PageStorageKey("TimelineScreen"),
        ),
        MenuScreen(
          key: PageStorageKey("jgd"),
        ),
        Provider(
          create: (_) => UploadBloc(),
          child: UploadPostScreen(),
        ),
        MenuScreen(
          key: PageStorageKey("MenuScreen"),
        ),
//        SideBarLayout()
        ProfileScreen(
          key: PageStorageKey("ProfileScreen"),
        ),
      ];
  }

  Widget getFloatingActionButton() {
    if (widget.currentuser.userType == UserType.STUDENT)
      return ImageFloatingActionButton(
          onPressed: () => _onTap(Constants.fabItemIndex),
          path: Strings.getLogoImagePath);
    else
      return CircleAvatar(
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(Icons.file_upload),
          color: _currentIndex == Constants.fabItemIndex
              ? AppTheme.primaryColor
              : AppTheme.accentColor,
          onPressed: () => _onTap(Constants.fabItemIndex),
        ),
        radius: SizeConfig.heightMultiplier * 4,
      );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: mainScreenScaffoldKey,
      extendBody: true,
      resizeToAvoidBottomPadding: false,
      body: PageStorage(
        bucket: bucket,
        child: StreamBuilder<DataConnectionStatus>(
          stream: DataConnectionChecker().onStatusChange,
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return LoadingScreen();
            }
            final isConnected = snapshot.data == DataConnectionStatus.connected;
            return   PageView(
              children: isConnected ? _pages : [NoInternetScreen()],
              onPageChanged: onPageChange,
              controller: _pageNavigationController,
            );
          },
        )
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
