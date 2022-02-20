import 'package:flutter/material.dart';

import 'package:recipes_app/model/recipe.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    Key? key,
    required this.recipe,
    required this.inFavorites,
    required this.onFavoriteButtonPressed,
  }) : super(key: key);

  final Recipe recipe;
  final bool inFavorites;
  final Function onFavoriteButtonPressed;

  @override
  Widget build(BuildContext context) {
    RawMaterialButton _buildFavoriteButton() {
      return RawMaterialButton(
        constraints: const BoxConstraints(minWidth: 40.0, minHeight: 40.0),
        onPressed: () => onFavoriteButtonPressed(recipe.id),
        child: Icon(
          inFavorites ? Icons.favorite : Icons.favorite_border,
          color: Theme.of(context).iconTheme.color,
        ),
        elevation: 2.0,
        fillColor: Theme.of(context).buttonColor,
        shape: const CircleBorder(),
      );
    }

    Padding _buildTitleSection() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.name,
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Icon(Icons.timer_outlined, size: 20.0),
                const SizedBox(width: 5.0),
                Text(
                  recipe.duration.toString(),
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => print('tapped'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16.0 / 9.0,
                    child: Image.network(
                      recipe.imageURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    child: _buildFavoriteButton(),
                    top: 2.0,
                    right: 2.0,
                  ),
                ],
              ),
              _buildTitleSection(),
            ],
          ),
        ),
      ),
    );
  }
}
