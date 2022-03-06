import 'package:flutter/material.dart';
import 'package:recipes_app/model/recipe.dart';

class RecipeTypeSelector extends StatelessWidget {
  const RecipeTypeSelector(
      {required this.state, required this.onSelection, Key? key})
      : super(key: key);
  final RecipeType state;
  final void Function(RecipeType selection) onSelection;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case RecipeType.food:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 0),
                onPressed: () => onSelection(RecipeType.food),
                child: const Text('FOOD'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => onSelection(RecipeType.drink),
                child: const Text('DRINK'),
              ),
            ],
          ),
        );
      case RecipeType.drink:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              TextButton(
                onPressed: () => onSelection(RecipeType.food),
                child: const Text('FOOD'),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 0),
                onPressed: () => onSelection(RecipeType.drink),
                child: const Text('DRINK'),
              ),
            ],
          ),
        );
      // default:
      //   return Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Row(
      //       children: [
      //         StyledButton(
      //           onPressed: () => onSelection(RecipeType.food),
      //           child: const Text('YES'),
      //         ),
      //         const SizedBox(width: 8),
      //         StyledButton(
      //           onPressed: () => onSelection(RecipeType.drink),
      //           child: const Text('NO'),
      //         ),
      //       ],
      //     ),
      //   );
    }
  }
}

class StyledButton extends StatelessWidget {
  const StyledButton({required this.child, required this.onPressed});
  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.deepPurple)),
        onPressed: onPressed,
        child: child,
      );
}
