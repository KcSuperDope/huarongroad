///
//  Generated code. Do not modify.
//  source: battle.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use s2c_battle_startDescriptor instead')
const s2c_battle_start$json = const {
  '1': 's2c_battle_start',
  '2': const [
    const {'1': 'battleId', '3': 1, '4': 1, '5': 3, '10': 'battleId'},
    const {'1': 'putData', '3': 2, '4': 1, '5': 9, '10': 'putData'},
  ],
};

/// Descriptor for `s2c_battle_start`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List s2c_battle_startDescriptor = $convert.base64Decode('ChBzMmNfYmF0dGxlX3N0YXJ0EhoKCGJhdHRsZUlkGAEgASgDUghiYXR0bGVJZBIYCgdwdXREYXRhGAIgASgJUgdwdXREYXRh');
@$core.Deprecated('Use s2c_battle_statusDescriptor instead')
const s2c_battle_status$json = const {
  '1': 's2c_battle_status',
  '2': const [
    const {'1': 'userId', '3': 1, '4': 1, '5': 3, '10': 'userId'},
    const {'1': 'status', '3': 2, '4': 1, '5': 5, '10': 'status'},
  ],
};

/// Descriptor for `s2c_battle_status`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List s2c_battle_statusDescriptor = $convert.base64Decode('ChFzMmNfYmF0dGxlX3N0YXR1cxIWCgZ1c2VySWQYASABKANSBnVzZXJJZBIWCgZzdGF0dXMYAiABKAVSBnN0YXR1cw==');
@$core.Deprecated('Use s2c_battle_countdownDescriptor instead')
const s2c_battle_countdown$json = const {
  '1': 's2c_battle_countdown',
  '2': const [
    const {'1': 'second', '3': 1, '4': 1, '5': 5, '10': 'second'},
  ],
};

/// Descriptor for `s2c_battle_countdown`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List s2c_battle_countdownDescriptor = $convert.base64Decode('ChRzMmNfYmF0dGxlX2NvdW50ZG93bhIWCgZzZWNvbmQYASABKAVSBnNlY29uZA==');
@$core.Deprecated('Use s2c_battle_resultDescriptor instead')
const s2c_battle_result$json = const {
  '1': 's2c_battle_result',
  '2': const [
    const {'1': 'blueResult', '3': 1, '4': 1, '5': 11, '6': '.battle.msg_player_battle_result', '10': 'blueResult'},
    const {'1': 'redResult', '3': 2, '4': 1, '5': 11, '6': '.battle.msg_player_battle_result', '10': 'redResult'},
  ],
};

/// Descriptor for `s2c_battle_result`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List s2c_battle_resultDescriptor = $convert.base64Decode('ChFzMmNfYmF0dGxlX3Jlc3VsdBJACgpibHVlUmVzdWx0GAEgASgLMiAuYmF0dGxlLm1zZ19wbGF5ZXJfYmF0dGxlX3Jlc3VsdFIKYmx1ZVJlc3VsdBI+CglyZWRSZXN1bHQYAiABKAsyIC5iYXR0bGUubXNnX3BsYXllcl9iYXR0bGVfcmVzdWx0UglyZWRSZXN1bHQ=');
@$core.Deprecated('Use s2c_match_sucDescriptor instead')
const s2c_match_suc$json = const {
  '1': 's2c_match_suc',
  '2': const [
    const {'1': 'roomId', '3': 1, '4': 1, '5': 3, '10': 'roomId'},
    const {'1': 'face', '3': 2, '4': 1, '5': 11, '6': '.battle.msg_player_face_base', '10': 'face'},
  ],
};

/// Descriptor for `s2c_match_suc`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List s2c_match_sucDescriptor = $convert.base64Decode('Cg1zMmNfbWF0Y2hfc3VjEhYKBnJvb21JZBgBIAEoA1IGcm9vbUlkEjAKBGZhY2UYAiABKAsyHC5iYXR0bGUubXNnX3BsYXllcl9mYWNlX2Jhc2VSBGZhY2U=');
@$core.Deprecated('Use s2c_match_exitDescriptor instead')
const s2c_match_exit$json = const {
  '1': 's2c_match_exit',
  '2': const [
    const {'1': 'userId', '3': 1, '4': 1, '5': 3, '10': 'userId'},
  ],
};

/// Descriptor for `s2c_match_exit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List s2c_match_exitDescriptor = $convert.base64Decode('Cg5zMmNfbWF0Y2hfZXhpdBIWCgZ1c2VySWQYASABKANSBnVzZXJJZA==');
@$core.Deprecated('Use msg_battle_resultDescriptor instead')
const msg_battle_result$json = const {
  '1': 'msg_battle_result',
  '2': const [
    const {'1': 'result', '3': 1, '4': 1, '5': 5, '10': 'result'},
    const {'1': 'time', '3': 2, '4': 1, '5': 5, '10': 'time'},
    const {'1': 'step', '3': 3, '4': 1, '5': 5, '10': 'step'},
    const {'1': 'reviewId', '3': 4, '4': 1, '5': 3, '10': 'reviewId'},
  ],
};

/// Descriptor for `msg_battle_result`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msg_battle_resultDescriptor = $convert.base64Decode('ChFtc2dfYmF0dGxlX3Jlc3VsdBIWCgZyZXN1bHQYASABKAVSBnJlc3VsdBISCgR0aW1lGAIgASgFUgR0aW1lEhIKBHN0ZXAYAyABKAVSBHN0ZXASGgoIcmV2aWV3SWQYBCABKANSCHJldmlld0lk');
@$core.Deprecated('Use msg_player_battle_resultDescriptor instead')
const msg_player_battle_result$json = const {
  '1': 'msg_player_battle_result',
  '2': const [
    const {'1': 'player', '3': 1, '4': 1, '5': 11, '6': '.battle.msg_player_face_base', '10': 'player'},
    const {'1': 'result', '3': 2, '4': 1, '5': 11, '6': '.battle.msg_battle_result', '10': 'result'},
  ],
};

/// Descriptor for `msg_player_battle_result`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msg_player_battle_resultDescriptor = $convert.base64Decode('Chhtc2dfcGxheWVyX2JhdHRsZV9yZXN1bHQSNAoGcGxheWVyGAEgASgLMhwuYmF0dGxlLm1zZ19wbGF5ZXJfZmFjZV9iYXNlUgZwbGF5ZXISMQoGcmVzdWx0GAIgASgLMhkuYmF0dGxlLm1zZ19iYXR0bGVfcmVzdWx0UgZyZXN1bHQ=');
@$core.Deprecated('Use msg_player_face_baseDescriptor instead')
const msg_player_face_base$json = const {
  '1': 'msg_player_face_base',
  '2': const [
    const {'1': 'userId', '3': 1, '4': 1, '5': 3, '10': 'userId'},
    const {'1': 'nickName', '3': 2, '4': 1, '5': 9, '10': 'nickName'},
    const {'1': 'avatar', '3': 3, '4': 1, '5': 9, '10': 'avatar'},
    const {'1': 'boxId', '3': 4, '4': 1, '5': 5, '10': 'boxId'},
  ],
};

/// Descriptor for `msg_player_face_base`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msg_player_face_baseDescriptor = $convert.base64Decode('ChRtc2dfcGxheWVyX2ZhY2VfYmFzZRIWCgZ1c2VySWQYASABKANSBnVzZXJJZBIaCghuaWNrTmFtZRgCIAEoCVIIbmlja05hbWUSFgoGYXZhdGFyGAMgASgJUgZhdmF0YXISFAoFYm94SWQYBCABKAVSBWJveElk');
@$core.Deprecated('Use s2c_battle_inviteDescriptor instead')
const s2c_battle_invite$json = const {
  '1': 's2c_battle_invite',
  '2': const [
    const {'1': 'player', '3': 1, '4': 1, '5': 11, '6': '.battle.msg_player_face_base', '10': 'player'},
    const {'1': 'roomId', '3': 2, '4': 1, '5': 3, '10': 'roomId'},
  ],
};

/// Descriptor for `s2c_battle_invite`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List s2c_battle_inviteDescriptor = $convert.base64Decode('ChFzMmNfYmF0dGxlX2ludml0ZRI0CgZwbGF5ZXIYASABKAsyHC5iYXR0bGUubXNnX3BsYXllcl9mYWNlX2Jhc2VSBnBsYXllchIWCgZyb29tSWQYAiABKANSBnJvb21JZA==');
@$core.Deprecated('Use s2c_battle_room_enterDescriptor instead')
const s2c_battle_room_enter$json = const {
  '1': 's2c_battle_room_enter',
  '2': const [
    const {'1': 'face', '3': 1, '4': 1, '5': 11, '6': '.battle.msg_player_face_base', '10': 'face'},
    const {'1': 'roomId', '3': 2, '4': 1, '5': 3, '10': 'roomId'},
    const {'1': 'level', '3': 3, '4': 1, '5': 5, '10': 'level'},
  ],
};

/// Descriptor for `s2c_battle_room_enter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List s2c_battle_room_enterDescriptor = $convert.base64Decode('ChVzMmNfYmF0dGxlX3Jvb21fZW50ZXISMAoEZmFjZRgBIAEoCzIcLmJhdHRsZS5tc2dfcGxheWVyX2ZhY2VfYmFzZVIEZmFjZRIWCgZyb29tSWQYAiABKANSBnJvb21JZBIUCgVsZXZlbBgDIAEoBVIFbGV2ZWw=');
@$core.Deprecated('Use s2c_battle_refuseDescriptor instead')
const s2c_battle_refuse$json = const {
  '1': 's2c_battle_refuse',
  '2': const [
    const {'1': 'userId', '3': 1, '4': 1, '5': 3, '10': 'userId'},
    const {'1': 'nickName', '3': 2, '4': 1, '5': 9, '10': 'nickName'},
  ],
};

/// Descriptor for `s2c_battle_refuse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List s2c_battle_refuseDescriptor = $convert.base64Decode('ChFzMmNfYmF0dGxlX3JlZnVzZRIWCgZ1c2VySWQYASABKANSBnVzZXJJZBIaCghuaWNrTmFtZRgCIAEoCVIIbmlja05hbWU=');
@$core.Deprecated('Use s2c_battle_leftDescriptor instead')
const s2c_battle_left$json = const {
  '1': 's2c_battle_left',
  '2': const [
    const {'1': 'userId', '3': 1, '4': 1, '5': 3, '10': 'userId'},
  ],
};

/// Descriptor for `s2c_battle_left`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List s2c_battle_leftDescriptor = $convert.base64Decode('Cg9zMmNfYmF0dGxlX2xlZnQSFgoGdXNlcklkGAEgASgDUgZ1c2VySWQ=');
@$core.Deprecated('Use s2c_battle_levelDescriptor instead')
const s2c_battle_level$json = const {
  '1': 's2c_battle_level',
  '2': const [
    const {'1': 'level', '3': 1, '4': 1, '5': 5, '10': 'level'},
  ],
};

/// Descriptor for `s2c_battle_level`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List s2c_battle_levelDescriptor = $convert.base64Decode('ChBzMmNfYmF0dGxlX2xldmVsEhQKBWxldmVsGAEgASgFUgVsZXZlbA==');
@$core.Deprecated('Use s2c_battle_ready_stateDescriptor instead')
const s2c_battle_ready_state$json = const {
  '1': 's2c_battle_ready_state',
  '2': const [
    const {'1': 'app_user_id', '3': 1, '4': 1, '5': 3, '10': 'appUserId'},
    const {'1': 'is_ready', '3': 2, '4': 1, '5': 8, '10': 'isReady'},
  ],
};

/// Descriptor for `s2c_battle_ready_state`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List s2c_battle_ready_stateDescriptor = $convert.base64Decode('ChZzMmNfYmF0dGxlX3JlYWR5X3N0YXRlEh4KC2FwcF91c2VyX2lkGAEgASgDUglhcHBVc2VySWQSGQoIaXNfcmVhZHkYAiABKAhSB2lzUmVhZHk=');
