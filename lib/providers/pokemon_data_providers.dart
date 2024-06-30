import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/services/database_service.dart';
import 'package:pokedex/services/http_services.dart';

final pokemonDataProvider =
    FutureProvider.family<Pokemon?, String>((ref, url) async {
  HTTPServices _httpService = GetIt.instance.get<HTTPServices>();
  Response? res = await _httpService.get(url);
  if (res != null && res.data != null) {
    return Pokemon.fromJson(res.data);
  }
  return null;
});

final favoritePokemonProvider = StateNotifierProvider<FavoritePokemonProvider, List<String>>((ref){
  return FavoritePokemonProvider([]);
});
class FavoritePokemonProvider extends StateNotifier<List<String>>{
  final DatabaseService _databaseService = GetIt.instance.get<DatabaseService>();

  String FAV_POKEMON_KEY = "FAV_POKEMON_KEY";
  FavoritePokemonProvider(super._state){
    _setup();
  }
  Future<void> _setup() async{

    List<String>? result = await _databaseService.getList(FAV_POKEMON_KEY);
    state = result ?? [];
  }
  void addFavoritePokemon(String url){
    state = [...state, url];
    _databaseService.saveList(FAV_POKEMON_KEY, state);
  }

  void removeFavoritePokemon(String url){
    state = state.where((e)=> e!=url).toList();
    _databaseService.saveList(FAV_POKEMON_KEY, state);

  }
  }