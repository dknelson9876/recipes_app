// import 'package:duration/duration.dart';
import 'package:flutter/material.dart';

enum RecipeType {
  food,
  drink,
}

class Recipe {
  final String id;
  final RecipeType type;
  final String name;
  final Duration duration;
  final List<String> ingredients;
  final List<String> preparation;
  final String imageURL;

  const Recipe({
    required this.id,
    required this.type,
    required this.name,
    required this.duration,
    required this.ingredients,
    required this.preparation,
    required this.imageURL,
  });

  // String get getDurationString => prettyDuration(this.duration);
}
