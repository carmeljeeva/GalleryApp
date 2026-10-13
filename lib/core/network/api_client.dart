import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;
  ApiClient({Dio? dio})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://pixabay.com/api',
              connectTimeout: Duration(seconds: 10),
              receiveTimeout: Duration(seconds: 10),
            ),
          );
}
