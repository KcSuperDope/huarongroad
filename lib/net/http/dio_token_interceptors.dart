import 'package:dio/dio.dart';

class DioTokenInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.headers['refreshToken'] == null) {
      // DioUtil.getInstance()?.dio.lock();
      Dio tokenDio = Dio();
      tokenDio.get("http://localhost:8080/getRefreshToken").then((d) {
        options.headers['refreshToken'] = d;
        handler.next(options);
      }).catchError((error, stackTrace) {
        handler.reject(error, true);
      }).whenComplete(() {
        // DioUtil.getInstance()?.dio.unlock();
      }); // unlock the dio
    } else {
      options.headers['refreshToken'] = options.headers['refreshToken'];
      handler.next(options);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // 响应前需要做刷新token的操作

    super.onResponse(response, handler);
  }

}
