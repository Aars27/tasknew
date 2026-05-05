
import 'package:equatable/equatable.dart';

abstract class PokemonEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPokemon extends PokemonEvent {
  final int page;
  final String query;

  FetchPokemon(this.page, this.query);
}