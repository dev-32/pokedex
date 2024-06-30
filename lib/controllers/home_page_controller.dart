import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/models/page_data.dart';
import 'package:pokedex/models/pokemon.dart';

import '../services/http_services.dart';

class HomePageController extends StateNotifier<HomePageData> {
  final GetIt _getIt = GetIt.instance;

  late HTTPServices _httpServices;

  HomePageController(super._state) {
    _httpServices = _getIt.get<HTTPServices>();
    _setup();
  }
  Future<void> _setup() async {
    loadData();
  }

  Future<void> loadData() async {
    if (state.data == null) {
      Response? res = await _httpServices
          .get('https://pokeapi.co/api/v2/pokemon?limit=20&offset=0');
      if(res != null && res.data != null){
        PokemonListData data = PokemonListData.fromJson(res.data);
        state = state.copyWith(data: data);
      }
    } else {
      if(state.data?.next != null){
        Response? res = await _httpServices
            .get(state.data!.next!);
        if(res !=null && res.data !=null){
          PokemonListData data = PokemonListData.fromJson(res.data);
          state = state.copyWith(
            data: data.copyWith(
              results: [
                ...?state.data!.results,
                ...?data.results,
              ]
            )
          );
        }
      }
    }
  }
}
