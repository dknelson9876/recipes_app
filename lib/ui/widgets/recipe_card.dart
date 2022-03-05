import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:recipes_app/model/recipe.dart';
import 'package:recipes_app/services/firebase_service.dart';
import 'package:recipes_app/ui/widgets/recipe_title.dart';
import 'package:recipes_app/ui/widgets/recipe_image.dart';
import 'package:recipes_app/ui/screens/detail.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    Key? key,
    required this.recipe,
    // required this.inFavorites,
    required this.onFavoriteButtonPressed,
  }) : super(key: key);

  final Recipe recipe;
  // final bool inFavorites;
  final Function onFavoriteButtonPressed;

  @override
  Widget build(BuildContext context) {
    var favorites = context
        .select<FirebaseService, List<String>>((service) => service.favorites);

    RawMaterialButton _buildFavoriteButton() {
      return RawMaterialButton(
        constraints: const BoxConstraints(minWidth: 40.0, minHeight: 40.0),
        onPressed: () => onFavoriteButtonPressed(recipe.id),
        child: Icon(
          favorites.contains(recipe.id)
              ? Icons.favorite
              : Icons.favorite_border,
          // color: Theme.of(context).iconTheme.color,
        ),
        elevation: 2.0,
        // fillColor: Theme.of(context).buttonColor,
        fillColor: Theme.of(context).cardColor,
        shape: const CircleBorder(),
      );
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(
            recipe: recipe,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  RecipeImage(recipe.imageURL),
                  Positioned(
                    child: _buildFavoriteButton(),
                    top: 2.0,
                    right: 2.0,
                  ),
                ],
              ),
              RecipeTitle(recipe, 15),
            ],
          ),
        ),
      ),
    );
  }
}
