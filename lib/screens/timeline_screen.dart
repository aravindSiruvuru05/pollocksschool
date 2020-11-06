import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/timeline_bloc.dart';
import 'package:pollocksschool/models/post_model.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';
import 'package:pollocksschool/widgets/post_card.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';


// ignore: must_be_immutable
class TimelineScreen extends StatelessWidget {

  TimelineScreen({Key key}): super(key:key);
  TimelineBloc _timelineBloc;

  @override
  Widget build(BuildContext context) {
    _timelineBloc = Provider.of<TimelineBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Pollocks Timeline",
          style: AppTheme.lightTextTheme.headline6.copyWith(fontFamily: "FreightSans",color: AppTheme.primaryColor),
      ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,),
      body:  RefreshIndicator(
          onRefresh: () {
          },
          child: buildTimelinePosts()
      )
    );
  }

  buildTimelinePosts() {
    return StreamBuilder<QuerySnapshot>(
      stream: _timelineBloc.timelineCollectionRef.doc("intilli3A").collection('classPosts')
        .orderBy('timestamp', descending: true).snapshots(),
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
        }
        else if (posts.docs.length == 0) {
          return Center(
            child: Text("no posts yet"),
          );
        } else {
          final finalPosts = snapshot.data.docs.map((doc) => PostModel.fromDocument(doc)).toList();

          final postCards = finalPosts.map((e) => PostCard(post: e,postBloc: _timelineBloc,)).toList();
          return Container(
            color: AppTheme.appBackgroundColor,
            child: ListView(
              children: postCards,
            ),
          );
        }
      },
    );
  }
}

