// // import 'dart:developer';

// // import 'package:dio/dio.dart';
// // import 'package:rd_loca_news/details/models/details_model.dart';

// // Future<Detail> getDetailsOfNew(String url) async {
// //   final dio = Dio();

// //   var apiUrl = 'https://api-scrapping-news-rd.onrender.com/api/details';
// //   final body = {"url": url};
// //   try {
// //     final response = await dio.post(apiUrl, data: body);

// //     final jsonResponse = Detail.fromJson(response.data["data"]);
// //     log('$jsonResponse');
// //     return jsonResponse;
// //   } catch (e) {
// //     log('$e');
// //     rethrow;
// //   }
// // }

// import 'dart:developer';
// import 'package:dio/dio.dart';
// import 'package:rd_loca_news/details/models/details_model.dart';

// class DetailsService {
//   // Singleton pattern
//   static final DetailsService _instance = DetailsService._internal();
//   factory DetailsService() => _instance;
//   DetailsService._internal();

//   // Instancia única de Dio con configuración
//   late final Dio _dio;

//   // Configuración de la API
//   static const String _baseUrl =
//       'https://api-scrapping-news-rd.onrender.com/api';
//   static const Duration _timeout =
//       Duration(seconds: 45); // Más tiempo para scraping
//   static const Duration _cacheDuration =
//       Duration(minutes: 30); // Cache más largo

//   // Cache simple en memoria
//   final Map<String, _CachedDetail> _cache = {};

//   void initialize() {
//     _dio = Dio(
//       BaseOptions(
//         baseUrl: _baseUrl,
//         connectTimeout: _timeout,
//         receiveTimeout: _timeout,
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         validateStatus: (status) {
//           return status != null && status < 400;
//         },
//       ),
//     );

//     // Interceptor para logs
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           log('🌐 DETAILS REQUEST: ${options.method} ${options.path}');
//           return handler.next(options);
//         },
//         onResponse: (response, handler) {
//           log('✅ DETAILS RESPONSE: ${response.statusCode}');
//           return handler.next(response);
//         },
//         onError: (error, handler) {
//           log('❌ DETAILS ERROR: ${error.message}');
//           return handler.next(error);
//         },
//       ),
//     );
//   }

//   /// Obtiene los detalles completos de una noticia
//   ///
//   /// [url] - URL de la noticia
//   /// [forceRefresh] - Si es true, ignora el cache
//   ///
//   /// Returns: Detalles de la noticia
//   /// Throws: [DetailsServiceException] en caso de error
//   Future<Detail> getDetailsOfNew(
//     String url, {
//     bool forceRefresh = false,
//   }) async {
//     try {
//       // Validar URL
//       if (url.isEmpty) {
//         throw DetailsServiceException(
//           'La URL no puede estar vacía',
//           type: DetailsErrorType.invalidParameter,
//         );
//       }

//       if (!_isValidUrl(url)) {
//         throw DetailsServiceException(
//           'URL inválida',
//           type: DetailsErrorType.invalidParameter,
//         );
//       }

//       // Verificar cache si no se fuerza refresh
//       if (!forceRefresh) {
//         final cachedDetail = _getCachedDetail(url);
//         if (cachedDetail != null) {
//           log('📦 Usando detalles en cache para: $url');
//           return cachedDetail;
//         }
//       }

//       // Hacer petición a la API
//       log('🔄 Obteniendo detalles de: $url');

//       final body = {'url': url};
//       final response = await _dio.post(
//         '/details',
//         data: body,
//       );

//       // Validar respuesta
//       if (response.data == null) {
//         throw DetailsServiceException(
//           'La respuesta del servidor está vacía',
//           type: DetailsErrorType.emptyResponse,
//         );
//       }

//       final data = response.data;

//       if (data is! Map<String, dynamic>) {
//         throw DetailsServiceException(
//           'Formato de respuesta inválido',
//           type: DetailsErrorType.invalidFormat,
//         );
//       }

//       final detailData = data['data'];

//       if (detailData == null) {
//         throw DetailsServiceException(
//           'No se encontró el campo "data" en la respuesta',
//           type: DetailsErrorType.invalidFormat,
//         );
//       }

//       // Parsear detalles
//       Detail detail;
//       try {
//         detail = Detail.fromJson(detailData);
//       } catch (e) {
//         log('❌ Error al parsear detalles: $e');
//         throw DetailsServiceException(
//           'Error al procesar los detalles de la noticia',
//           type: DetailsErrorType.parseError,
//           originalError: e,
//         );
//       }

//       // Guardar en cache
//       _cacheDetail(url, detail);

//       log('✅ Detalles obtenidos exitosamente');
//       return detail;
//     } on DioException catch (e) {
//       throw _handleDioError(e, url);
//     } on DetailsServiceException {
//       rethrow;
//     } catch (e) {
//       log('❌ Error inesperado: $e');
//       throw DetailsServiceException(
//         'Error inesperado al obtener detalles: $e',
//         type: DetailsErrorType.unknown,
//         originalError: e,
//       );
//     }
//   }

//   /// Precarga detalles de varias noticias (útil para optimización)
//   Future<void> preloadDetails(List<String> urls) async {
//     log('🔄 Precargando ${urls.length} detalles...');

//     final futures = urls.map((url) async {
//       try {
//         await getDetailsOfNew(url);
//       } catch (e) {
//         log('⚠️ Error al precargar: $url');
//       }
//     });

//     await Future.wait(futures);
//     log('✅ Precarga completada');
//   }

//   /// Limpia el cache de detalles
//   void clearCache() {
//     _cache.clear();
//     log('🗑️ Cache de detalles limpiado');
//   }

//   /// Limpia el cache de una URL específica
//   void clearCacheFor(String url) {
//     _cache.remove(url);
//     log('🗑️ Cache limpiado para: $url');
//   }

//   /// Obtiene detalles del cache si están disponibles y no han expirado
//   Detail? _getCachedDetail(String url) {
//     final cached = _cache[url];

//     if (cached == null) return null;

//     final now = DateTime.now();
//     final age = now.difference(cached.timestamp);

//     if (age > _cacheDuration) {
//       _cache.remove(url);
//       return null;
//     }

//     return cached.detail;
//   }

//   /// Guarda detalles en el cache
//   void _cacheDetail(String url, Detail detail) {
//     _cache[url] = _CachedDetail(
//       detail: detail,
//       timestamp: DateTime.now(),
//     );
//   }

//   /// Valida si una URL tiene un formato válido
//   bool _isValidUrl(String url) {
//     try {
//       final uri = Uri.parse(url);
//       return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
//     } catch (e) {
//       return false;
//     }
//   }

//   /// Maneja errores de Dio y los convierte en DetailsServiceException
//   DetailsServiceException _handleDioError(DioException error, String url) {
//     switch (error.type) {
//       case DioExceptionType.connectionTimeout:
//       case DioExceptionType.sendTimeout:
//       case DioExceptionType.receiveTimeout:
//         return DetailsServiceException(
//           'La carga está tardando mucho. El servidor puede estar procesando la noticia.',
//           type: DetailsErrorType.timeout,
//           url: url,
//           originalError: error,
//         );

//       case DioExceptionType.connectionError:
//         return DetailsServiceException(
//           'No se pudo conectar al servidor. Verifica tu conexión a internet.',
//           type: DetailsErrorType.noConnection,
//           url: url,
//           originalError: error,
//         );

//       case DioExceptionType.badResponse:
//         final statusCode = error.response?.statusCode;
//         String message = 'Error del servidor';

//         if (statusCode == 404) {
//           message = 'La noticia no fue encontrada';
//         } else if (statusCode == 400) {
//           message = 'URL de noticia inválida';
//         } else if (statusCode == 500) {
//           message = 'Error al procesar la noticia en el servidor';
//         } else if (statusCode == 503) {
//           message = 'El servicio no está disponible temporalmente';
//         }

//         return DetailsServiceException(
//           message,
//           type: DetailsErrorType.serverError,
//           statusCode: statusCode,
//           url: url,
//           originalError: error,
//         );

//       case DioExceptionType.cancel:
//         return DetailsServiceException(
//           'Petición cancelada',
//           type: DetailsErrorType.cancelled,
//           url: url,
//           originalError: error,
//         );

//       default:
//         return DetailsServiceException(
//           'Error de red: ${error.message}',
//           type: DetailsErrorType.unknown,
//           url: url,
//           originalError: error,
//         );
//     }
//   }

//   /// Obtiene estadísticas del cache
//   Map<String, dynamic> getCacheStats() {
//     final now = DateTime.now();
//     int validItems = 0;
//     int expiredItems = 0;

//     for (var entry in _cache.entries) {
//       final age = now.difference(entry.value.timestamp);
//       if (age > _cacheDuration) {
//         expiredItems++;
//       } else {
//         validItems++;
//       }
//     }

//     return {
//       'total': _cache.length,
//       'valid': validItems,
//       'expired': expiredItems,
//       'cacheDuration': _cacheDuration.inMinutes,
//     };
//   }
// }

// /// Clase para almacenar detalles en cache con timestamp
// class _CachedDetail {
//   final Detail detail;
//   final DateTime timestamp;

//   _CachedDetail({
//     required this.detail,
//     required this.timestamp,
//   });
// }

// /// Excepción personalizada para errores del servicio de detalles
// class DetailsServiceException implements Exception {
//   final String message;
//   final DetailsErrorType type;
//   final int? statusCode;
//   final String? url;
//   final dynamic originalError;

//   DetailsServiceException(
//     this.message, {
//     required this.type,
//     this.statusCode,
//     this.url,
//     this.originalError,
//   });

//   @override
//   String toString() => 'DetailsServiceException: $message';

//   /// Obtiene un mensaje amigable para el usuario
//   String get userMessage {
//     switch (type) {
//       case DetailsErrorType.timeout:
//         return 'La noticia está tardando en cargar. Intenta de nuevo en unos momentos.';
//       case DetailsErrorType.noConnection:
//         return 'Sin conexión a internet. Verifica tu conexión.';
//       case DetailsErrorType.serverError:
//         return 'Error al cargar la noticia. Intenta más tarde.';
//       case DetailsErrorType.invalidFormat:
//       case DetailsErrorType.parseError:
//         return 'Error al procesar la noticia.';
//       case DetailsErrorType.emptyResponse:
//         return 'La noticia no tiene contenido disponible.';
//       case DetailsErrorType.invalidParameter:
//         return 'URL de noticia inválida.';
//       case DetailsErrorType.cancelled:
//         return 'Carga cancelada.';
//       case DetailsErrorType.unknown:
//         return 'Ocurrió un error al cargar la noticia. Intenta de nuevo.';
//     }
//   }

//   /// Indica si el error es recuperable (puede reintentar)
//   bool get isRetryable {
//     return type == DetailsErrorType.timeout ||
//         type == DetailsErrorType.noConnection ||
//         type == DetailsErrorType.serverError;
//   }
// }

// /// Tipos de errores que puede lanzar el servicio
// enum DetailsErrorType {
//   timeout,
//   noConnection,
//   serverError,
//   invalidFormat,
//   parseError,
//   emptyResponse,
//   invalidParameter,
//   cancelled,
//   unknown,
// }

// // Función legacy para mantener compatibilidad
// Future<Detail> getDetailsOfNew(String url) async {
//   final service = DetailsService();
//   service.initialize();
//   return service.getDetailsOfNew(url);
// }
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
      final response = await _dio.post('/details', data: {'url': url});
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
        detail = Detail.fromJson(data['data']);
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
    } catch (_) {
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
