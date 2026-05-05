
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../bloc/pokemon_bloc.dart';
import '../bloc/pokemon_event.dart';
import '../bloc/pokemon_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fadeController;
  int _page = 1;
  String _query = '';
  late PokemonBloc pokemonBloc;

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

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    pokemonBloc = context.read<PokemonBloc>();

    pokemonBloc.add(FetchPokemon(_page, _query));

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _page++;
      pokemonBloc.add(FetchPokemon(_page, _query));
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildGridLabel(),
            Expanded(child: _buildGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFFF3B3B), Color(0xFFFF6B6B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF3B3B).withOpacity(0.5),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.catching_pokemon,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PokéDex Cards',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Collect them all',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: Colors.white.withOpacity(0.1), width: 1),
            ),
            child: const Icon(Icons.filter_list,
                color: Colors.white70, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Search cards, sets, types...',
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 14,
            ),
            prefixIcon: Icon(Icons.search,
                color: Colors.white.withOpacity(0.4), size: 20),
            suffixIcon: _query.isNotEmpty
                ? GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() => _query = '');
                _page = 1;
                pokemonBloc.add(FetchPokemon(_page, ''));
              },
              child: Icon(Icons.close,
                  color: Colors.white.withOpacity(0.4), size: 18),
            )
                : null,
            filled: false,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: InputBorder.none,
          ),
          onChanged: (val) {
            setState(() => _query = val);
            _page = 1;
            pokemonBloc.add(FetchPokemon(_page, val));
          },
        ),
      ),
    );
  }

  Widget _buildGridLabel() {
    return BlocBuilder<PokemonBloc, PokemonState>(
      builder: (context, state) {
        if (state is PokemonLoaded) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Text(
              '${state.cards.length} Cards Found',
              style: TextStyle(
                color: Colors.white.withOpacity(0.35),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.0,
              ),
            ),
          );
        }
        return const SizedBox(height: 8);
      },
    );
  }

  Widget _buildGrid() {
    return BlocBuilder<PokemonBloc, PokemonState>(
      builder: (context, state) {
        if (state is PokemonLoading) {
          return _shimmerGrid();
        }

        if (state is PokemonLoaded) {
          if (state.cards.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off,
                      size: 48, color: Colors.white.withOpacity(0.2)),
                  const SizedBox(height: 12),
                  Text(
                    'No cards found',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.3), fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return FadeTransition(
            opacity: _fadeController,
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.62,
              ),
              itemCount: state.cards.length,
              itemBuilder: (context, index) {
                final card = state.cards[index];
                final typeColor =
                    typeColors[card.types?.firstOrNull] ??
                        const Color(0xFF5C6BC0);
                return _PokemonCardTile(
                  card: card,
                  typeColor: typeColor,
                  index: index,
                );
              },
            ),
          );
        }

        // PokemonError state
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off,
                  size: 48, color: Colors.white.withOpacity(0.2)),
              const SizedBox(height: 12),
              Text(
                'Something went wrong',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.3), fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  _page = 1;
                  pokemonBloc.add(FetchPokemon(_page, _query));
                },
                child: const Text('Retry',
                    style: TextStyle(color: Color(0xFF5C6BC0))),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _shimmerGrid() {
    return GridView.builder(
      itemCount: 6,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: const Color(0xFF1A1A2E),
        highlightColor: const Color(0xFF252540),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

// ─── Individual Card Tile ───────────────────────────────────────────────────

class _PokemonCardTile extends StatefulWidget {
  final dynamic card;
  final Color typeColor;
  final int index;

  const _PokemonCardTile({
    required this.card,
    required this.typeColor,
    required this.index,
  });

  @override
  State<_PokemonCardTile> createState() => _PokemonCardTileState();
}

class _PokemonCardTileState extends State<_PokemonCardTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        context.push('/detail', extra: widget.card);
      },
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnim.value, child: child),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.typeColor.withOpacity(0.15),
                const Color(0xFF12121F),
              ],
            ),
            border: Border.all(
              color: widget.typeColor.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.typeColor.withOpacity(0.12),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Expanded(
                flex: 7,
                child: ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              widget.typeColor.withOpacity(0.2),
                              Colors.transparent,
                            ],
                            radius: 0.8,
                          ),
                        ),
                      ),
                      Hero(
                        tag: widget.card.id,
                        child: CachedNetworkImage(
                          imageUrl: widget.card.image,
                          fit: BoxFit.contain,
                          placeholder: (_, __) => Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: widget.typeColor.withOpacity(0.6),
                              ),
                            ),
                          ),
                          errorWidget: (_, __, ___) => Icon(
                            Icons.catching_pokemon,
                            color: widget.typeColor.withOpacity(0.3),
                            size: 40,
                          ),
                        ),
                      ),
                      if (widget.card.hp != null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: widget.typeColor.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'HP ${widget.card.hp}',
                              style: TextStyle(
                                color: widget.typeColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Info
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.card.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.card.types != null &&
                          widget.card.types!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: widget.typeColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: widget.typeColor.withOpacity(0.4),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            widget.card.types!.first,
                            style: TextStyle(
                              color: widget.typeColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      else if (widget.card.setName != null)
                        Text(
                          widget.card.setName!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.35),
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}