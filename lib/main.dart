import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mhgo/core/theme/app_theme.dart';
import 'package:mhgo/core/theme/theme_provider.dart';
import 'package:mhgo/core/router/app_router.dart';
import 'package:mhgo/core/database/isar_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize offline-first Isar Database (seeds mock data on first launch)
  final isarService = IsarService();
  await isarService.init();

  runApp(
    ProviderScope(
      overrides: [isarServiceProvider.overrideWithValue(isarService)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterNotifierProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'MHGo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
