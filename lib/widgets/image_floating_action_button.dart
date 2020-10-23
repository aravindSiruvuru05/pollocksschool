import 'package:flutter/material.dart';

class ImageFloatingActionButton extends StatelessWidget {
  final onPressed;

  final path;

  const ImageFloatingActionButton({
    Key key,@required this.onPressed,@required this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      child:CircleAvatar(
        radius: double.infinity / 2,
        backgroundImage: AssetImage(path),
      ),
      onPressed: onPressed,
    );
  }
}
