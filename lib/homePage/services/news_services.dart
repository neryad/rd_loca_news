import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rd_loca_news/homePage/models/news_model.dart';

class NewsService {
  // Singleton pattern para reutilizar la instancia de Dio
  static final NewsService _instance = NewsService._internal();
  factory NewsService() => _instance;
  NewsService._internal();

  // Instancia única de Dio con configuración
  late final Dio _dio;

  // Configuración de la API
  static const String _baseUrl =
      'https://api-scrapping-news-rd.onrender.com/api';
  static const Duration _timeout = Duration(seconds: 30);
  static const Duration _cacheDuration = Duration(minutes: 5);

  // Cache simple en memoria
  final Map<String, _CachedNews> _cache = {};

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: _timeout,
        receiveTimeout: _timeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) {
          // Acepta códigos 2xx y 3xx
          return status != null && status < 400;
        },
      ),
    );

    // Interceptor para logs en desarrollo
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log('🌐 REQUEST: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          log('❌ ERROR: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  /// Obtiene las noticias de un periódico específico
  ///
  /// [newsPaper] - Identificador del periódico (ej: 'nacional', 'listin', etc.)
  /// [forceRefresh] - Si es true, ignora el cache y hace una nueva petición
  ///
  /// Returns: Lista de noticias
  /// Throws: [NewsServiceException] en caso de error
  Future<List<News>> getNews(
    String newsPaper, {
    bool forceRefresh = false,
  }) async {
    try {
      // Validar parámetro
      if (newsPaper.isEmpty) {
        throw NewsServiceException(
          'El parámetro newsPaper no puede estar vacío',
          type: NewsErrorType.invalidParameter,
        );
      }

      // Verificar cache si no se fuerza refresh
      if (!forceRefresh) {
        final cachedNews = _getCachedNews(newsPaper);
        if (cachedNews != null) {
          log('📦 Usando noticias en cache para: $newsPaper');
          return cachedNews;
        }
      }

      // Hacer petición a la API
      log('🔄 Obteniendo noticias de: $newsPaper');
      final response = await _dio.get('/$newsPaper');

      // Validar respuesta
      if (response.data == null) {
        throw NewsServiceException(
          'La respuesta del servidor está vacía',
          type: NewsErrorType.emptyResponse,
        );
      }

      // Extraer datos
      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw NewsServiceException(
          'Formato de respuesta inválido',
          type: NewsErrorType.invalidFormat,
        );
      }

      final List<dynamic>? jsonResponse = data['data'];

      if (jsonResponse == null) {
        throw NewsServiceException(
          'No se encontró el campo "data" en la respuesta',
          type: NewsErrorType.invalidFormat,
        );
      }

      if (jsonResponse.isEmpty) {
        log('⚠️ No hay noticias disponibles para: $newsPaper');
        return [];
      }

      // Parsear noticias
      final List<News> news = [];
      for (var item in jsonResponse) {
        try {
          news.add(News.fromJson(item));
        } catch (e) {
          log('⚠️ Error al parsear noticia individual: $e');
          // Continuar con las demás noticias
        }
      }

      // Guardar en cache
      _cacheNews(newsPaper, news);

      log('✅ ${news.length} noticias obtenidas para: $newsPaper');
      return news;
    } on DioException catch (e) {
      // Manejar errores específicos de Dio
      throw _handleDioError(e);
    } catch (e) {
      // Otros errores
      log('❌ Error inesperado: $e');
      throw NewsServiceException(
        'Error inesperado al obtener noticias: $e',
        type: NewsErrorType.unknown,
      );
    }
  }

  /// Limpia el cache de noticias
  void clearCache() {
    _cache.clear();
    log('🗑️ Cache limpiado');
  }

  /// Limpia el cache de un periódico específico
  void clearCacheFor(String newsPaper) {
    _cache.remove(newsPaper);
    log('🗑️ Cache limpiado para: $newsPaper');
  }

  /// Obtiene noticias del cache si están disponibles y no han expirado
  List<News>? _getCachedNews(String newsPaper) {
    final cached = _cache[newsPaper];

    if (cached == null) return null;

    final now = DateTime.now();
    final age = now.difference(cached.timestamp);

    if (age > _cacheDuration) {
      _cache.remove(newsPaper);
      return null;
    }

    return cached.news;
  }

  /// Guarda noticias en el cache
  void _cacheNews(String newsPaper, List<News> news) {
    _cache[newsPaper] = _CachedNews(
      news: news,
      timestamp: DateTime.now(),
    );
  }

  /// Maneja errores de Dio y los convierte en NewsServiceException
  NewsServiceException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NewsServiceException(
          'Tiempo de espera agotado. Verifica tu conexión a internet.',
          type: NewsErrorType.timeout,
          originalError: error,
        );

      case DioExceptionType.connectionError:
        return NewsServiceException(
          'No se pudo conectar al servidor. Verifica tu conexión a internet.',
          type: NewsErrorType.noConnection,
          originalError: error,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        String message = 'Error del servidor';

        if (statusCode == 404) {
          message = 'Periódico no encontrado';
        } else if (statusCode == 500) {
          message = 'Error interno del servidor';
        } else if (statusCode == 503) {
          message = 'Servicio no disponible temporalmente';
        }

        return NewsServiceException(
          message,
          type: NewsErrorType.serverError,
          statusCode: statusCode,
          originalError: error,
        );

      case DioExceptionType.cancel:
        return NewsServiceException(
          'Petición cancelada',
          type: NewsErrorType.cancelled,
          originalError: error,
        );

      default:
        return NewsServiceException(
          'Error de red: ${error.message}',
          type: NewsErrorType.unknown,
          originalError: error,
        );
    }
  }
}

/// Clase para almacenar noticias en cache con timestamp
class _CachedNews {
  final List<News> news;
  final DateTime timestamp;

  _CachedNews({
    required this.news,
    required this.timestamp,
  });
}

/// Excepción personalizada para errores del servicio de noticias
class NewsServiceException implements Exception {
  final String message;
  final NewsErrorType type;
  final int? statusCode;
  final dynamic originalError;

  NewsServiceException(
    this.message, {
    required this.type,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'NewsServiceException: $message';

  /// Obtiene un mensaje amigable para el usuario
  String get userMessage {
    switch (type) {
      case NewsErrorType.timeout:
        return 'La conexión está tardando mucho. Intenta de nuevo.';
      case NewsErrorType.noConnection:
        return 'Sin conexión a internet. Verifica tu conexión.';
      case NewsErrorType.serverError:
        return 'El servidor está teniendo problemas. Intenta más tarde.';
      case NewsErrorType.invalidFormat:
        return 'Error al procesar las noticias.';
      case NewsErrorType.emptyResponse:
        return 'No hay noticias disponibles en este momento.';
      case NewsErrorType.invalidParameter:
      case NewsErrorType.cancelled:
      case NewsErrorType.unknown:
        return 'Ocurrió un error. Intenta de nuevo.';
    }
  }
}

/// Tipos de errores que puede lanzar el servicio
enum NewsErrorType {
  timeout,
  noConnection,
  serverError,
  invalidFormat,
  emptyResponse,
  invalidParameter,
  cancelled,
  unknown,
}

// Función legacy para mantener compatibilidad
Future<List<News>> getNews(String newsPaper) async {
  final service = NewsService();
  service.initialize();
  return service.getNews(newsPaper);
}
