class PokemonCard {
  final String id;
  final String name;
  final String image;
  final String? hp;
  final String? rarity;
  final String? setName;
  final String? flavorText;
  final List<String>? types;

  PokemonCard({
    required this.id,
    required this.name,
    required this.image,
    this.hp,
    this.rarity,
    this.setName,
    this.flavorText,
    this.types,
  });

  factory PokemonCard.fromJson(Map<String, dynamic> json) {
    return PokemonCard(
      id: json['id'],
      name: json['name'],
      image: json['images']['large'],
      hp: json['hp'],
      rarity: json['rarity'],
      setName: json['set']?['name'],
      flavorText: json['flavorText'],
      types: (json['types'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}