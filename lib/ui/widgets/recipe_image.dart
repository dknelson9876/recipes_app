import 'package:flutter/material.dart';

class RecipeImage extends StatelessWidget {
  final String imageURL;

  RecipeImage(this.imageURL);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16.0 / 9.0,
      child: imageURL == ""
          ? Image.asset('assets/default-recipe-image.jpg')
          : Image.network(
              imageURL,
              fit: BoxFit.cover,
            ),
    );
  }
}
