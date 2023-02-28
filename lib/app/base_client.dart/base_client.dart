import 'package:dio/dio.dart';
import 'package:reminder/app/endpoints/api_endpoints.dart';

class BaseClient{
   late final Dio _dio = _createDio();
  Dio get dio => _dio;
  Dio _createDio() {
    Dio dio = Dio();
    dio.options = BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      contentType: 'application/json',
      responseType: ResponseType.json,
    );
    // dio.interceptors.addAll([ErrorInterceptor()]);
    return dio;
  }
}