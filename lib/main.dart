import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/router/app_router.dart';
import 'features/auth/data/providers/supabase_provider.dart';
import 'features/project/presentation/providers/project_provider.dart';

void main() async {
  // Flutter Bindingの初期化
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 環境変数の読み込み
    await dotenv.load(fileName: '.env');
    debugPrint('環境変数読み込み成功');

    // Supabaseの初期化
    await SupabaseConfig.initialize();
    debugPrint('Supabase初期化成功');

    // アプリ起動
    runApp(
      // Riverpodのルートプロバイダー
      const ProviderScope(child: MyApp()),
    );
  } catch (e, stackTrace) {
    debugPrint('アプリ初期化エラー: $e');
    debugPrint('StackTrace: $stackTrace');

    // エラーが発生した場合でもアプリを起動（エラー画面を表示）
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 24),
                  const Text(
                    '初期化エラー',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    e.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '.envファイルが正しく設定されているか確認してください。',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 認証状態を監視
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    // プロジェクト選択状態を監視
    final hasSelectedProject = ref.watch(hasSelectedProjectProvider);

    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,

      // テーマ設定
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      // go_router設定
      routerConfig: AppRouter.router(
        isAuthenticated: isAuthenticated,
        hasSelectedProject: hasSelectedProject,
      ),
    );
  }
}
