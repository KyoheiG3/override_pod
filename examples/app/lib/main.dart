import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gateway/gateway.dart';
import 'package:usecase/usecase.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        ...pods,
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyPage(),
    );
  }
}

class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            userState.when(
              data: (state) {
                return Text(
                  'User name: ${state.user?.name}',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
              error: (error, _) {
                return Text(
                  'Error: $error',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
              loading: () {
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
