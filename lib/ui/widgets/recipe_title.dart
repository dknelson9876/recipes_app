import 'package:duration/duration.dart';
import 'package:flutter/material.dart';

import 'package:recipes_app/model/recipe.dart';

class RecipeTitle extends StatelessWidget {
  final Recipe recipe;
  final double padding;
  final Color color;

  RecipeTitle(this.recipe, this.padding, this.color);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.name,
              style:
                  Theme.of(context).textTheme.headline2?.copyWith(color: color),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Icon(Icons.timer, size: 20.0, color: color),
                const SizedBox(width: 5.0),
                Text(
                  prettyDuration(recipe.duration),
                  // recipe.duration.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      ?.copyWith(color: color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
