import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/blocs.dart';
import 'package:pollocksschool/models/models.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';
import 'package:pollocksschool/utils/constants.dart';
import 'package:pollocksschool/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/config/size_config.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key key}) : super(key: key);

  AuthBloc _authBloc;
  ProfileBloc _profileBloc;
  Column buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Container buildButton({String text, Function function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: FlatButton(
        onPressed: function,
        child: Container(
          width: 250.0,
          height: 27.0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            border: Border.all(
              color: AppTheme.primaryshadeColor,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _authBloc = Provider.of<AuthBloc>(context);
    _profileBloc = Provider.of<ProfileBloc>(context);
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            backgroundColor: AppTheme.primaryColor,
            pinned: true,
            centerTitle: true,
            expandedHeight: SizeConfig.heightMultiplier * 9,
            title: AppBarTitle(
              child: Text("profile",
                  style: AppTheme.lightTextTheme.headline6.copyWith(
                      fontFamily: Constants.getFreightSansFamily,
                      color: Colors.white,
                      fontSize: SizeConfig.heightMultiplier * 2.9)),
            ),
            actions: [
              PopupMenuButton<String>(
                onSelected: choiceAction,
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                itemBuilder: (BuildContext context) {
                  return Constants.getMenuChoices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              )
            ],
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: SizeConfig.heightMultiplier * 2,
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: SizeConfig.heightMultiplier * 2,
                    ),
                    CircleAvatar(
                      radius: SizeConfig.heightMultiplier * 5,
                    ),
                    Padding(
                      padding: EdgeInsets.all(SizeConfig.heightMultiplier * 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${_profileBloc.currentUser.firstname} ${_profileBloc.currentUser.lastname}',
                              style: AppTheme.lightTextTheme.headline6.copyWith(
                                  fontFamily: Constants.getFreightSansFamily,
                                  color: Colors.white,
                                  fontSize: SizeConfig.heightMultiplier * 3)),
                          Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.heightMultiplier),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.account_balance,
                                  color: AppTheme.accentColor,
                                  size: SizeConfig.heightMultiplier * 2.5,
                                ),
                                SizedBox(
                                  width: SizeConfig.heightMultiplier,
                                ),
                                Text("Intilli",
                                    style: AppTheme.lightTextTheme.headline6
                                        .copyWith(
                                            fontFamily:
                                                Constants.getFreightSansFamily,
                                            color: AppTheme.accentColor,
                                            fontSize: SizeConfig.heightMultiplier * 2.2
                                    )
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 5,
                      left: SizeConfig.heightMultiplier * 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: _profileBloc.postsStream,
                            builder: (context, snapshot) {
                              final count = snapshot.data == null ? 0 : snapshot.data.docs.length;
                              return Text(count.toString(),
                                  style: AppTheme.lightTextTheme.headline6.copyWith(
                                      fontFamily: Constants.getFreightSansFamily,
                                      color: Colors.white,
                                      fontSize: SizeConfig.heightMultiplier * 3.5));
                            }
                          ),
                          Text("Posts",
                              style: AppTheme.lightTextTheme.headline6.copyWith(
                                  fontFamily: Constants.getHelveticaNeueFamily,
                                  color: Colors.white,
                                  fontSize: SizeConfig.heightMultiplier * 2)),
                        ],
                      ),
                      Container(
                        width: 1,
                        color: Colors.white,
                        height: SizeConfig.heightMultiplier * 5,
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.heightMultiplier * 5),
                      ),
                      Column(
                        children: [
                          Text("10",
                              style: AppTheme.lightTextTheme.headline6.copyWith(
                                  fontFamily: Constants.getFreightSansFamily,
                                  color: Colors.white,
                                  fontSize: SizeConfig.heightMultiplier * 3.5)),
                          Text("Posts",
                              style: AppTheme.lightTextTheme.headline6.copyWith(
                                  fontFamily: Constants.getHelveticaNeueFamily,
                                  color: Colors.white,
                                  fontSize: SizeConfig.heightMultiplier * 2)),
                        ],
                      ),
                      Container(
                        width: 1,
                        color: Colors.white,
                        height: SizeConfig.heightMultiplier * 5,
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.heightMultiplier * 5),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.heightMultiplier * 2.5,
                            vertical: SizeConfig.heightMultiplier),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0xff6d0eb5), Color(0xff4059F1)]),
                            borderRadius: BorderRadius.circular(
                                SizeConfig.heightMultiplier)),
                        child: Text("message",
                            style: AppTheme.lightTextTheme.headline6.copyWith(
                                fontFamily: Constants.getFreightSansFamily,
                                color: Colors.white,
                                fontSize: SizeConfig.heightMultiplier * 2)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: SizeConfig.heightMultiplier * 10,
            ),
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<QuerySnapshot>(
                stream: _profileBloc.postsStream,
              builder: (context, snapshot) {
                  final posts = snapshot.data == null ? [] : snapshot.data.docs ;
                return Container(
                  height: posts.length < 4 ? MediaQuery.of(context).size.height / 2 : null,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(SizeConfig.heightMultiplier * 3),
                    boxShadow: [
                      BoxShadow(
                          color: AppTheme.accentColor.withOpacity(0.8),
                          blurRadius: 10.0,
                          offset: Offset(5, 5)),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("All Photos",
                              style: AppTheme.lightTextTheme.headline6.copyWith(
                                  fontFamily: Constants.getFreightSansFamily,
                                  color: AppTheme.primaryColor,
                                  fontSize: SizeConfig.heightMultiplier * 2.9)),
                          Container(
                            width: 1,
                            color: AppTheme.primaryColor,
                            height: SizeConfig.heightMultiplier * 5,
                            margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.heightMultiplier * 5),
                          ),
                          Text("All Files",
                              style: AppTheme.lightTextTheme.headline6.copyWith(
                                  fontFamily: Constants.getFreightSansFamily,
                                  color: AppTheme.accentColor,
                                  fontSize: SizeConfig.heightMultiplier * 2.9)),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 2,
                      ),
                      buildProfilePosts(posts)
                    ],
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  buildProfilePosts(posts) {
     if (posts == null) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        enabled: true,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.heightMultiplier * 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    width: SizeConfig.heightMultiplier * 6,
                    height: SizeConfig.heightMultiplier * 6,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: SizeConfig.heightMultiplier,
                  ),
                  Expanded(
                    child: Container(
                      height: SizeConfig.heightMultiplier * 6,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0),
              ),
              Container(
                width: double.infinity,
                height: SizeConfig.heightMultiplier * 10,
                color: Colors.white,
              ),
            ],
          ),
        ),
      );
    } else if (posts.length == 0) {
      return Center(
        child: Text("no posts yet"),
      );
    } else {
      final finalPosts = posts
          .map<PostModel>((doc) => PostModel.fromDocument(doc))
          .toList();
      return ProfilePostsPhotosGrid(finalPosts: finalPosts);
    }
  }

  void choiceAction(String value) {
    if (value == Constants.getLogoutString) {
      _authBloc.signOut();
    }
  }
}
