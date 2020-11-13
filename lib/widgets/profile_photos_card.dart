import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:pollocksschool/models/post_model.dart';
import 'package:pollocksschool/screens/post_detail_screen.dart';
import 'package:pollocksschool/utils/config/size_config.dart';
import 'package:pollocksschool/utils/config/styling.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePostsPhotosGrid extends StatelessWidget {
  const ProfilePostsPhotosGrid({
    Key key,
    @required this.finalPosts,
  }) : super(key: key);

  final List<PostModel> finalPosts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.heightMultiplier * 2),
      child: MasonryGrid(
          column: 3,
          crossAxisSpacing: SizeConfig.heightMultiplier * 3,
          mainAxisSpacing: SizeConfig.heightMultiplier * 3,
          children: List.generate(finalPosts.length, (i) =>
              GestureDetector(
                onTap:  (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PostDetailScreen(post: finalPosts[i])),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: AppTheme.accentColor.withOpacity(0.8),
                          blurRadius: 10.0,
                          offset: Offset(5, 5)
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(SizeConfig.heightMultiplier * 1.5),
                    child:  CachedNetworkImage(
                      imageUrl: finalPosts[i].mediaUrl,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        enabled: true,
                        child: Container(
                          width: double.infinity,
                          height: SizeConfig.heightMultiplier * 15,
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
          )
      ),
    );
  }
}
