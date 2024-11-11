import 'dart:io';

import 'package:test/test.dart';

void main() {
  const expectedCode = '''
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'asset:override_pod_generator/test/pods/pods1.dart' as _i3;
import 'asset:override_pod_generator/test/pods/pods2.dart' as _i2;

import 'package:riverpod/riverpod.dart' as _i1;

final pods = <_i1.Override>[
  _i2.pod1,
  _i2.pod2,
  _i3.pod1,
  _i3.pod2,
];
''';

  group('OverridePodsBuilder', () {
    test('should build pods', () {
      final genFile = File('test/pods.gen.dart');
      expect(genFile.readAsStringSync(), expectedCode);
    });
  });
}
