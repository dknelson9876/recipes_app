import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:recipes_app/model/recipe.dart';
import 'package:recipes_app/model/state.dart';
import 'package:recipes_app/state_widget.dart';
import 'package:recipes_app/ui/screens/login.dart';
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
  List<Recipe> recipes = getRecipes();
  List<String> userFavorites = getFavoritesIDs();
  User? user = FirebaseAuth.instance.currentUser;

  DefaultTabController _buildTabView({required Widget body}) {
    const double _iconSize = 20.0;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          // We set Size equal to passed height (50.0) and infinite width:
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 2.0,
            bottom: TabBar(
              labelColor: Theme.of(context).indicatorColor,
              tabs: const [
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
    setState(() {
      if (userFavorites.contains(recipeID)) {
        userFavorites.remove(recipeID);
      } else {
        userFavorites.add(recipeID);
      }
    });
  }

  TabBarView _buildTabsContent() {
    Padding _buildRecipes(List<Recipe> recipesList) {
      return Padding(
        // Padding before and after the list view:
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: recipesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return RecipeCard(
                    recipe: recipesList[index],
                    inFavorites: userFavorites.contains(recipesList[index].id),
                    onFavoriteButtonPressed: _handleFavoritesListChanged,
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    return TabBarView(
      children: [
        _buildRecipes(
            recipes.where((recipe) => recipe.type == RecipeType.food).toList()),
        _buildRecipes(recipes
            .where((recipe) => recipe.type == RecipeType.drink)
            .toList()),
        _buildRecipes(recipes
            .where((recipe) => userFavorites.contains(recipe.id))
            .toList()),
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
                backgroundImage: NetworkImage(user!.photoURL!),
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
