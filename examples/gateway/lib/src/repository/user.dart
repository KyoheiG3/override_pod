import 'package:override_pod_annotation/override_pod_annotation.dart';
import 'package:usecase/usecase.dart';

@overridePod
final pod = userRepositoryProvider.overrideWith(UserRepositoryImpl.new);

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(this.ref);

  final UserRepositoryRef ref;

  @override
  Future<User?> getUser() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return const User(42, 'John Doe');
  }
}
