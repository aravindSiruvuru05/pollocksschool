import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pollocksschool/blocs/post_bloc.dart';
import 'package:pollocksschool/models/post_model.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';
import 'package:pollocksschool/utils/constants.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class PostCard extends StatelessWidget{
  final PostModel post;
  bool isLiked;

  PostBloc postBloc ;

  PostCard({@required this.post,@required this.postBloc});

  buildPostHeader() {
    return Card(
      color: Colors.white,

      borderOnForeground: true,
      elevation: 0,
      margin: EdgeInsets.fromLTRB(0,0,0,0),
      child: ListTile(

        contentPadding: EdgeInsets.only(left: SizeConfig.heightMultiplier),
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
                fontWeight: FontWeight.bold
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
        onDoubleTap: () => postBloc.handleLikePost(post,isLiked),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: post.mediaUrl,
              height: SizeConfig.heightMultiplier * 60,
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
              imageBuilder: (_,ImageProvider<dynamic> imageProvider){
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(image: NetworkImage(post.mediaUrl),fit: BoxFit.cover),
                    backgroundBlendMode: BlendMode.color,
                  ),
                );
              },
              errorWidget: (context, url, error) => Icon(Icons.error),
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
      color: Colors.white,
//      padding: EdgeInsets.only(top: SizeConfig.heightMultiplier),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.all(0),
                icon: !isLiked ? Icon(MdiIcons.heartOutline,size: Constants.commonIconSize,color: Colors.pink,) : Icon(MdiIcons.heart,color: Colors.pink,),
                onPressed:()
                {
                  print(isLiked);
                  postBloc.handleLikePost(post, isLiked);
                },
              ),
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(MdiIcons.chatOutline,size: Constants.commonIconSize,color: Colors.black),
                onPressed:() => {},
              )
            ],
          )
        ],
      ),
    );
  }
//  Text(post.getPostDateString,style:  AppTheme.lightTextTheme.bodyText2.copyWith(color: Colors.black45),),
//  Text(post.getPostTime, style:  AppTheme.lightTextTheme.bodyText2.copyWith(color: Colors.black54),)


  @override
  Widget build(BuildContext context) {
    isLiked = postBloc.getIsLiked(post.likes);
    return Container(
        child: Column(
            children: <Widget>[
              buildPostHeader(),
              buildPostImage(),
              buildPostFooter(),
            ]
        )
    );
  }
}