import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/core/dio_client.dart';
import 'package:task/features/data/repository/pokemon_repository.dart';
import 'package:task/router/Presentation/bloc/pokemon_bloc.dart';
import 'package:task/router/Presentation/bloc/pokemon_event.dart';
import 'package:task/router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final dio = DioClient().dio;
  final repository = PokemonRepository(dio);

  runApp(
    BlocProvider(
      create: (_) => PokemonBloc(repository)..add(FetchPokemon(1, '')),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pokemon TCG',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}