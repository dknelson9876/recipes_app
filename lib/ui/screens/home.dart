import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:recipes_app/model/recipe.dart';
import 'package:recipes_app/model/state.dart';
import 'package:recipes_app/state_widget.dart';
import 'package:recipes_app/ui/screens/login.dart';
import 'package:recipes_app/ui/screens/new_recipe.dart';
import 'package:recipes_app/ui/widgets/settings_button.dart';
import 'package:recipes_app/utils/store.dart';
import 'package:recipes_app/ui/widgets/recipe_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  StateModel? appState;
  // User? user = FirebaseAuth.instance.currentUser;

  DefaultTabController _buildTabView({required Widget body}) {
    const double _iconSize = 20.0;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          // We set Size equal to passed height (50.0) and infinite width:
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            // backgroundColor: Theme.of(context).primaryColor,
            elevation: 2.0,
            bottom: const TabBar(
              // labelColor: Theme.of(context).indicatorColor,
              tabs: [
                Tab(icon: Icon(Icons.restaurant, size: _iconSize)),
                Tab(icon: Icon(Icons.local_drink, size: _iconSize)),
                Tab(icon: Icon(Icons.favorite, size: _iconSize)),
                Tab(icon: Icon(Icons.settings, size: _iconSize)),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: body,
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (appState!.isLoading) {
      return _buildTabView(
        body: _buildLoadingIndicator(),
      );
    } else if (!appState!.isLoading && appState!.user == null) {
      return const LoginScreen();
    } else {
      return _buildTabView(
        body: _buildTabsContent(),
      );
    }
  }

  Center _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // Inactive widgets are going to call this method to
  // signalize the parent widget HomeScreen to refresh the list view:
  void _handleFavoritesListChanged(String recipeID) {
    updateFavorites(appState!.user!.uid, recipeID).then((result) {
      //update the state:
      if (result == true) {
        setState(() {
          if (!appState!.favorites!.contains(recipeID)) {
            appState?.favorites?.add(recipeID);
          } else {
            appState?.favorites?.remove(recipeID);
          }
        });
      }
    });
  }

  TabBarView _buildTabsContent() {
    Scaffold _buildRecipes({RecipeType? recipeType, List<String>? ids}) {
      CollectionReference recipes =
          FirebaseFirestore.instance.collection('recipes');
      Stream<QuerySnapshot> stream;
      bool includeAddButton = false;

      //The argument recipeType is set
      if (recipeType != null) {
        stream = recipes.where("type", isEqualTo: recipeType.index).snapshots();
        includeAddButton = true;
      } else {
        //use snapshots of all recipes if recipeType has not been passed
        stream = recipes.snapshots();
      }

      return Scaffold(
        body: Padding(
          // Padding before and after the list view:
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return _buildLoadingIndicator();

                    return ListView(
                      children: snapshot.data!.docs
                          .where((d) => ids == null || ids.contains(d.id))
                          .map((document) {
                        return RecipeCard(
                          recipe: Recipe.fromMap(
                              document.data() as Map<String, dynamic>,
                              document.id),
                          inFavorites:
                              appState?.favorites?.contains(document.id) ??
                                  false,
                          onFavoriteButtonPressed: _handleFavoritesListChanged,
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: includeAddButton
            ? FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => {createRecipe(context, RecipeType.food)},
              )
            : null,
      );
    }

    return TabBarView(
      children: [
        _buildRecipes(recipeType: RecipeType.food),
        _buildRecipes(recipeType: RecipeType.drink),
        _buildRecipes(ids: appState!.favorites!),
        _buildSettings(),
      ],
    );
  }

  Column _buildSettings() {
    //Delay this somehow till after account is loaded
    // return Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Text(user!.email!),
    //       Text(user!.displayName!),
    //       CircleAvatar(
    //         backgroundImage: NetworkImage(user!.photoURL!),
    //         radius: 20,
    //       ),
    //     ],
    //   ),
    // );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SettingsButton(
              Icons.exit_to_app,
              "Log out",
              appState?.user!.displayName ?? 'User',
              () async {
                await StateWidget.of(context).signOutOfGoogle();
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(appState!.user!.photoURL!),
                radius: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    return _buildContent();
  }
}
