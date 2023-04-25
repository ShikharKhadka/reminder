import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:reminder/app/data/app_path_provider.dart';
import 'package:reminder/app/endpoints/api_endpoints.dart';

class BaseClient {
  late final Dio _dio = _createDio();
  Dio get dio => _dio;
  Dio _createDio() {
    Dio dio = Dio();
    dio.options = BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      contentType: 'application/json',
      responseType: ResponseType.json,
    );
    dio.interceptors.addAll(
      [
        DioCacheInterceptor(
          options: CacheOptions(
            store: HiveCacheStore(AppPathProvider.path),
            policy: CachePolicy.forceCache,
            hitCacheOnErrorExcept: [401, 403],
            maxStale: const Duration(days: 7),
            priority: CachePriority.high,
            cipher: null,
            keyBuilder: CacheOptions.defaultCacheKeyBuilder,
            allowPostMethod: false,
          ),
        ),
        PrettyDioLogger(error: true, requestBody: true, responseBody: true)
      ],
    );
    return dio;
  }
}
