import 'package:dio/dio.dart';
import 'package:huaroad/util/logger.dart';

class DioCustomLogInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);

    LogUtil.d("${options.uri} \n${options.method} \n${options.data}");
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);

    LogUtil.d("${response.realUri} \n${response.data}");
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }
}
