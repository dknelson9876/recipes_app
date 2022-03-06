import 'package:flutter/material.dart';

class RecipeImage extends StatelessWidget {
  final String imageURL;
  final String recipeID;

  RecipeImage(this.imageURL, this.recipeID);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16.0 / 9.0,
      child: Hero(
          tag: recipeID,
          child: imageURL == ""
              ? Image.asset('assets/default-recipe-image.jpg')
              : Image.network(
                  imageURL,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/default-recipe-image.jpg');
                  },
                )),
    );
  }
}
