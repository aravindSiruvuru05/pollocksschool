import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/auth_bloc.dart';
import 'package:pollocksschool/blocs/profile_bloc.dart';
import 'package:pollocksschool/enums/loading_state.dart';
import 'package:pollocksschool/models/post_model.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';
import 'package:pollocksschool/widgets/post_card.dart';
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

  buildProfileHeader() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.grey,
//                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                child: Text("A"),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        StreamBuilder<List<PostModel>>(
                          stream: _profileBloc.postsStream,
                          initialData: _profileBloc.allPosts,
                          builder: (context, snapshot) {
                            final posts = snapshot.data;
                            if (posts == null)
                              return buildCountColumn("posts", 0);
                            return buildCountColumn("posts", posts.length);
                          },
                        ),
                        buildCountColumn("followers", 0),
                        buildCountColumn("following", 0),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        buildButton(text: "Edit Profile"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "${_authBloc.getCurrentUser.firstname} ${_authBloc.getCurrentUser.lastname}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 4.0),
            child: Text("bio comes here ....",
                style: AppTheme.lightTextTheme.bodyText2
                    .copyWith(color: AppTheme.accentColor)),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 2.0),
            child: Text("am roi",
                style: AppTheme.lightTextTheme.bodyText2
                    .copyWith(color: AppTheme.accentColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _authBloc = Provider.of<AuthBloc>(context);
    _profileBloc = Provider.of<ProfileBloc>(context);
    return
      Scaffold(
        appBar: AppBar(title: Text("profile"),centerTitle: true,
          actions: [
            IconButton(icon: Icon( Icons.power_settings_new),
              onPressed: () {
                _authBloc.signOut();
                _authBloc.loginButtonStateSink(LoadingState.NORMAL);
              },
            )
          ],
        ),
        body: Stack(
          children: [
            buildProfileHeader(),
            RefreshIndicator(
                onRefresh: () => _profileBloc.getPosts(),
                child: ListView(
                  children: [
                    Container(
                      height: SizeConfig.heightMultiplier * 30,
                    ),
//          Divider(height: 10,thickness: 1,),
                    buildProfilePosts(),
                  ],
                ),
            )

          ],
        ),
    );
  }

  buildProfilePosts() {
    return StreamBuilder<List<PostModel>>(
      stream: _profileBloc.postsStream,
      initialData: _profileBloc.allPosts,
      builder: (context, snapshot) {
        final posts = snapshot.data;
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
                    height: MediaQuery.of(context).size.height / 2.5,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          );
        } else if (posts.isEmpty) {
          return Center(
            child: Text("no posts yet"),
          );
        } else {
          final postCards = posts.map((e) => PostCard(post: e,postBloc: _profileBloc,)).toList();
          return Container(
            color: AppTheme.appBackgroundColor,
            child: Column(
              children: postCards,
            ),
          );
        }
      },
    );
  }
}
