import 'package:dio/dio.dart';
import 'package:huaroad/global.dart';
import 'package:huaroad/plugin/model/header.dart';
import 'package:huaroad/plugin/native_flutter_plugin.dart';
import 'package:huaroad/util/time_util.dart';

class DioInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 对非open的接口的请求参数全部增加userId
    // if (!options.path.contains("open")) {
    //   options.queryParameters["userId"] = "xxx";
    // }
    //
    // // 头部添加token
    Header headers = Global.header;
    headers.clientEventTime = TimeUtil.currentTimeMillis();
    headers.networkType = await NativeFlutterPlugin.instance.getNetworkType();
    options.headers = headers.toJson();
    // print('options.headers=${options.headers}');
    //
    // // 更多业务需求
    //
    // handler.next(options);

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // // 请求成功是对数据做基本处理
    if (response.statusCode == 200) {
    } else {}

    // // 对某些单独的url返回数据做特殊处理
    // if (response.requestOptions.baseUrl.contains("???????")) {
    //   //....
    // }

    // // 根据公司的业务需求进行定制化处理

    // // 重点
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    super.onError(err, handler);

    switch (err.type) {
      // 连接服务器超时
      case DioExceptionType.connectionTimeout:
        {
          // 根据自己的业务需求来设定该如何操作,可以是弹出框提示/或者做一些路由跳转处理
        }
        break;
      // 响应超时
      case DioExceptionType.receiveTimeout:
        {
          // 根据自己的业务需求来设定该如何操作,可以是弹出框提示/或者做一些路由跳转处理
        }
        break;
      // 发送超时
      case DioExceptionType.sendTimeout:
        {
          // 根据自己的业务需求来设定该如何操作,可以是弹出框提示/或者做一些路由跳转处理
        }
        break;
      // 请求取消
      case DioExceptionType.cancel:
        {
          // 根据自己的业务需求来设定该如何操作,可以是弹出框提示/或者做一些路由跳转处理
        }
        break;
      // 404/503错误
      case DioExceptionType.badResponse:
        {
          // 根据自己的业务需求来设定该如何操作,可以是弹出框提示/或者做一些路由跳转处理
        }
        break;
      // other 其他错误类型
      case DioExceptionType.unknown:
        {}
        break;
      case DioExceptionType.badCertificate:
        // TODO: Handle this case.
        break;
      case DioExceptionType.connectionError:
        // TODO: Handle this case.
        break;
    }
  }
}
