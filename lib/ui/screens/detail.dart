import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:recipes_app/model/recipe.dart';
import 'package:recipes_app/ui/widgets/recipe_title.dart';
// import 'package:recipes_app/model/state.dart';
// import 'package:recipes_app/state_widget.dart';
// import 'package:recipes_app/utils/store.dart';
import 'package:recipes_app/services/firebase_service.dart';
import 'package:recipes_app/ui/widgets/recipe_image.dart';

class DetailScreen extends StatefulWidget {
  final Recipe recipe;
  // final bool inFavorites;

  const DetailScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  ScrollController? _scrollController;
  bool? _inFavorites;
  // StateModel? appState;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollController = ScrollController();
    // _inFavorites = widget.inFavorites;
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  // void _toggleInFavorites() {
  //   setState(() {
  //     _inFavorites = !_inFavorites!;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // appState = StateWidget.of(context).state;

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerViewIsScrolled) {
          return <Widget>[
            SliverAppBar(
              // backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RecipeImage(widget.recipe.imageURL),
                    RecipeTitle(widget.recipe, 25.0),
                  ],
                ),
              ),
              //TODO: make this dynamic
              expandedHeight: 360.0,
              primary: true,
              pinned: true,
              floating: true,
              elevation: 2.0,
              forceElevated: innerViewIsScrolled,
              bottom: TabBar(
                tabs: const [
                  Tab(text: "Home"),
                  Tab(text: "Preparation"),
                ],
                controller: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          children: [
            IngredientsView(widget.recipe.ingredients),
            PreparationView(widget.recipe.preparation),
          ],
          controller: _tabController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<FirebaseService>(context, listen: false)
              .updateFavorites(widget.recipe.id)
              .then((result) {
            // if (result) _toggleInFavorites();
          });
          // print("favorit button");
        },
        child: Icon(
          context.select<FirebaseService, bool>(
                  (service) => service.favorites.contains(widget.recipe.id))
              ? Icons.favorite
              : Icons.favorite_border,
          // color: Theme.of(context).iconTheme.color,
        ),
        elevation: 2.0,
        // backgroundColor: Colors.white,
      ),
    );
  }
}

class IngredientsView extends StatelessWidget {
  final List<String> ingredients;

  IngredientsView(this.ingredients);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[];
    ingredients.forEach((item) {
      children.add(
        Row(
          children: [
            const Icon(Icons.done),
            const SizedBox(width: 5.0),
            Text(item),
          ],
        ),
      );
      children.add(
        const SizedBox(
          height: 5.0,
        ),
      );
    });
    return ListView(
      padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 75.0),
      children: children,
    );
  }
}

class PreparationView extends StatelessWidget {
  final List<String> preparationSteps;

  PreparationView(this.preparationSteps);

  @override
  Widget build(BuildContext context) {
    List<Widget> textElements = <Widget>[];
    preparationSteps.forEach((item) {
      textElements.add(
        Text(item),
      );
      textElements.add(
        const SizedBox(
          height: 10.0,
        ),
      );
    });

    return ListView(
      padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 75.0),
      children: textElements,
    );
  }
}
