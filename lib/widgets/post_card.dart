import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pollocksschool/blocs/timeline_bloc.dart';
import 'package:pollocksschool/models/post_model.dart';
import 'package:pollocksschool/screens/post_detail_screen.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';
import 'package:pollocksschool/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class PostCard extends StatelessWidget {
  final PostModel post;
  bool isLiked;

  TimelineBloc timelineBloc;

  PostCard({@required this.post});

  buildPostHeader() {
    return Card(
      color: Colors.white,
      borderOnForeground: true,
      elevation: 0,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: SizeConfig.heightMultiplier),
        leading: Hero(
          tag: post,
          child: CircleAvatar(
            radius: SizeConfig.heightMultiplier * 3,
            backgroundImage: post.mediaUrl != null
                ? CachedNetworkImageProvider(post.mediaUrl)
                : null,
            backgroundColor: Colors.grey,
            child: post.mediaUrl == null ? Text(post.username[0]) : null,
          ),
        ),
        title: GestureDetector(
          onTap: () => print('showing profile'),
          child: Hero(
            tag: post.mediaUrl,
            child: Text(
              post.username,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
//          subtitle: Text(location),
        trailing: IconButton(
          onPressed: () => print('deleting post'),
          icon: Icon(Icons.more_vert),
        ),
      ),
    );
  }

  buildPostImage() {
    return GestureDetector(
        onDoubleTap: () => timelineBloc.handleLikePost(post, !isLiked),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Hero(
              tag: post.postId,
              child: CachedNetworkImage(
                imageUrl: post.mediaUrl,
                fit: BoxFit.fitHeight,
                height: SizeConfig.heightMultiplier * 60,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  enabled: true,
                  child: Container(
                    width: double.infinity,
                    height: SizeConfig.heightMultiplier * 60,
                    color: Colors.white,
                  ),
                ),
                imageBuilder: (_, ImageProvider<dynamic> imageProvider) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                          image: NetworkImage(post.mediaUrl),
                          fit: BoxFit.cover),
                      backgroundBlendMode: BlendMode.color,
                    ),
                  );
                },
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            StreamBuilder<String>(
              stream: timelineBloc.likeSymbolStream,
              initialData: "",
              builder:
                  (BuildContext context, AsyncSnapshot<String> snapshot) {

                if (snapshot.data == post.postId){
                  return Animator(
                    duration: Duration(milliseconds: 300),
                    tween: Tween(begin: 0.8, end: 1.4),
                    curve: Curves.elasticOut,
                    cycles: 0,
                    builder: (context, animatorState, child) =>
                        Transform.scale(
                          scale: animatorState.value,
                          child: Icon(
                            Icons.favorite,
                            size: 60.0,
                            color: Colors.white,
                          ),
                        ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ],
        ));
  }

  buildPostFooter(BuildContext context) {
    return Container(
      color: Colors.white,
//      padding: EdgeInsets.only(top: SizeConfig.heightMultiplier),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.all(0),
                    icon: !isLiked
                        ? Icon(
                      MdiIcons.heartOutline,
                      size: Constants.commonIconSize,
                      color: Colors.black87,
                    )
                        : Icon(
                      MdiIcons.heart,
                      size: Constants.commonIconSize,
                      color: Colors.pink,
                    ),
                    onPressed: () => timelineBloc.handleLikePost(post, !isLiked),
                  ),
                  Text(
                    post.getLikeCount.toString(),
                    style: AppTheme.lightTextTheme.bodyText2
                        .copyWith(color: Colors.pink),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(MdiIcons.chatOutline,
                        size: Constants.commonIconSize, color: Colors.black87),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PostDetailScreen(post: post)),
                      );
                    },
                  ),
                  Text(
                    post.commentscount.toString(),
                    style: AppTheme.lightTextTheme.bodyText2
                        .copyWith(color: Colors.black87),
                  ),
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 10),
            child: Row(
              children: [
                Text(
                  post.username,
                  style: AppTheme.lightTextTheme.bodyText2
                      .copyWith(fontFamily: Constants.getFreightSansFamily),
                ),
                Text(
                  ":",
                  style: AppTheme.lightTextTheme.bodyText2,
                ),
                SizedBox(
                  width: SizeConfig.heightMultiplier,
                ),
                Text(
                  post.description,
                  style: AppTheme.lightTextTheme.bodyText2,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
//  Text(post.getPostDateString,style:  AppTheme.lightTextTheme.bodyText2.copyWith(color: Colors.black45),),
//  Text(post.getPostTime, style:  AppTheme.lightTextTheme.bodyText2.copyWith(color: Colors.black54),)

  @override
  Widget build(BuildContext context) {
    timelineBloc = Provider.of<TimelineBloc>(context);
    isLiked = post.likes[timelineBloc.currentUser.id] == null ? false : post.likes[timelineBloc.currentUser.id];
    return Container(
        child: Column(children: <Widget>[
      Divider(
        thickness: 0.4,
        color: AppTheme.accentColor.withOpacity(0.3),
      ),
      buildPostHeader(),
      buildPostImage(),
      buildPostFooter(context),
    ]));
  }
}
