
import 'package:dio/dio.dart';
import '../models/pokemon_card_model.dart';

class PokemonRepository {
  final Dio dio;

  PokemonRepository(this.dio);

  Future<List<PokemonCard>> fetchCards(int page, String query) async {
    final response = await dio.get(
      'cards',
      queryParameters: {
        'page': page,
        'pageSize': 10,
        if (query.isNotEmpty) 'q': 'set.name:$query',
      },
    );

    final data = response.data['data'] as List;

    return data.map((e) => PokemonCard.fromJson(e)).toList();
  }
}