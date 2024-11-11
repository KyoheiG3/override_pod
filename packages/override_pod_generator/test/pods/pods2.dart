import 'package:override_pod_generator/src/annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pods2.g.dart';

@riverpod
String temp1(_) => throw UnimplementedError();

@riverpod
String temp2(_) => throw UnimplementedError();

@testPod
final pod1 = temp1Provider.overrideWithValue('temp1');

@testPod
final pod2 = temp2Provider.overrideWith((_) => 'temp2');
