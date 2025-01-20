import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:huaroad/net/env/gateway.dart';
import 'package:huaroad/net/http/dio_log_interceptors.dart';
import 'package:huaroad/net/http/dio_method.dart';
import 'package:huaroad/net/http/dio_transformer.dart';

import 'dio_cache_interceptors.dart';
import 'dio_interceptors.dart';

class DioUtil {
  /// 连接超时时间
  static const int CONNECT_TIMEOUT = 6 * 1000;

  /// 响应超时时间
  static const int RECEIVE_TIMEOUT = 6 * 1000;

  /// 请求的URL前缀
  static String BASE_URL = GateWay.bt;

  /// 是否开启网络缓存,默认false
  static bool CACHE_ENABLE = false;

  /// 最大缓存时间(按秒), 默认缓存七天,可自行调节
  static int MAX_CACHE_AGE = 7 * 24 * 60 * 60;

  /// 最大缓存条数(默认一百条)
  static int MAX_CACHE_COUNT = 100;

  /// 本地代理IP地址
  static String proxyAddress = '192.168.73.96';

  /// 是否开启抓包代理
  static bool enable = false;

  static DioUtil? _instance;
  static Dio _dio = Dio();

  Dio get dio => _dio;

  DioUtil._internal() {
    _instance = this;
    _instance!._init();
  }

  factory DioUtil() => _instance ?? DioUtil._internal();

  static DioUtil? getInstance() {
    _instance ?? DioUtil._internal();
    return _instance;
  }

  /// 取消请求token
  final CancelToken _cancelToken = CancelToken();

  _init() {
    /// 初始化基本选项
    BaseOptions options = BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: const Duration(milliseconds: CONNECT_TIMEOUT),
      receiveTimeout: const Duration(milliseconds: RECEIVE_TIMEOUT),
    );

    /// 初始化dio
    _dio = Dio(options);

    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      HttpClient dioClient = HttpClient();
      dioClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    /// 添加拦截器
    _dio.interceptors.add(DioInterceptors());

    /// 添加转换器
    _dio.transformer = DioTransformer();

    /// 刷新token拦截器(lock/unlock)
    // _dio.interceptors.add(DioTokenInterceptors());

    /// 添加缓存拦截器
    _dio.interceptors.add(DioCacheInterceptors());

    /// 自定义日志
    _dio.interceptors.add(DioCustomLogInterceptors());

    setProxy(proxyAddress: proxyAddress, enable: enable);
  }

  /// 设置Http代理(设置即开启)
  void setProxy({String? proxyAddress, bool enable = false}) {
    if (enable) {
      // _dio.httpClientAdapter.DefaultHttpClientAdapter= (HttpClient client) {
      //   client.findProxy = (uri) {
      //     return proxyAddress ?? "";
      //   };
      //   client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      // };
      dio.httpClientAdapter = IOHttpClientAdapter()
        ..onHttpClientCreate = (client) {
          // Config the client.
          client.findProxy = (uri) {
            // Forward all request to proxy "localhost:8888".
            return 'PROXY $proxyAddress:8888';
          };
          // You can also create a new HttpClient for Dio instead of returning,
          // but a client must being returned here.
          return client;
        };
    }
  }

  /// 设置https证书校验
  // void setHttpsCertificateVerification({String? pem, bool enable = false}) {
  //   if (enable) {
  //     (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
  //       client.badCertificateCallback = (X509Certificate cert, String host, int port) {
  //         if (cert.pem == pem) {
  //           // 验证证书
  //           return true;
  //         }
  //         return false;
  //       };
  //     };
  //   }
  // }

  /// 请求类
  Future<T> request<T>(
    String path, {
    DioMethod method = DioMethod.get,
    Map<String, dynamic>? params,
    data,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    const methodValues = {
      DioMethod.get: 'get',
      DioMethod.post: 'post',
      DioMethod.put: 'put',
      DioMethod.delete: 'delete',
      DioMethod.patch: 'patch',
      DioMethod.head: 'head'
    };

    options ??= Options(method: methodValues[method]);
    try {
      Response response;
      response = await _dio.request(
        path,
        data: data,
        queryParameters: params,
        cancelToken: cancelToken ?? _cancelToken,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<T> post<T>(
    String path, {
    Map<String, dynamic>? params,
    data,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    options ??= Options(method: "post");
    try {
      Response response;
      response = await _dio.request(
        path,
        data: data,
        queryParameters: params,
        cancelToken: cancelToken ?? _cancelToken,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? params,
    data,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    options ??= Options(method: "get");
    try {
      Response response;
      response = await _dio.request(
        path,
        data: data,
        queryParameters: params,
        cancelToken: cancelToken ?? _cancelToken,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// 取消网络请求
  void cancelRequests({CancelToken? token}) {
    token ?? _cancelToken.cancel("cancelled");
  }
}
