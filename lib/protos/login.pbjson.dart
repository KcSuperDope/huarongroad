///
//  Generated code. Do not modify.
//  source: login.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use c2s_heartbeatDescriptor instead')
const c2s_heartbeat$json = const {
  '1': 'c2s_heartbeat',
};

/// Descriptor for `c2s_heartbeat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List c2s_heartbeatDescriptor = $convert.base64Decode('Cg1jMnNfaGVhcnRiZWF0');
@$core.Deprecated('Use s2c_heartbeatDescriptor instead')
const s2c_heartbeat$json = const {
  '1': 's2c_heartbeat',
  '2': const [
    const {'1': 'timestamp', '3': 1, '4': 1, '5': 3, '10': 'timestamp'},
  ],
};

/// Descriptor for `s2c_heartbeat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List s2c_heartbeatDescriptor = $convert.base64Decode('Cg1zMmNfaGVhcnRiZWF0EhwKCXRpbWVzdGFtcBgBIAEoA1IJdGltZXN0YW1w');
@$core.Deprecated('Use c2s_authDescriptor instead')
const c2s_auth$json = const {
  '1': 'c2s_auth',
  '2': const [
    const {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `c2s_auth`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List c2s_authDescriptor = $convert.base64Decode('CghjMnNfYXV0aBIUCgV0b2tlbhgBIAEoCVIFdG9rZW4=');
@$core.Deprecated('Use s2c_authDescriptor instead')
const s2c_auth$json = const {
  '1': 's2c_auth',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `s2c_auth`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List s2c_authDescriptor = $convert.base64Decode('CghzMmNfYXV0aBIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');
