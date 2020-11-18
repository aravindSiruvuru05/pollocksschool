import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/utils/config/styling.dart';

class ProfilePhotoIcon extends StatelessWidget {
  const ProfilePhotoIcon({
    Key key, this.photoUrl, this.username, this.radius,
  }) : super(key: key);

  final String photoUrl;
  final String username;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: photoUrl.isNotEmpty
          ? CachedNetworkImageProvider(photoUrl)
          : null,
      backgroundColor: AppTheme.primaryColor.withOpacity(0.25),
      child: photoUrl.isEmpty ? Text(username[0],style: AppTheme.lightTextTheme.headline6.copyWith(fontWeight: FontWeight.bold),) : null,
    );
  }
}
