import 'package:domain/domain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user.g.dart';

class UserState {
  const UserState({
    required this.user,
    required this.loggedIn,
  });

  final User? user;
  final bool loggedIn;
}

@riverpod
class UserStateNotifier extends _$UserStateNotifier {
  @override
  FutureOr<UserState> build() async {
    final user = await ref.watch(userRepositoryProvider).getUser();

    return UserState(
      user: user,
      loggedIn: user != null,
    );
  }

  void logout() {
    state = const AsyncValue.data(
      UserState(
        user: null,
        loggedIn: false,
      ),
    );
  }
}
