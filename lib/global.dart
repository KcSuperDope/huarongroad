import 'package:huaroad/plugin/model/header.dart';
import 'package:huaroad/plugin/model/user.dart';

class Global {
  static bool get isLogin => getUserInfo() != null;
  static User? _userInfo;

  static String get userId => _userInfo?.userId ?? '-1';

  static String get userAvatar => _userInfo?.avatar ?? '';

  static String get userNickName => _userInfo?.nickName ?? 'wiSlide';

  static Header? _header;

  static Header get header => _header ?? Header();

  static User? getUserInfo() {
    try {
      if (_userInfo != null) {
        return _userInfo;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static set setUserInfo(User user) => _userInfo = user;

  static set setHeader(Header head) => _header = head;
}
