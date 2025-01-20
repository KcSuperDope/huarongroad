///
//  Generated code. Do not modify.
//  source: message.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'message.pb.dart' as $0;
export 'message.pb.dart';

class BaseHandlerClient extends $grpc.Client {
  static final _$baseHandler =
      $grpc.ClientMethod<$0.BaseMessageReq, $0.BaseMessageRes>(
          '/message.BaseHandler/baseHandler',
          ($0.BaseMessageReq value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.BaseMessageRes.fromBuffer(value));

  BaseHandlerClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseStream<$0.BaseMessageRes> baseHandler(
      $async.Stream<$0.BaseMessageReq> request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$baseHandler, request, options: options);
  }
}

abstract class BaseHandlerServiceBase extends $grpc.Service {
  $core.String get $name => 'message.BaseHandler';

  BaseHandlerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.BaseMessageReq, $0.BaseMessageRes>(
        'baseHandler',
        baseHandler,
        true,
        true,
        ($core.List<$core.int> value) => $0.BaseMessageReq.fromBuffer(value),
        ($0.BaseMessageRes value) => value.writeToBuffer()));
  }

  $async.Stream<$0.BaseMessageRes> baseHandler(
      $grpc.ServiceCall call, $async.Stream<$0.BaseMessageReq> request);
}

class BattleHandlerClient extends $grpc.Client {
  static final _$battleHandler =
      $grpc.ClientMethod<$0.BaseMessageReq, $0.BaseMessageRes>(
          '/message.BattleHandler/battleHandler',
          ($0.BaseMessageReq value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.BaseMessageRes.fromBuffer(value));

  BattleHandlerClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseStream<$0.BaseMessageRes> battleHandler(
      $async.Stream<$0.BaseMessageReq> request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$battleHandler, request, options: options);
  }
}

abstract class BattleHandlerServiceBase extends $grpc.Service {
  $core.String get $name => 'message.BattleHandler';

  BattleHandlerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.BaseMessageReq, $0.BaseMessageRes>(
        'battleHandler',
        battleHandler,
        true,
        true,
        ($core.List<$core.int> value) => $0.BaseMessageReq.fromBuffer(value),
        ($0.BaseMessageRes value) => value.writeToBuffer()));
  }

  $async.Stream<$0.BaseMessageRes> battleHandler(
      $grpc.ServiceCall call, $async.Stream<$0.BaseMessageReq> request);
}
