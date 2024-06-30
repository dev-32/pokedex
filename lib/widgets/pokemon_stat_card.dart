import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/providers/pokemon_data_providers.dart';

class PokemonStatCard extends ConsumerWidget {
  final String pokemonURL;

 const PokemonStatCard({super.key, required this.pokemonURL});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonURL));
    return AlertDialog(
      title: const Text('Statistics'),
      content: pokemon.when(data: (data){
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: data?.stats?.map(
              (s) => Text('${s.stat?.name?.toUpperCase()} : ${s.baseStat}')
          ).toList() ?? [],
        );
      },
          error: (error, stackTrace){
        return Text('Error:${error}');
          },
          loading: ()=>  const CircularProgressIndicator(
            color: Colors.white,
          )),
    );
  }

}