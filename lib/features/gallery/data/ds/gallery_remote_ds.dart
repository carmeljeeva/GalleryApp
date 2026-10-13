import 'package:dio/dio.dart' show DioException, Dio, DioExceptionType;
import 'package:project_gallery/core/failures.dart';
import 'package:project_gallery/core/network/api_client.dart';
import 'package:project_gallery/features/gallery/data/models/image_response_model.dart';
import 'package:project_gallery/features/gallery/domain/entities/image_model.dart';

class GalleryRemoteDS {
  final ApiClient apiClient;
  final String apiKey;

  GalleryRemoteDS({required this.apiClient, required this.apiKey});

  Future<ApiResult> fetchImages({required int page}) async {
    try {
      final response = await apiClient.dio.get<Map<String, dynamic>>(
        '/',
        queryParameters: {
          'key': apiKey,
          'image_type': 'photo',
          'per_page': 20,
          'page': page,
        },
      );
      if (response.data == null) {
        throw Exception('Empty response from Pixa');
      }
      final data = response.data as Map<String, dynamic>;
      final hits = (data['hits'] as List)
          .map((e) => ImageResponseModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult(images: hits, totalHits: data['totalHits'] as int);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 && page > 1) {
        return const ApiResult(images: [], totalHits: 0);
      }
      throw Failure(_message(e));
    } catch (_) {
      throw const Failure('Unexpected error!');
    }
  }

  String _message(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Request Timed out! try again!';
      case DioExceptionType.connectionError:
        return 'No Internet Connection!';
      default:
        final code = e.response?.statusCode;
        if (code == 429) return 'Rate limit reached!';
        if (code == 401 || code == 403) return 'API key missing or erro!';
        return 'Server err${code != null ? '($code)' : ''}';
    }
  }
}
