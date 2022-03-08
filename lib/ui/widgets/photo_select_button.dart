import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/services/firebase_service.dart';
import 'package:recipes_app/ui/screens/new_recipe.dart';

class PhotoSelectButton extends StatefulWidget {
  const PhotoSelectButton({Key? key}) : super(key: key);

  @override
  State<PhotoSelectButton> createState() => _PhotoSelectButtonState();
}

enum ImageSourceLocation { unknown, local, online }

class _PhotoSelectButtonState extends State<PhotoSelectButton> {
  String? _imageURL;
  ImageSourceLocation _imageLocation = ImageSourceLocation.unknown;

  @override
  Widget build(BuildContext context) {
    switch (_imageLocation) {
      case ImageSourceLocation.local:
      //TODO: figure out how to let the NewRecipeScreen know it's online and upload on submit, instead of upload on select
      case ImageSourceLocation.online:
        //makes the imageURL available to the parent NewRecipeScreen
        Provider.of<NewRecipeState>(context).imageURL = _imageURL!;

        return GestureDetector(
          onTap: _pickImageType,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
              child: Image.network(_imageURL!, fit: BoxFit.cover),
            ),
          ),
        );
      case ImageSourceLocation.unknown:
      default:
        return GestureDetector(
          onTap: _pickImageType,
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  child: const Icon(Icons.insert_photo),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add photo',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        );
    }
  }

  //local or link
  void _pickImageType() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                    leading: const Icon(Icons.link),
                    title: const Text('Photo from link'),
                    onTap: () {
                      _enterImageURL();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('Photo from phone'),
                  onTap: () {
                    _pickImageSource();
                  },
                ),
              ],
            ),
          );
        });
  }

  //gallery or camera
  void _pickImageSource() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () async {
                      Future<String> futureImage =
                          Provider.of<FirebaseService>(context, listen: false)
                              .uploadImage('gallery');

                      //display a loading indicator until the image is uploaded
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Scaffold(
                                body: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CircularProgressIndicator(),
                                      Text('Uploading Image',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
                                    ],
                                  ),
                                ),
                              )));

                      _imageURL = await futureImage;

                      Navigator.popUntil(
                          context, ModalRoute.withName('/newRecipe'));

                      setState(() {});
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    Future<String> futureImage =
                        Provider.of<FirebaseService>(context, listen: false)
                            .uploadImage('camera');

                    //display a loading indicator until the image is uploaded
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Scaffold(
                              body: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircularProgressIndicator(),
                                    Text('Uploading Image',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge),
                                  ],
                                ),
                              ),
                            )));

                    _imageURL = await futureImage;

                    Navigator.popUntil(
                        context, ModalRoute.withName('/newRecipe'));

                    setState(() {});
                  },
                ),
              ],
            ),
          );
        });
  }

  void _enterImageURL() {
    TextEditingController imageUrlController = TextEditingController();

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
                16, 16, 16, MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: imageUrlController,
                  decoration: InputDecoration(
                    labelText: 'Link to Image',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    setState(() {
                      _imageURL = imageUrlController.text;
                      _imageLocation = ImageSourceLocation.online;
                    });
                    Navigator.popUntil(
                        context, ModalRoute.withName('/newRecipe'));
                  },
                ),
              ],
            ),
          );
        });
  }
}
