import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/blocs.dart';
import 'package:pollocksschool/models/models.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';
import 'package:pollocksschool/utils/constants.dart';
import 'package:pollocksschool/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';


GlobalKey<ScaffoldState> timelineScaffoldKey = GlobalKey<ScaffoldState>();

// ignore: must_be_immutable
class TimelineScreen extends StatelessWidget {

  TimelineScreen({Key key}): super(key:key);
  TimelineBloc _timelineBloc;

  @override
  Widget build(BuildContext context) {
    _timelineBloc = Provider.of<TimelineBloc>(context);

    return Scaffold(
      key: timelineScaffoldKey,
      body:  RefreshIndicator(
          onRefresh: () async{
            final snapshot = await _timelineBloc.getTimelineQuerySnapshot();
            await _timelineBloc.updateTimeline(snapshot);
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                pinned: true,
                expandedHeight: SizeConfig.heightMultiplier *9,
                flexibleSpace: FlexibleSpaceBar(
//                    background: Image.asset(Strings.getLogoImagePath,),
                  centerTitle: true,
                  title: Text("Pollocks Timeline", style: AppTheme.lightTextTheme.headline6.copyWith(fontFamily: Constants.getFreightSansFamily,
                      color: AppTheme.primaryColor,fontSize: SizeConfig.heightMultiplier * 2.9)),
                  collapseMode: CollapseMode.parallax,
                ),
              ),
              buildTimelinePosts()
            ],
          )
      )
    );
  }
//buildTimelinePosts()
  buildTimelinePosts() {
    return StreamBuilder<List<PostModel>>(
      stream: _timelineBloc.timelinePostsStream,
      initialData: _timelineBloc.timelinePosts,
      builder: (context, snapshot) {
        final posts = snapshot.data;
        if (posts == null) {
          return SliverToBoxAdapter(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              enabled: true,
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.heightMultiplier * 3),
                child: Column(
                  children: [
                    PostShimmer(),
                    SizedBox(height: SizeConfig.heightMultiplier,),
                    PostShimmer(),
                  ],
                ),
              ),
            ),
          );
        }
        else if (posts.length == 0) {
          return SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.heightMultiplier * 20,),
                Text("Y o u r   T i m e l i n e   i s   E m p t y", style: AppTheme.lightTextTheme.headline3,),
              ],
            ),
          );
        } else {
           final postCards = posts.map((e) {
              return PostCard(post: e);
          }).toList();
          return SliverToBoxAdapter(
              child:  Container(
                padding: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 10),
                color: Colors.white,
                child: Column(
                  children: postCards,
                ),
              )
          );
        }
      },
    );
  }
}

class PostShimmer extends StatelessWidget {
  const PostShimmer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

