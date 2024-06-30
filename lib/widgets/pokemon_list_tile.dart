import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/providers/pokemon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonURL;
  late FavoritePokemonProvider _favoritePokemonProvider;
  late List<String> _favoritePokemons;
  PokemonListTile({super.key, required this.pokemonURL});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    _favoritePokemonProvider = ref.watch(favoritePokemonProvider.notifier);
    _favoritePokemons = ref.watch(favoritePokemonProvider);
    final pokemon = ref.watch(pokemonDataProvider(pokemonURL));
    
    return pokemon.when(data: (data)=> _tile(context, false, data),
        error: (error, stackTrace){
      return Text('Error:$error');
        },
        loading: ()=> _tile(context, true, null));
  }
  Widget _tile(BuildContext context, bool isLoading, Pokemon? pokemon){
    return Skeletonizer(
      enabled: isLoading,
      child: ListTile(
        leading: pokemon!=null ? CircleAvatar(
          backgroundImage: NetworkImage(
            pokemon.sprites!.frontDefault!
          ),
          backgroundColor: Colors.orange.shade200,
        ) : const CircleAvatar(),
        title: Text( pokemon != null ? pokemon.name!.toUpperCase() : "loading..." ),
        subtitle: Text("Has ${pokemon?.moves?.length.toString() ?? 0} moves"),
        trailing:IconButton(
          onPressed: (){
            if(_favoritePokemons.contains(pokemonURL)){
              _favoritePokemonProvider.removeFavoritePokemon(pokemonURL);
            }else{
              _favoritePokemonProvider.addFavoritePokemon(pokemonURL);
            }
          },
          icon:  Icon(
            _favoritePokemons.contains(pokemonURL) ? Icons.favorite  :Icons.favorite_border,
          color: Colors.red,),
        ),
      ),
    );
  }
}
