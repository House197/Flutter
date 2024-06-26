import 'package:flutter/material.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/config/router/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await Environment.initEnvironment();
  runApp(
    const ProviderScope(child: MainApp()),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(goRouterProvider),
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
