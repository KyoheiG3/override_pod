import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:usecase/src/model.dart';

part 'user.g.dart';

@riverpod
UserRepository userRepository(_) => throw UnimplementedError();

abstract class UserRepository {
  Future<User?> getUser();
}
