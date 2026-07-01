import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rd_loca_news/details/models/details_model.dart';

class DetailsService {
  static final DetailsService _instance = DetailsService._internal();
  factory DetailsService() => _instance;

  late final Dio _dio;

  DetailsService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: _timeout,
      receiveTimeout: _timeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) => status != null && status < 400,
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log('🌐 DETAILS REQUEST: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log('✅ DETAILS RESPONSE: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (error, handler) {
          log('❌ DETAILS ERROR: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  static const String _baseUrl =
      'https://api-scrapping-news-rd.onrender.com/api';
  static const Duration _timeout = Duration(seconds: 45);
  static const Duration _cacheDuration = Duration(minutes: 30);

  final Map<String, _CachedDetail> _cache = {};

  Future<Detail> getDetailsOfNew(String url,
      {bool forceRefresh = false}) async {
    try {
      if (url.isEmpty) {
        throw DetailsServiceException(
          'La URL no puede estar vacía',
          type: DetailsErrorType.invalidParameter,
        );
      }

      if (!_isValidUrl(url)) {
        throw DetailsServiceException(
          'URL inválida',
          type: DetailsErrorType.invalidParameter,
        );
      }

      // Usar cache si existe
      if (!forceRefresh) {
        final cached = _cache[url];
        if (cached != null &&
            DateTime.now().difference(cached.timestamp) <= _cacheDuration) {
          log('📦 Usando cache para $url');
          return cached.detail;
        }
      }

      log('🔄 Obteniendo detalles de: $url');
      final response = await _dio.post<dynamic>('/details', data: {'url': url});
      log('RAW RESPONSE: ${response.data}');

      final data = response.data;
      if (data == null || data['data'] == null) {
        throw DetailsServiceException(
          'No se encontró contenido en la noticia',
          type: DetailsErrorType.emptyResponse,
        );
      }

      Detail detail;
      try {
        detail = Detail.fromJson(data['data'] as Map<String, dynamic>);
        // // Fallback de imagen si es null
        // detail.img ??= 'https://via.placeholder.com/150';
      } catch (e) {
        log('❌ Error al parsear detalles: $e');
        throw DetailsServiceException(
          'Error al procesar los detalles de la noticia',
          type: DetailsErrorType.parseError,
          originalError: e,
        );
      }

      _cache[url] = _CachedDetail(detail: detail, timestamp: DateTime.now());
      return detail;
    } on DioException catch (e) {
      throw _handleDioError(e, url);
    } catch (e, st) {
      log('❌ Error inesperado en getDetailsOfNew: $e\n$st');
      throw DetailsServiceException(
        'Error inesperado al obtener detalles: $e',
        type: DetailsErrorType.unknown,
        originalError: e,
      );
    }
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } on Exception catch (_) {
      return false;
    }
  }

  DetailsServiceException _handleDioError(DioException error, String url) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return DetailsServiceException(
          'La carga está tardando mucho. Intenta de nuevo más tarde.',
          type: DetailsErrorType.timeout,
          url: url,
          originalError: error,
        );
      case DioExceptionType.connectionError:
        return DetailsServiceException(
          'Sin conexión a internet.',
          type: DetailsErrorType.noConnection,
          url: url,
          originalError: error,
        );
      case DioExceptionType.badResponse:
        return DetailsServiceException(
          'Error del servidor: ${error.response?.statusCode}',
          type: DetailsErrorType.serverError,
          url: url,
          statusCode: error.response?.statusCode,
          originalError: error,
        );
      case DioExceptionType.cancel:
        return DetailsServiceException(
          'Petición cancelada',
          type: DetailsErrorType.cancelled,
          url: url,
          originalError: error,
        );
      default:
        return DetailsServiceException(
          'Error de red: ${error.message}',
          type: DetailsErrorType.unknown,
          url: url,
          originalError: error,
        );
    }
  }
}

class _CachedDetail {
  final Detail detail;
  final DateTime timestamp;
  _CachedDetail({required this.detail, required this.timestamp});
}

class DetailsServiceException implements Exception {
  final String message;
  final DetailsErrorType type;
  final int? statusCode;
  final String? url;
  final dynamic originalError;

  DetailsServiceException(this.message,
      {required this.type, this.statusCode, this.url, this.originalError});

  @override
  String toString() => 'DetailsServiceException: $message';
}

enum DetailsErrorType {
  timeout,
  noConnection,
  serverError,
  invalidFormat,
  parseError,
  emptyResponse,
  invalidParameter,
  cancelled,
  unknown,
}
