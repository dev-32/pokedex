import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/providers/pokemon_data_providers.dart';
import 'package:pokedex/widgets/pokemon_stat_card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../models/pokemon.dart';

class PokemonCard extends ConsumerWidget {
  final String pokemonURL;
  late FavoritePokemonProvider _favoritePokemonProvider;
  PokemonCard({super.key, required this.pokemonURL});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonURL));
    _favoritePokemonProvider = ref.watch(favoritePokemonProvider.notifier);
    return pokemon.when(data: (data) => _card(context, false, data),
        error: (error, stackTrace) {
          return Text('Error: $error');
        },
        loading: () => _card(context, true, null));
  }

    Widget _card(BuildContext context, bool isLoading, Pokemon? pokemon) {
      Size size = MediaQuery.of(context).size;
      return Skeletonizer(
        enabled: isLoading,
        child: GestureDetector(
          onTap: (){
            if(!isLoading){
              showDialog(context: context, builder: (_){
                return PokemonStatCard(pokemonURL: pokemonURL);
              });
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: size.width * 0.03,
              vertical: size.height * 0.01,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.03,
              vertical: size.height * 0.01,
            ),
            decoration: BoxDecoration(
              color: Colors.orange.shade400,
              borderRadius: BorderRadius.circular(15),
              boxShadow:  const [BoxShadow(
                color: Colors.black26,
                spreadRadius: 2,
                blurRadius: 10,
              )]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(pokemon?.name?.toUpperCase() ?? 'Pokemon'),
                    Text('#${pokemon?.id.toString() ?? 0}'),
                  ],
                ),
                Expanded(
                  child: CircleAvatar(
                    backgroundColor: Colors.orange.shade100,
                    backgroundImage: pokemon!=null ? NetworkImage(pokemon.sprites!.frontDefault!) : null,
                    radius: size.height * 0.06,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Text("${pokemon?.moves?.length.toString() ?? 0} Moves"),
                      GestureDetector(
                        onTap: (){
                          _favoritePokemonProvider.removeFavoritePokemon(pokemonURL);
                        },
                          child: const Icon(Icons.favorite, color: Colors.red,))
                  ],
                )
              ],
            ),
          ),
        ),
      );
  }
}
