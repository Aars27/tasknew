
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../features/data/models/pokemon_card_model.dart';



class DetailScreen extends StatelessWidget {
  final PokemonCard card;

  const DetailScreen({super.key, required this.card});

  // Type color map (keep in sync with HomeScreen)
  static const Map<String, Color> typeColors = {
    'Fire': Color(0xFFFF6B35),
    'Water': Color(0xFF4FC3F7),
    'Grass': Color(0xFF66BB6A),
    'Electric': Color(0xFFFFD54F),
    'Psychic': Color(0xFFEC407A),
    'Ice': Color(0xFF80DEEA),
    'Dragon': Color(0xFF7E57C2),
    'Dark': Color(0xFF546E7A),
    'Fairy': Color(0xFFF48FB1),
    'Fighting': Color(0xFFEF5350),
    'Poison': Color(0xFFAB47BC),
    'Ground': Color(0xFFD4A76A),
    'Rock': Color(0xFF8D6E63),
    'Bug': Color(0xFF9CCC65),
    'Ghost': Color(0xFF5C6BC0),
    'Steel': Color(0xFF90A4AE),
    'Normal': Color(0xFFBDBDBD),
    'Flying': Color(0xFF81D4FA),
    'Colorless': Color(0xFFB0BEC5),
  };

  Color get _typeColor =>
      typeColors[card.types?.firstOrNull] ?? const Color(0xFF5C6BC0);

  @override
  Widget build(BuildContext context) {
    final color = _typeColor;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context, color),
          _buildBody(context, color),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Color color) {
    return SliverAppBar(
      expandedHeight: 380,
      pinned: true,
      stretch: true,
      backgroundColor: const Color(0xFF0D0D1A),
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          ),
          child: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 16),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          ),
          child: IconButton(
            icon: const Icon(Icons.favorite_border,
                color: Colors.white, size: 18),
            onPressed: () {},
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Radial glow background
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [
                    color.withOpacity(0.35),
                    const Color(0xFF0D0D1A),
                  ],
                ),
              ),
            ),
            // Decorative circles
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: color.withOpacity(0.12), width: 40),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: -40,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: color.withOpacity(0.08), width: 25),
                ),
              ),
            ),
            // Hero card image
            Padding(
              padding: const EdgeInsets.only(top: 60, bottom: 20),
              child: Hero(
                tag: card.id,
                child: CachedNetworkImage(
                  imageUrl: card.image,
                  fit: BoxFit.contain,
                  placeholder: (_, __) => Center(
                    child: CircularProgressIndicator(
                        color: color, strokeWidth: 2),
                  ),
                  errorWidget: (_, __, ___) => Icon(
                    Icons.catching_pokemon,
                    size: 80,
                    color: color.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            // Bottom fade
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 80,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF0D0D1A),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Color color) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Name + Rarity ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    card.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                      height: 1.1,
                    ),
                  ),
                ),
                if (card.rarity != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: color.withOpacity(0.35), width: 1),
                    ),
                    child: Text(
                      card.rarity!,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // ── Set name ──
            if (card.setName != null)
              Text(
                card.setName!,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              ),

            const SizedBox(height: 20),

            // ── Type badges ──
            if (card.types != null && card.types!.isNotEmpty) ...[
              _sectionLabel('Types'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: card.types!.map((type) {
                  final tColor =
                      typeColors[type] ?? const Color(0xFF5C6BC0);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          tColor.withOpacity(0.3),
                          tColor.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: tColor.withOpacity(0.5), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: tColor.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        color: tColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],

            // ── Stats row ──
            _buildStatsRow(color),

            const SizedBox(height: 24),

            // ── Flavor text ──
            if (card.flavorText != null && card.flavorText!.isNotEmpty) ...[
              _sectionLabel('Card Lore'),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: color.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Text(
                  '"${card.flavorText!}"',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(Color color) {
    final stats = <Map<String, String?>>[
      {'label': 'HP', 'value': card.hp},
      {'label': 'Set', 'value': card.setName},
      {'label': 'Rarity', 'value': card.rarity},
    ].where((s) => s['value'] != null).toList();

    if (stats.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.07),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.asMap().entries.map((entry) {
          final i = entry.key;
          final stat = entry.value;
          return Expanded(
            child: Row(
              children: [
                if (i > 0)
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withOpacity(0.08),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        stat['value']!,
                        style: TextStyle(
                          color: color,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stat['label']!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.35),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _sectionLabel(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: Colors.white.withOpacity(0.35),
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.8,
      ),
    );
  }
}