import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/controllers/home_page_controller.dart';
import 'package:pokedex/models/page_data.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/providers/pokemon_data_providers.dart';
import 'package:pokedex/widgets/pokemon_card.dart';
import 'package:pokedex/widgets/pokemon_list_tile.dart';

import '../widgets/pokemon_stat_card.dart';

final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>((ref) {
  return HomePageController(HomePageData.initial());
});

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final ScrollController _allPokemonListScrollController = ScrollController();

  late HomePageController _homePageController;
  late HomePageData _homePageData;

  late List<String> _favoritePokemons;

  @override
  void initState() {
    super.initState();
    _allPokemonListScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _allPokemonListScrollController.removeListener(_scrollListener);
    _allPokemonListScrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_allPokemonListScrollController.offset >=
            _allPokemonListScrollController.position.maxScrollExtent * 1 &&
        !_allPokemonListScrollController.position.outOfRange) {
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(homePageControllerProvider.notifier);
    _homePageData = ref.watch(homePageControllerProvider);
    _favoritePokemons = ref.watch(favoritePokemonProvider);
    Size size = MediaQuery.of(context).size;
    Widget _favoritePokemonsList(BuildContext context) {
      return SizedBox(
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Favorites",
              style: TextStyle(fontSize: size.height * 0.022),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.46,
                  child: _favoritePokemons.isNotEmpty
                      ? GridView.builder(
                    scrollDirection: Axis.horizontal,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemCount: _favoritePokemons.length,
                          itemBuilder: (context, index) {
                            return PokemonCard(
                                pokemonURL: _favoritePokemons[index]);
                          })
                      : const Center(child:  Text("No Favorite Pokemons Yet! :(")),
                )
              ],
            )
          ],
        ),
      );
    }

    Widget _allPokemons(BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All Pokemons',
            style: TextStyle(fontSize: size.height * 0.02),
          ),
          SizedBox(
            height: size.height * 0.36,
            child: ListView.builder(
                controller: _allPokemonListScrollController,
                itemCount: _homePageData.data?.results?.length ?? 0,
                itemBuilder: (context, index) {
                  PokemonListResult pokemon =
                      _homePageData.data!.results![index];
                  return GestureDetector(
                      onTap: (){
                          showDialog(context: context, builder: (_){
                            return PokemonStatCard(pokemonURL: pokemon.url!);
                          });
                      },
                      child: PokemonListTile(pokemonURL: pokemon.url!));
                }),
          )
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _favoritePokemonsList(context),
              _allPokemons(context),
            ],
          ),
        ),
      ),
    );
  }
}
