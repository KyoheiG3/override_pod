import 'package:domain/src/model/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user.g.dart';

@riverpod
UserRepository userRepository(_) => throw UnimplementedError();

abstract class UserRepository {
  Future<User?> getUser();
}
