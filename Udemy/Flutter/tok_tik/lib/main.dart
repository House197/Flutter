import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tok_tik/config/theme/app_theme.dart';
import 'package:tok_tik/presentation/screens/discover/discover_screen.dart';
import 'package:tok_tik/presentation/providers/discover_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => DiscoverProvider()..loadNextPage(),
        ),
      ],
      child: MaterialApp(
          title: 'TokTik',
          debugShowCheckedModeBanner: false,
          theme: AppTheme().getTheme(),
          home: const DiscoverScreen()),
    );
  }
}
