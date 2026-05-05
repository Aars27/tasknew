import 'package:go_router/go_router.dart';
import 'package:task/features/data/models/pokemon_card_model.dart';
import 'Presentation/Screens/details_screen.dart';
import 'Presentation/Screens/home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        final card = state.extra as PokemonCard;
        return DetailScreen(card: card);
      },
    ),
  ],
);