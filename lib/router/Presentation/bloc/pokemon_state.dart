
import 'package:equatable/equatable.dart';

import '../../../features/data/models/pokemon_card_model.dart';





abstract class PokemonState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PokemonLoading extends PokemonState {}

class PokemonLoaded extends PokemonState {
  final List<PokemonCard> cards;
  final bool hasReachedMax;

  PokemonLoaded(this.cards, this.hasReachedMax);

  @override
  List<Object?> get props => [cards, hasReachedMax];
}

class PokemonError extends PokemonState {}