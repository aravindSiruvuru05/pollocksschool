import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/models/post_model.dart';
import 'package:pollocksschool/utils/config/styling.dart';

class PostCard extends StatelessWidget{
  final PostModel post;

  PostCard({@required this.post});

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
      onDoubleTap: () => print('liking post'),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.network(post.mediaUrl),
        ],
      ),
    );
  }

  buildPostFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
            GestureDetector(
              onTap: () => print('liking post'),
              child: Icon(
                Icons.favorite_border,
                size: 28.0,
                color: Colors.pink,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            GestureDetector(
              onTap: () => print('showing comments'),
              child: Icon(
                Icons.chat,
                size: 28.0,
                color: Colors.blue[900],
              ),
            ),
            Spacer(),
            Text(post.getPostDateString)
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
            Text(post.getPostTime)
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

    )
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
      BoxShadow(
      color: AppTheme.accentColor.withOpacity(0.5),
        blurRadius: 12.0,
        offset: Offset(3, 10)
    ),]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildPostHeader(),
          buildPostImage(),
          buildPostFooter(),]
        
      )
    );

  }
}