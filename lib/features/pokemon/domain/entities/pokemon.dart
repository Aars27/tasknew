import 'package:equatable/equatable.dart';

class Pokemon extends Equatable {
  final String id;
  final String name;
  final String? hp;
  final List<String>? types;
  final String imageUrl;
  final String largeImageUrl;
  final List<PokemonAttack>? attacks;

  const Pokemon({
    required this.id,
    required this.name,
    this.hp,
    this.types,
    required this.imageUrl,
    required this.largeImageUrl,
    this.attacks,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        hp,
        types,
        imageUrl,
        largeImageUrl,
        attacks,
      ];
}

class PokemonAttack extends Equatable {
  final String name;
  final List<String>? cost;
  final int? convertedEnergyCost;
  final String? damage;
  final String? text;

  const PokemonAttack({
    required this.name,
    this.cost,
    this.convertedEnergyCost,
    this.damage,
    this.text,
  });

  @override
  List<Object?> get props => [name, cost, convertedEnergyCost, damage, text];
}
