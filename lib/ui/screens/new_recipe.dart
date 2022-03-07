import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/model/recipe.dart';
import 'package:recipes_app/services/firebase_service.dart';
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
  String? _imageLink;

  @override
  Widget build(BuildContext context) {
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
                      decoration: const InputDecoration(labelText: 'Name'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      onSaved: (value) => _duration = int.tryParse(value!),
                      decoration: const InputDecoration(labelText: 'Duration'),
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
                    TextFormField(
                      onSaved: (value) => {_ingredients = value?.split(';')},
                      decoration: const InputDecoration(
                        labelText: 'Ingredients',
                        helperText: 'Separate list using semicolons \';\'',
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      onSaved: (value) => {_preparation = value?.split(';')},
                      decoration: const InputDecoration(
                        labelText: 'Preparation',
                        helperText: 'Separate list using semicolons \';\'',
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      onSaved: (value) => {_imageLink = value},
                      decoration:
                          const InputDecoration(labelText: 'Link to Image'),
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        if (value != "" && !Uri.parse(value!).isAbsolute) {
                          return 'Please enter a valid link';
                        }
                      },
                      textInputAction: TextInputAction.done,
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
                      'image': _imageLink,
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
}


// Future<void> createRecipe(BuildContext context, RecipeType recipeType) async {
//   TextEditingController _nameController = TextEditingController();
//   TextEditingController _timeController = TextEditingController();
//   TextEditingController _ingredientsController = TextEditingController();
//   TextEditingController _preparationController = TextEditingController();
//   TextEditingController _imageLinkController = TextEditingController();

//   await showModalBottomSheet(
//     isScrollControlled: true,
//     context: context,
//     builder: (BuildContext context) {
//       return Padding(
//         padding: EdgeInsets.only(
//           top: 20,
//           left: 20,
//           right: 20,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(labelText: 'Name'),
//             ),
//             TextField(
//               controller: _timeController,
//               decoration: const InputDecoration(labelText: 'Time'),
//             ),
//             TextField(
//               controller: _ingredientsController,
//               decoration: const InputDecoration(
//                 labelText: 'Ingredients',
//                 helperText: 'Separate list using semicolons \';\'',
//               ),
//             ),
//             TextField(
//               controller: _preparationController,
//               decoration: const InputDecoration(
//                 labelText: 'Preparation Steps',
//                 helperText: 'Separate list using semicolons \';\'',
//               ),
//             ),
//             TextField(
//               controller: _imageLinkController,
//               decoration: const InputDecoration(labelText: 'Link to image'),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 const Spacer(),
//                 ElevatedButton(
//                   child: const Text('Submit'),
//                   onPressed: () async {
//                     // print('submit');

//                     final String? name = _nameController.text;
//                     final int? duration = int.tryParse(_timeController.text);
//                     final List<String>? ingredients =
//                         _ingredientsController.text.split(';');
//                     final List<String>? preparation =
//                         _preparationController.text.split(';');
//                     final String? imageLink = _imageLinkController.text;

//                     Object recipe = {
//                       'name': name,
//                       'duration': duration ?? 0,
//                       'ingredients': ingredients,
//                       'preparation': preparation,
//                       'image': imageLink,
//                       'type': recipeType.index,
//                     };

//                     context
//                         .read<FirebaseService>()
//                         .uploadRecipe(context, recipe);

//                     _nameController.clear();
//                     _timeController.clear();
//                     _ingredientsController.clear();
//                     _preparationController.clear();
//                     _imageLinkController.clear();

//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
