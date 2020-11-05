import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/blocs/post_bloc.dart';
import 'package:pollocksschool/models/post_model.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class PostCard extends StatelessWidget{
  final PostModel post;
  bool isLiked;

  PostBloc postBloc ;

  PostCard({@required this.post,@required this.postBloc});

  buildPostHeader() {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:post.mediaUrl  != null ? CachedNetworkImageProvider(post.mediaUrl) : null,
        backgroundColor: Colors.grey,
        child: post.mediaUrl == null ? Text(post.username[0]) : null,
      ),
      title: GestureDetector(
        onTap: () => print('showing profile'),
        child: Text(
          post.username,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
//          subtitle: Text(location),
      trailing: IconButton(
        onPressed: () => print('deleting post'),
        icon: Icon(Icons.more_vert),
      ),
    );
  }

  buildPostImage() {
    return GestureDetector(
        onDoubleTap: () => postBloc.handleLikePost(post,isLiked),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7)
              ),

              child: CachedNetworkImage(
                imageUrl: post.mediaUrl,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  enabled: true,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3,
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            StreamBuilder<bool>(
              stream: postBloc.likeSymbolStream,
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if(snapshot.data == null || snapshot.data == false) return SizedBox.shrink();
                return Animator(
                  duration: Duration(milliseconds: 300),
                  tween: Tween(begin: 0.8, end: 1.4),
                  curve: Curves.elasticOut,
                  cycles: 0,
                  builder: (context, animatorState, child) => Transform.scale(
                    scale: animatorState.value,
                    child: Icon(
                      Icons.favorite,
                      size: 60.0,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ],
        )
    );
  }

  buildPostFooter() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(SizeConfig.heightMultiplier * 7)),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(SizeConfig.heightMultiplier),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
              GestureDetector(
                onTap: () => postBloc.handleLikePost(post,isLiked),
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  size: 28.0,
                  color: Colors.pink,
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 20.0)),
              GestureDetector(
                onTap: () => print("show comments"),
                child: Icon(
                  Icons.chat,
                  size: 28.0,
                  color: Colors.blue[900],
                ),
              ),
              Spacer(),
              Text(post.getPostDateString,style:  AppTheme.lightTextTheme.bodyText2.copyWith(color: Colors.black45),)
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  "${post.getLikeCount} likes",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(),
              Text(post.getPostTime, style:  AppTheme.lightTextTheme.bodyText2.copyWith(color: Colors.black54),)
            ],
          ),
          SizedBox(height: 4,),
          Container(
            margin: EdgeInsets.only(left: 20.0),
            child: Text(
              "${post.username} ",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20.0,top: 4),
            child: Text(post.description,
                style: AppTheme.lightTextTheme.bodyText2.copyWith(color: Colors.black45)
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    isLiked = postBloc.getIsLiked(post.likes);
    return Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.heightMultiplier * 2),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: AppTheme.accentColor.withOpacity(0.5),
                  blurRadius: 12.0,
                  offset: Offset(3, 10)
              ),]
        ),
        child: Stack(
          alignment:Alignment.bottomCenter,
//            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
//              buildPostHeader(),
              Column(
                children: [
                  buildPostImage(),
                  SizedBox(height: 60,)
                ],
              ),
              buildPostFooter(),
            ]
        )
    );
  }
}