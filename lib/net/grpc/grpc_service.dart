/// Dart implementation of the gRPC helloworld.Greeter client.
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:huaroad/global.dart';
import 'package:huaroad/net/env/gateway.dart';
import 'package:huaroad/protos/message.pbgrpc.dart';
import 'package:protobuf/protobuf.dart';

/// CHANGE TO IP ADDRESS OF YOUR SERVER IF IT IS NECESSARY
final serverIP = GateWay.grpc;
const serverPort = 20002;

///协议号+协议体长度用两个字节表示
const int protoLen = 2;

///协议号长度
const int protoIdLen = 2;

/// 协议对应的appId长度
const int appIdLen = 1;

/// 协议对应的appId
const int appId = 2;

typedef OnReceive = void Function(int protoId, List<int> data);

/// ChatService client implementation
class GrpcService {
  static GrpcService? _instance;

//单例方法
  factory GrpcService() => _instance ?? GrpcService._internal();

  GrpcService._internal() {
    // 初始化
    _instance = this;
  }

  /// gRPC client channel to send messages to the server
  ClientChannel? _client;

  OnReceive? _grpcListener;

  VoidCallback? _onErrorHandler;

  /// 状态监听
  void addGrpcListener(OnReceive listener, {VoidCallback? onErrorHandler}) {
    _grpcListener = listener;
    if (onErrorHandler != null) {
      _onErrorHandler = onErrorHandler;
    }
  }

  // Shutdown client
  Future<void> shutdown() async {
    _client?.shutdown();
    _client = null;
  }

  /// Send message to the server
  void send(int protoId, [GeneratedMessage? body]) {
    _client ??= ClientChannel(
      serverIP, // Your IP here or localhost
      port: serverPort,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
        idleTimeout: Duration(seconds: 10),
      ),
    );

    var baseMessage = BaseMessageReq.create();
    baseMessage.message = _packagetData(protoId, body);

    var stream = BattleHandlerClient(_client!,
            options: CallOptions(metadata: {'Authorization': Global.getUserInfo()?.token ?? '1'}))
        .battleHandler(Stream.value(baseMessage));

    stream.forEach((msg) {
      _onReceivedSuccess(msg);
    }).then<void>((_) {
      // raise exception to start listening again
      throw Exception("stream from the server has been closed");
    }).catchError((e, stackTrace) {
      // invalidate current client
      shutdown();
      // call for error handler
      _onError(e.toString());
      // start listening again
      Future.delayed(const Duration(seconds: 10), () {
        send(protoId, body);
      });
    });
  }

  List<int> _packagetData(int protoId, [GeneratedMessage? body]) {
    //序列化pb对象
    Uint8List? pbBody;
    // 消息内容
    int bodyLength = 0;
    if (body != null) {
      pbBody = body.writeToBuffer();
      bodyLength = pbBody.length;
    }

    // 协议字段
    ByteData header = ByteData(7);
    header.setUint16(0, protoLen + appIdLen + protoIdLen + bodyLength);
    header.setUint8(2, appId);
    header.setUint16(3, protoIdLen + bodyLength);
    header.setUint16(5, protoId);

    //包头+pb组合成一个完整的数据包
    var msg = pbBody == null
        ? header.buffer.asUint8List()
        : header.buffer.asUint8List() + pbBody.buffer.asUint8List();
    return msg;
  }

  void _onReceivedSuccess(BaseMessageRes message) {
    debugPrint("received message from the server: $message");
    _parseData(message.data as Uint8List);
  }

  void _parseData(Uint8List message) {
    Uint8List id = message.sublist(6, 8); // 截取协议号
    int protoId = ByteData.view(id.buffer).getUint16(0); // 获取到协议号值

    Uint8List protolength = message.sublist(4, 6);
    int bodylength = ByteData.view(protolength.buffer).getUint16(0) - protoIdLen;
    var data = message.sublist(8, 8 + bodylength); //body数据

    if (_grpcListener != null) {
      _grpcListener!(protoId, data);
    }
  }

  /// 'failed to receive messages' event
  void _onError(String error) {
    debugPrint("error from the server: $error");
    if (_onErrorHandler != null) {
      _onErrorHandler!();
    }
  }
}
