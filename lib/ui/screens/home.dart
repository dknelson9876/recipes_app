import 'package:flutter/material.dart';

import 'package:recipes_app/model/recipe.dart';
import 'package:recipes_app/model/state.dart';
import 'package:recipes_app/state_widget.dart';
import 'package:recipes_app/ui/screens/login.dart';
import 'package:recipes_app/ui/widgets/recipe_card.dart';
import 'package:recipes_app/utils/store.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late StateModel appState;
  List<Recipe> recipes = getRecipes();
  List<String> userFavorites = getFavoritesIDs();

  DefaultTabController _buildTabView({required Widget body}) {
    double _iconSize = 20.0;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 2.0,
            bottom: TabBar(
              labelColor: Theme.of(context).indicatorColor,
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
    if (appState.isLoading) {
      return _buildTabView(
        body: _buildLoadingIndicator(),
      );
    } else if (!appState.isLoading && appState == null) {
      return LoginScreen();
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

  TabBarView _buildTabsContent() {
    Padding _buildRecipes(List<Recipe> recipesList) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          children: [
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
        //food type page
        _buildRecipes(
            recipes.where((recipe) => recipe.type == RecipeType.food).toList()),
        //drink type page
        _buildRecipes(recipes
            .where((recipe) => recipe.type == RecipeType.drink)
            .toList()),
        //display favorites
        _buildRecipes(recipes
            .where((recipe) => userFavorites.contains(recipe.id))
            .toList()),
        //placeholder settings page
        const Center(child: Icon(Icons.settings)),
      ],
    );
  }

  //for signalling to the parent that a refresh is needed
  void _handleFavoritesListChanged(String recipeID) {
    setState(() {
      if (userFavorites.contains(recipeID)) {
        userFavorites.remove(recipeID);
      } else {
        userFavorites.add(recipeID);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;

    return _buildContent();
  }
}
