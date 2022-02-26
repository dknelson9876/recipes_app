import 'package:flutter/material.dart';
import 'package:recipes_app/model/recipe.dart';
import 'package:recipes_app/state_widget.dart';

Future<void> createRecipe(BuildContext context, RecipeType recipeType) async {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _ingredientsController = TextEditingController();
  TextEditingController _preparationController = TextEditingController();
  TextEditingController _imageLinkController = TextEditingController();

  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return ListView(children: [
        Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time'),
              ),
              TextField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                  labelText: 'Ingredients',
                  helperText: 'Separate list using semicolons \';\'',
                ),
              ),
              TextField(
                controller: _preparationController,
                decoration: const InputDecoration(
                  labelText: 'Preparation Steps',
                  helperText: 'Separate list using semicolons \';\'',
                ),
              ),
              TextField(
                controller: _imageLinkController,
                decoration: const InputDecoration(labelText: 'Link to image'),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () async {
                      // print('submit');

                      //TODO submit new recipe to firestore
                      final String? name = _nameController.text;
                      final int? duration = int.tryParse(_timeController.text);
                      final List<String>? ingredients =
                          _ingredientsController.text.split(';');
                      final List<String>? preparation =
                          _preparationController.text.split(';');
                      final String? imageLink = _imageLinkController.text;

                      Object recipe = {
                        'name': name,
                        'duration': duration ?? 0,
                        'ingredients': ingredients,
                        'preparation': preparation,
                        'image': imageLink,
                        'type': recipeType.index,
                      };

                      StateWidget.of(context).uploadRecipe(context, recipe);

                      _nameController.clear();
                      _timeController.clear();
                      _ingredientsController.clear();
                      _preparationController.clear();
                      _imageLinkController.clear();

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ]);
    },
  );
}
