import 'package:huaroad/net/env/env_config.dart';

class GateWay {
  static String get bt => _btGateWay();

  static String get battle => _battleGateWay();

  static String get im => _imGateWay();

  static String get grpc => _grpcGateWay();

  static String get sns => _snsGateWay();

  static String _snsGateWay() {
    String gateWay = 'https://test-ts.cube.ganrobot.com/api/v2';
    switch (EnvConfig.env) {
      case Env.dev:
        gateWay = 'https://test-ts.cube.ganrobot.com/api/v2';
        break;
      case Env.test:
        gateWay = 'https://test-ts.cube.ganrobot.com/api/v2';
        break;
      case Env.uat:
        gateWay = 'http://uat-sns.ganrobot.com/api/v2';
        break;
      case Env.prod:
        gateWay = 'http://prod-sns.ganrobot.com/api/v2';
        break;
      case Env.ggprod:
        gateWay = 'http://ggprod-sns.ganrobot.com/api/v2';
        break;
      default:
    }
    return gateWay;
  }

  static String _btGateWay() {
    String gateWay = 'http://dev-api.ganrobot.com/bt/';
    switch (EnvConfig.env) {
      case Env.dev:
        gateWay = 'http://dev-api.ganrobot.com/bt/';
        break;
      case Env.test:
        gateWay = 'http://test-api.ganrobot.com/bt/';
        break;
      case Env.uat:
        gateWay = 'https://uat-api.ganrobot.com/bt/';
        break;
      case Env.prod:
        gateWay = 'https://prod-api.ganrobot.com/bt/';
        break;
      case Env.ggprod:
        gateWay = 'https://ggprod-api.ganrobot.com/bt/';
        break;
      default:
    }
    return gateWay;
  }

  static String _battleGateWay() {
    String gateWay = 'http://dev-api.ganrobot.com/battle';
    switch (EnvConfig.env) {
      case Env.dev:
        gateWay = 'http://dev-api.ganrobot.com/battle';
        break;
      case Env.test:
        gateWay = 'http://test-api.ganrobot.com/battle';
        break;
      case Env.uat:
        gateWay = 'https://uat-api.ganrobot.com/battle';
        break;
      case Env.prod:
        gateWay = 'https://prod-api.ganrobot.com/battle';
        break;
      case Env.ggprod:
        gateWay = 'https://ggprod-api.ganrobot.com/battle';
        break;
      default:
    }
    return gateWay;
  }

  static String _imGateWay() {
    String gateWay = 'http://dev-api.ganrobot.com/im';
    switch (EnvConfig.env) {
      case Env.dev:
        gateWay = 'http://dev-api.ganrobot.com/im';
        break;
      case Env.test:
        gateWay = 'http://test-api.ganrobot.com/im';
        break;
      case Env.uat:
        gateWay = 'https://uat-api.ganrobot.com/im';
        break;
      case Env.prod:
        gateWay = 'https://prod-api.ganrobot.com/im';
        break;
      case Env.ggprod:
        gateWay = 'https://ggprod-api.ganrobot.com/im';
        break;
      default:
    }
    return gateWay;
  }

  static String _grpcGateWay() {
    String gateWay = '192.168.30.236';
    switch (EnvConfig.env) {
      case Env.dev:
        gateWay = '192.168.30.236';
        break;
      case Env.test:
        gateWay = '192.168.30.237';
        break;
      case Env.uat:
        gateWay = 'uat-api.ganrobot.com';
        break;
      case Env.prod:
        gateWay = 'prod-api.ganrobot.com';
        break;
      case Env.ggprod:
        gateWay = 'ggprod-api.ganrobot.com';
        break;

      default:
    }
    return gateWay;
  }

  static Env getCurrentEnv(String env) {
    switch (env) {
      case 'dev':
        return Env.dev;
      case 'test':
        return Env.test;
      case 'uat':
        return Env.uat;
      case 'prod':
        return Env.prod;
      case 'ggprod':
        return Env.ggprod;
      default:
        return Env.dev;
    }
  }
}
