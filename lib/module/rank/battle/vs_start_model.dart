import 'package:huaroad/plugin/model/user.dart';

class VsStartModel {
  int? battleType;
  User? myInfo;
  User? rivalInfo;
  int? battleId;
  String? putData;
  bool? owner;
  bool? inviteSuccess;
  bool? connectDevice;
  int? level;

  VsStartModel(
      {this.battleType,
      this.battleId,
      this.putData,
      this.myInfo,
      this.rivalInfo,
      this.owner = true,
      this.inviteSuccess = false,
      this.connectDevice,
      this.level});
}
