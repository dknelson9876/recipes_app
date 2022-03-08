import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/model/recipe.dart';
import 'package:recipes_app/services/firebase_service.dart';
import 'package:recipes_app/ui/widgets/photo_select_button.dart';
import 'package:recipes_app/ui/widgets/recipe_type_selector.dart';

class NewRecipeScreen extends StatefulWidget {
  const NewRecipeScreen({Key? key}) : super(key: key);

  @override
  State<NewRecipeScreen> createState() => _NewRecipeScreenState();
}

class _NewRecipeScreenState extends State<NewRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  // RecipeType _recipeType = RecipeType.food;

  String? _name;
  int? _duration;
  List<String>? _ingredients;
  List<String>? _preparation;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
      borderSide: const BorderSide(),
      borderRadius: BorderRadius.circular(16),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Recipe'),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      // controller: _nameController,
                      onSaved: (value) => {_name = value},
                      decoration:
                          InputDecoration(labelText: 'Name', border: border),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const PhotoSelectButton(),
                    TextFormField(
                      onSaved: (value) => _duration = int.tryParse(value!),
                      decoration: InputDecoration(
                        labelText: 'Duration',
                        border: border,
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        String pattern = "^\\d+\$";
                        RegExp regExp = RegExp(pattern);
                        if (!regExp.hasMatch(value!)) {
                          return 'Please enter a whole number';
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      onSaved: (value) => {_ingredients = value?.split(';')},
                      decoration: InputDecoration(
                        labelText: 'Ingredients',
                        helperText: 'Separate list using semicolons \';\'',
                        border: border,
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      onSaved: (value) => {_preparation = value?.split(';')},
                      decoration: InputDecoration(
                        labelText: 'Preparation',
                        helperText: 'Separate list using semicolons \';\'',
                        border: border,
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    Consumer<NewRecipeState>(
                      builder: (context, recipeState, _) => RecipeTypeSelector(
                        state: recipeState.recipeType,
                        onSelection: (recipeType) =>
                            recipeState.recipeType = recipeType,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing')),
                    );
                    //create new recipe and call upload here
                    Object recipe = {
                      'name': _name,
                      'duration': _duration,
                      'ingredients': _ingredients,
                      'preparation': _preparation,
                      'image':
                          Provider.of<NewRecipeState>(context, listen: false)
                              .imageURL,
                      'type': context.read<NewRecipeState>().recipeType.index,
                    };

                    context
                        .read<FirebaseService>()
                        .uploadRecipe(context, recipe);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class NewRecipeState extends ChangeNotifier {
  RecipeType _recipeType = RecipeType.food;
  RecipeType get recipeType => _recipeType;
  set recipeType(RecipeType recipeType) {
    _recipeType = recipeType;
    notifyListeners();
  }

  String imageURL = '';
  // String get imageURL => _imageURL;
  // set imageURL(String imageURL) {
  //   _imageURL = imageURL;
  //   notifyListeners();
  // }
}
