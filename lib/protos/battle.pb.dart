///
//  Generated code. Do not modify.
//  source: battle.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class s2c_battle_start extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 's2c_battle_start', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'battle'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'battleId', protoName: 'battleId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'putData', protoName: 'putData')
    ..hasRequiredFields = false
  ;

  s2c_battle_start._() : super();
  factory s2c_battle_start({
    $fixnum.Int64? battleId,
    $core.String? putData,
  }) {
    final _result = create();
    if (battleId != null) {
      _result.battleId = battleId;
    }
    if (putData != null) {
      _result.putData = putData;
    }
    return _result;
  }
  factory s2c_battle_start.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory s2c_battle_start.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  s2c_battle_start clone() => s2c_battle_start()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  s2c_battle_start copyWith(void Function(s2c_battle_start) updates) => super.copyWith((message) => updates(message as s2c_battle_start)) as s2c_battle_start; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static s2c_battle_start create() => s2c_battle_start._();
  s2c_battle_start createEmptyInstance() => create();
  static $pb.PbList<s2c_battle_start> createRepeated() => $pb.PbList<s2c_battle_start>();
  @$core.pragma('dart2js:noInline')
  static s2c_battle_start getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<s2c_battle_start>(create);
  static s2c_battle_start? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get battleId => $_getI64(0);
  @$pb.TagNumber(1)
  set battleId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBattleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBattleId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get putData => $_getSZ(1);
  @$pb.TagNumber(2)
  set putData($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPutData() => $_has(1);
  @$pb.TagNumber(2)
  void clearPutData() => clearField(2);
}

class s2c_battle_status extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 's2c_battle_status', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'battle'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId', protoName: 'userId')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  s2c_battle_status._() : super();
  factory s2c_battle_status({
    $fixnum.Int64? userId,
    $core.int? status,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (status != null) {
      _result.status = status;
    }
    return _result;
  }
  factory s2c_battle_status.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory s2c_battle_status.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  s2c_battle_status clone() => s2c_battle_status()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  s2c_battle_status copyWith(void Function(s2c_battle_status) updates) => super.copyWith((message) => updates(message as s2c_battle_status)) as s2c_battle_status; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static s2c_battle_status create() => s2c_battle_status._();
  s2c_battle_status createEmptyInstance() => create();
  static $pb.PbList<s2c_battle_status> createRepeated() => $pb.PbList<s2c_battle_status>();
  @$core.pragma('dart2js:noInline')
  static s2c_battle_status getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<s2c_battle_status>(create);
  static s2c_battle_status? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get status => $_getIZ(1);
  @$pb.TagNumber(2)
  set status($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);
}

class s2c_battle_countdown extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 's2c_battle_countdown', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'battle'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'second', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  s2c_battle_countdown._() : super();
  factory s2c_battle_countdown({
    $core.int? second,
  }) {
    final _result = create();
    if (second != null) {
      _result.second = second;
    }
    return _result;
  }
  factory s2c_battle_countdown.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory s2c_battle_countdown.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  s2c_battle_countdown clone() => s2c_battle_countdown()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  s2c_battle_countdown copyWith(void Function(s2c_battle_countdown) updates) => super.copyWith((message) => updates(message as s2c_battle_countdown)) as s2c_battle_countdown; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static s2c_battle_countdown create() => s2c_battle_countdown._();
  s2c_battle_countdown createEmptyInstance() => create();
  static $pb.PbList<s2c_battle_countdown> createRepeated() => $pb.PbList<s2c_battle_countdown>();
  @$core.pragma('dart2js:noInline')
  static s2c_battle_countdown getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<s2c_battle_countdown>(create);
  static s2c_battle_countdown? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get second => $_getIZ(0);
  @$pb.TagNumber(1)
  set second($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSecond() => $_has(0);
  @$pb.TagNumber(1)
  void clearSecond() => clearField(1);
}

class s2c_battle_result extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 's2c_battle_result', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'battle'), createEmptyInstance: create)
    ..aOM<msg_player_battle_result>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'blueResult', protoName: 'blueResult', subBuilder: msg_player_battle_result.create)
    ..aOM<msg_player_battle_result>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'redResult', protoName: 'redResult', subBuilder: msg_player_battle_result.create)
    ..hasRequiredFields = false
  ;

  s2c_battle_result._() : super();
  factory s2c_battle_result({
    msg_player_battle_result? blueResult,
    msg_player_battle_result? redResult,
  }) {
    final _result = create();
    if (blueResult != null) {
      _result.blueResult = blueResult;
    }
    if (redResult != null) {
      _result.redResult = redResult;
    }
    return _result;
  }
  factory s2c_battle_result.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory s2c_battle_result.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  s2c_battle_result clone() => s2c_battle_result()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  s2c_battle_result copyWith(void Function(s2c_battle_result) updates) => super.copyWith((message) => updates(message as s2c_battle_result)) as s2c_battle_result; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static s2c_battle_result create() => s2c_battle_result._();
  s2c_battle_result createEmptyInstance() => create();
  static $pb.PbList<s2c_battle_result> createRepeated() => $pb.PbList<s2c_battle_result>();
  @$core.pragma('dart2js:noInline')
  static s2c_battle_result getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<s2c_battle_result>(create);
  static s2c_battle_result? _defaultInstance;

  @$pb.TagNumber(1)
  msg_player_battle_result get blueResult => $_getN(0);
  @$pb.TagNumber(1)
  set blueResult(msg_player_battle_result v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasBlueResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlueResult() => clearField(1);
  @$pb.TagNumber(1)
  msg_player_battle_result ensureBlueResult() => $_ensure(0);

  @$pb.TagNumber(2)
  msg_player_battle_result get redResult => $_getN(1);
  @$pb.TagNumber(2)
  set redResult(msg_player_battle_result v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRedResult() => $_has(1);
  @$pb.TagNumber(2)
  void clearRedResult() => clearField(2);
  @$pb.TagNumber(2)
  msg_player_battle_result ensureRedResult() => $_ensure(1);
}

class s2c_match_suc extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 's2c_match_suc', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'battle'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'roomId', protoName: 'roomId')
    ..aOM<msg_player_face_base>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'face', subBuilder: msg_player_face_base.create)
    ..hasRequiredFields = false
  ;

  s2c_match_suc._() : super();
  factory s2c_match_suc({
    $fixnum.Int64? roomId,
    msg_player_face_base? face,
  }) {
    final _result = create();
    if (roomId != null) {
      _result.roomId = roomId;
    }
    if (face != null) {
      _result.face = face;
    }
    return _result;
  }
  factory s2c_match_suc.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory s2c_match_suc.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  s2c_match_suc clone() => s2c_match_suc()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  s2c_match_suc copyWith(void Function(s2c_match_suc) updates) => super.copyWith((message) => updates(message as s2c_match_suc)) as s2c_match_suc; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static s2c_match_suc create() => s2c_match_suc._();
  s2c_match_suc createEmptyInstance() => create();
  static $pb.PbList<s2c_match_suc> createRepeated() => $pb.PbList<s2c_match_suc>();
  @$core.pragma('dart2js:noInline')
  static s2c_match_suc getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<s2c_match_suc>(create);
  static s2c_match_suc? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get roomId => $_getI64(0);
  @$pb.TagNumber(1)
  set roomId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => clearField(1);

  @$pb.TagNumber(2)
  msg_player_face_base get face => $_getN(1);
  @$pb.TagNumber(2)
  set face(msg_player_face_base v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasFace() => $_has(1);
  @$pb.TagNumber(2)
  void clearFace() => clearField(2);
  @$pb.TagNumber(2)
  msg_player_face_base ensureFace() => $_ensure(1);
}

class s2c_match_exit extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 's2c_match_exit', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'battle'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId', protoName: 'userId')
    ..hasRequiredFields = false
  ;

  s2c_match_exit._() : super();
  factory s2c_match_exit({
    $fixnum.Int64? userId,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    return _result;
  }
  factory s2c_match_exit.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory s2c_match_exit.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  s2c_match_exit clone() => s2c_match_exit()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  s2c_match_exit copyWith(void Function(s2c_match_exit) updates) => super.copyWith((message) => updates(message as s2c_match_exit)) as s2c_match_exit; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static s2c_match_exit create() => s2c_match_exit._();
  s2c_match_exit createEmptyInstance() => create();
  static $pb.PbList<s2c_match_exit> createRepeated() => $pb.PbList<s2c_match_exit>();
  @$core.pragma('dart2js:noInline')
  static s2c_match_exit getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<s2c_match_exit>(create);
  static s2c_match_exit? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);
}

class msg_battle_result extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'msg_battle_result', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'battle'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'result', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time', $pb.PbFieldType.O3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'step', $pb.PbFieldType.O3)
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'reviewId', protoName: 'reviewId')
    ..hasRequiredFields = false
  ;

  msg_battle_result._() : super();
  factory msg_battle_result({
    $core.int? result,
    $core.int? time,
    $core.int? step,
    $fixnum.Int64? reviewId,
  }) {
    final _result = create();
    if (result != null) {
      _result.result = result;
    }
    if (time != null) {
      _result.time = time;
    }
    if (step != null) {
      _result.step = step;
    }
    if (reviewId != null) {
      _result.reviewId = reviewId;
    }
    return _result;
  }
  factory msg_battle_result.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory msg_battle_result.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  msg_battle_result clone() => msg_battle_result()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  msg_battle_result copyWith(void Function(msg_battle_result) updates) => super.copyWith((message) => updates(message as msg_battle_result)) as msg_battle_result; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static msg_battle_result create() => msg_battle_result._();
  msg_battle_result createEmptyInstance() => create();
  static $pb.PbList<msg_battle_result> createRepeated() => $pb.PbList<msg_battle_result>();
  @$core.pragma('dart2js:noInline')
  static msg_battle_result getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<msg_battle_result>(create);
  static msg_battle_result? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get result => $_getIZ(0);
  @$pb.TagNumber(1)
  set result($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get time => $_getIZ(1);
  @$pb.TagNumber(2)
  set time($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearTime() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get step => $_getIZ(2);
  @$pb.TagNumber(3)
  set step($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStep() => $_has(2);
  @$pb.TagNumber(3)
  void clearStep() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get reviewId => $_getI64(3);
  @$pb.TagNumber(4)
  set reviewId($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasReviewId() => $_has(3);
  @$pb.TagNumber(4)
  void clearReviewId() => clearField(4);
}

class msg_player_battle_result extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'msg_player_battle_result', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'battle'), createEmptyInstance: create)
    ..aOM<msg_player_face_base>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'player', subBuilder: msg_player_face_base.create)
    ..aOM<msg_battle_result>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'result', subBuilder: msg_battle_result.create)
    ..hasRequiredFields = false
  ;

  msg_player_battle_result._() : super();
  factory msg_player_battle_result({
    msg_player_face_base? player,
    msg_battle_result? result,
  }) {
    final _result = create();
    if (player != null) {
      _result.player = player;
    }
    if (result != null) {
      _result.result = result;
    }
    return _result;
  }
  factory msg_player_battle_result.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory msg_player_battle_result.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  msg_player_battle_result clone() => msg_player_battle_result()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  msg_player_battle_result copyWith(void Function(msg_player_battle_result) updates) => super.copyWith((message) => updates(message as msg_player_battle_result)) as msg_player_battle_result; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static msg_player_battle_result create() => msg_player_battle_result._();
  msg_player_battle_result createEmptyInstance() => create();
  static $pb.PbList<msg_player_battle_result> createRepeated() => $pb.PbList<msg_player_battle_result>();
  @$core.pragma('dart2js:noInline')
  static msg_player_battle_result getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<msg_player_battle_result>(create);
  static msg_player_battle_result? _defaultInstance;

  @$pb.TagNumber(1)
  msg_player_face_base get player => $_getN(0);
  @$pb.TagNumber(1)
  set player(msg_player_face_base v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPlayer() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayer() => clearField(1);
  @$pb.TagNumber(1)
  msg_player_face_base ensurePlayer() => $_ensure(0);

  @$pb.TagNumber(2)
  msg_battle_result get result => $_getN(1);
  @$pb.TagNumber(2)
  set result(msg_battle_result v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasResult() => $_has(1);
  @$pb.TagNumber(2)
  void clearResult() => clearField(2);
  @$pb.TagNumber(2)
  msg_battle_result ensureResult() => $_ensure(1);
}

class msg_player_face_base extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'msg_player_face_base', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'battle'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId', protoName: 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nickName', protoName: 'nickName')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'avatar')
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'boxId', $pb.PbFieldType.O3, protoName: 'boxId')
    ..hasRequiredFields = false
  ;

  msg_player_face_base._() : super();
  factory msg_player_face_base({
    $fixnum.Int64? userId,
    $core.String? nickName,
    $core.String? avatar,
    $core.int? boxId,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (nickName != null) {
      _result.nickName = nickName;
    }
    if (avatar != null) {
      _result.avatar = avatar;
    }
    if (boxId != null) {
      _result.boxId = boxId;
    }
    return _result;
  }
  factory msg_player_face_base.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory msg_player_face_base.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  msg_player_face_base clone() => msg_player_face_base()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  msg_player_face_base copyWith(void Function(msg_player_face_base) updates) => super.copyWith((message) => updates(message as msg_player_face_base)) as msg_player_face_base; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static msg_player_face_base create() => msg_player_face_base._();
  msg_player_face_base createEmptyInstance() => create();
  static $pb.PbList<msg_player_face_base> createRepeated() => $pb.PbList<msg_player_face_base>();
  @$core.pragma('dart2js:noInline')
  static msg_player_face_base getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<msg_player_face_base>(create);
  static msg_player_face_base? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get nickName => $_getSZ(1);
  @$pb.TagNumber(2)
  set nickName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNickName() => $_has(1);
  @$pb.TagNumber(2)
  void clearNickName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get avatar => $_getSZ(2);
  @$pb.TagNumber(3)
  set avatar($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAvatar() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvatar() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get boxId => $_getIZ(3);
  @$pb.TagNumber(4)
  set boxId($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBoxId() => $_has(3);
  @$pb.TagNumber(4)
  void clearBoxId() => clearField(4);
}

class s2c_battle_invite extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 's2c_battle_invite', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'battle'), createEmptyInstance: create)
    ..aOM<msg_player_face_base>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'player', subBuilder: msg_player_face_base.create)
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'roomId', protoName: 'roomId')
    ..hasRequiredFields = false
  ;

  s2c_battle_invite._() : super();
  factory s2c_battle_invite({
    msg_player_face_base? player,
    $fixnum.Int64? roomId,
  }) {
    final _result = create();
    if (player != null) {
      _result.player = player;
    }
    if (roomId != null) {
      _result.roomId = roomId;
    }
    return _result;
  }
  factory s2c_battle_invite.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory s2c_battle_invite.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  s2c_battle_invite clone() => s2c_battle_invite()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  s2c_battle_invite copyWith(void Function(s2c_battle_invite) updates) => super.copyWith((message) => updates(message as s2c_battle_invite)) as s2c_battle_invite; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static s2c_battle_invite create() => s2c_battle_invite._();
  s2c_battle_invite createEmptyInstance() => create();
  static $pb.PbList<s2c_battle_invite> createRepeated() => $pb.PbList<s2c_battle_invite>();
  @$core.pragma('dart2js:noInline')
  static s2c_battle_invite getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<s2c_battle_invite>(create);
  static s2c_battle_invite? _defaultInstance;

  @$pb.TagNumber(1)
  msg_player_face_base get player => $_getN(0);
  @$pb.TagNumber(1)
  set player(msg_player_face_base v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPlayer() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayer() => clearField(1);
  @$pb.TagNumber(1)
  msg_player_face_base ensurePlayer() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get roomId => $_getI64(1);
  @$pb.TagNumber(2)
  set roomId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRoomId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomId() => clearField(2);
}

class s2c_battle_room_enter extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 's2c_battle_room_enter', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'battle'), createEmptyInstance: create)
    ..aOM<msg_player_face_base>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'face', subBuilder: msg_player_face_base.create)
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'roomId', protoName: 'roomId')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'level', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  s2c_battle_room_enter._() : super();
  factory s2c_battle_room_enter({
    msg_player_face_base? face,
    $fixnum.Int64? roomId,
    $core.int? level,
  }) {
    final _result = create();
    if (face != null) {
      _result.face = face;
    }
    if (roomId != null) {
      _result.roomId = roomId;
    }
    if (level != null) {
      _result.level = level;
    }
    return _result;
  }
  factory s2c_battle_room_enter.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory s2c_battle_room_enter.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  s2c_battle_room_enter clone() => s2c_battle_room_enter()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  s2c_battle_room_enter copyWith(void Function(s2c_battle_room_enter) updates) => super.copyWith((message) => updates(message as s2c_battle_room_enter)) as s2c_battle_room_enter; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static s2c_battle_room_enter create() => s2c_battle_room_enter._();
  s2c_battle_room_enter createEmptyInstance() => create();
  static $pb.PbList<s2c_battle_room_enter> createRepeated() => $pb.PbList<s2c_battle_room_enter>();
  @$core.pragma('dart2js:noInline')
  static s2c_battle_room_enter getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<s2c_battle_room_enter>(create);
  static s2c_battle_room_enter? _defaultInstance;

  @$pb.TagNumber(1)
  msg_player_face_base get face => $_getN(0);
  @$pb.TagNumber(1)
  set face(msg_player_face_base v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasFace() => $_has(0);
  @$pb.TagNumber(1)
  void clearFace() => clearField(1);
  @$pb.TagNumber(1)
  msg_player_face_base ensureFace() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get roomId => $_getI64(1);
  @$pb.TagNumber(2)
  set roomId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRoomId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomId() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get level => $_getIZ(2);
  @$pb.TagNumber(3)
  set level($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLevel() => $_has(2);
  @$pb.TagNumber(3)
  void clearLevel() => clearField(3);
}

class s2c_battle_refuse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 's2c_battle_refuse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'battle'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId', protoName: 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nickName', protoName: 'nickName')
    ..hasRequiredFields = false
  ;

  s2c_battle_refuse._() : super();
  factory s2c_battle_refuse({
    $fixnum.Int64? userId,
    $core.String? nickName,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (nickName != null) {
      _result.nickName = nickName;
    }
    return _result;
  }
  factory s2c_battle_refuse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory s2c_battle_refuse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  s2c_battle_refuse clone() => s2c_battle_refuse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  s2c_battle_refuse copyWith(void Function(s2c_battle_refuse) updates) => super.copyWith((message) => updates(message as s2c_battle_refuse)) as s2c_battle_refuse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static s2c_battle_refuse create() => s2c_battle_refuse._();
  s2c_battle_refuse createEmptyInstance() => create();
  static $pb.PbList<s2c_battle_refuse> createRepeated() => $pb.PbList<s2c_battle_refuse>();
  @$core.pragma('dart2js:noInline')
  static s2c_battle_refuse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<s2c_battle_refuse>(create);
  static s2c_battle_refuse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get nickName => $_getSZ(1);
  @$pb.TagNumber(2)
  set nickName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNickName() => $_has(1);
  @$pb.TagNumber(2)
  void clearNickName() => clearField(2);
}

class s2c_battle_left extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 's2c_battle_left', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'battle'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId', protoName: 'userId')
    ..hasRequiredFields = false
  ;

  s2c_battle_left._() : super();
  factory s2c_battle_left({
    $fixnum.Int64? userId,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    return _result;
  }
  factory s2c_battle_left.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory s2c_battle_left.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  s2c_battle_left clone() => s2c_battle_left()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  s2c_battle_left copyWith(void Function(s2c_battle_left) updates) => super.copyWith((message) => updates(message as s2c_battle_left)) as s2c_battle_left; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static s2c_battle_left create() => s2c_battle_left._();
  s2c_battle_left createEmptyInstance() => create();
  static $pb.PbList<s2c_battle_left> createRepeated() => $pb.PbList<s2c_battle_left>();
  @$core.pragma('dart2js:noInline')
  static s2c_battle_left getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<s2c_battle_left>(create);
  static s2c_battle_left? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);
}

class s2c_battle_level extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 's2c_battle_level', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'battle'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'level', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  s2c_battle_level._() : super();
  factory s2c_battle_level({
    $core.int? level,
  }) {
    final _result = create();
    if (level != null) {
      _result.level = level;
    }
    return _result;
  }
  factory s2c_battle_level.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory s2c_battle_level.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  s2c_battle_level clone() => s2c_battle_level()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  s2c_battle_level copyWith(void Function(s2c_battle_level) updates) => super.copyWith((message) => updates(message as s2c_battle_level)) as s2c_battle_level; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static s2c_battle_level create() => s2c_battle_level._();
  s2c_battle_level createEmptyInstance() => create();
  static $pb.PbList<s2c_battle_level> createRepeated() => $pb.PbList<s2c_battle_level>();
  @$core.pragma('dart2js:noInline')
  static s2c_battle_level getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<s2c_battle_level>(create);
  static s2c_battle_level? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get level => $_getIZ(0);
  @$pb.TagNumber(1)
  set level($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLevel() => $_has(0);
  @$pb.TagNumber(1)
  void clearLevel() => clearField(1);
}

class s2c_battle_ready_state extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 's2c_battle_ready_state', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'battle'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'appUserId')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isReady')
    ..hasRequiredFields = false
  ;

  s2c_battle_ready_state._() : super();
  factory s2c_battle_ready_state({
    $fixnum.Int64? appUserId,
    $core.bool? isReady,
  }) {
    final _result = create();
    if (appUserId != null) {
      _result.appUserId = appUserId;
    }
    if (isReady != null) {
      _result.isReady = isReady;
    }
    return _result;
  }
  factory s2c_battle_ready_state.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory s2c_battle_ready_state.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  s2c_battle_ready_state clone() => s2c_battle_ready_state()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  s2c_battle_ready_state copyWith(void Function(s2c_battle_ready_state) updates) => super.copyWith((message) => updates(message as s2c_battle_ready_state)) as s2c_battle_ready_state; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static s2c_battle_ready_state create() => s2c_battle_ready_state._();
  s2c_battle_ready_state createEmptyInstance() => create();
  static $pb.PbList<s2c_battle_ready_state> createRepeated() => $pb.PbList<s2c_battle_ready_state>();
  @$core.pragma('dart2js:noInline')
  static s2c_battle_ready_state getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<s2c_battle_ready_state>(create);
  static s2c_battle_ready_state? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get appUserId => $_getI64(0);
  @$pb.TagNumber(1)
  set appUserId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAppUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isReady => $_getBF(1);
  @$pb.TagNumber(2)
  set isReady($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsReady() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsReady() => clearField(2);
}

