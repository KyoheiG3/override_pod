import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:gateway/gateway.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
      home: MyPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyPage extends ConsumerWidget {
  const MyPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
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
