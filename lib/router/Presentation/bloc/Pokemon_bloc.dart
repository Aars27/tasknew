
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/data/models/pokemon_card_model.dart';
import '../../../features/data/repository/pokemon_repository.dart';
import 'pokemon_event.dart';
import 'pokemon_state.dart';




class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonRepository repository;

  int currentPage = 1;
  List<PokemonCard> allCards = [];

  PokemonBloc(this.repository) : super(PokemonLoading()) {
    on<FetchPokemon>((event, emit) async {
      try {
        if (event.page == 1) {
          emit(PokemonLoading());
          allCards.clear();
        }

        final cards = await repository.fetchCards(event.page, event.query);

        allCards.addAll(cards);

        emit(PokemonLoaded(allCards, cards.isEmpty));
      } catch (e) {
        emit(PokemonError());
      }
    });
  }
}