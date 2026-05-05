// core/dio_client.dart
import 'package:dio/dio.dart';

class DioClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.pokemontcg.io/v2/',
      connectTimeout: const Duration(seconds: 10),
    ),
  );
}