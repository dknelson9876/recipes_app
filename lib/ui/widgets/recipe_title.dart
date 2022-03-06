import 'package:duration/duration.dart';
import 'package:flutter/material.dart';

import 'package:recipes_app/model/recipe.dart';

class RecipeTitle extends StatelessWidget {
  final Recipe recipe;
  final double padding;

  RecipeTitle(this.recipe, this.padding);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipe.name,
            style: Theme.of(context).textTheme.headline2,
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              const Icon(Icons.timer, size: 20.0),
              const SizedBox(width: 5.0),
              Text(
                prettyDuration(recipe.duration),
                // recipe.duration.toString(),
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
