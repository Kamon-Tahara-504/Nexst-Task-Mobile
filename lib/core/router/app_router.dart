import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/project/presentation/screens/project_selection_screen.dart';
import '../../features/task/presentation/screens/task_board_screen.dart';
import '../../features/task/presentation/screens/task_detail_screen.dart';
import '../../features/admin/presentation/screens/admin_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

/// ルート名の定数
class AppRoutes {
  AppRoutes._(); // プライベートコンストラクタ

  static const String login = '/login';
  static const String register = '/register';
  static const String projectSelection = '/project-selection';
  static const String taskBoard = '/';
  static const String taskDetail = '/task/:id';
  static const String admin = '/admin';
  static const String settings = '/settings';
}

/// アプリケーション全体のルーティング設定
///
/// go_routerを使用して宣言的なルーティングを実現
class AppRouter {
  AppRouter._(); // プライベートコンストラクタ

  /// GoRouterの設定
  static GoRouter router({
    required bool isAuthenticated,
    required bool hasSelectedProject,
  }) {
    return GoRouter(
      initialLocation: AppRoutes.login,
      redirect: (context, state) {
        final isLoggingIn = state.matchedLocation == AppRoutes.login;
        final isRegistering = state.matchedLocation == AppRoutes.register;
        final isSelectingProject =
            state.matchedLocation == AppRoutes.projectSelection;

        // 認証されていない場合
        if (!isAuthenticated) {
          if (isLoggingIn || isRegistering) {
            return null; // ログイン・登録画面へのアクセスは許可
          }
          return AppRoutes.login; // それ以外はログイン画面へリダイレクト
        }

        // 認証されているが、プロジェクトが選択されていない場合
        if (!hasSelectedProject) {
          if (isSelectingProject) {
            return null; // プロジェクト選択画面へのアクセスは許可
          }
          return AppRoutes.projectSelection; // プロジェクト選択画面へリダイレクト
        }

        // 認証済み＆プロジェクト選択済みの場合、ログイン画面にアクセスしようとしたら
        if (isLoggingIn || isRegistering || isSelectingProject) {
          return AppRoutes.taskBoard; // タスクボードへリダイレクト
        }

        return null; // それ以外はそのまま
      },
      routes: [
        // ログイン画面
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          pageBuilder: (context, state) {
            return MaterialPage(key: state.pageKey, child: const LoginScreen());
          },
        ),

        // 新規登録画面
        GoRoute(
          path: AppRoutes.register,
          name: 'register',
          pageBuilder: (context, state) {
            return MaterialPage(
              key: state.pageKey,
              child: const RegisterScreen(),
            );
          },
        ),

        // プロジェクト選択画面
        GoRoute(
          path: AppRoutes.projectSelection,
          name: 'projectSelection',
          pageBuilder: (context, state) {
            return MaterialPage(
              key: state.pageKey,
              child: const ProjectSelectionScreen(),
            );
          },
        ),

        // タスクボード（メイン画面）
        GoRoute(
          path: AppRoutes.taskBoard,
          name: 'taskBoard',
          pageBuilder: (context, state) {
            return MaterialPage(
              key: state.pageKey,
              child: const TaskBoardScreen(),
            );
          },
          routes: [
            // タスク詳細画面（動的パス）
            GoRoute(
              path: 'task/:id',
              name: 'taskDetail',
              pageBuilder: (context, state) {
                final taskId = state.pathParameters['id']!;
                return MaterialPage(
                  key: state.pageKey,
                  child: TaskDetailScreen(taskId: taskId),
                );
              },
            ),

            // 管理者画面
            GoRoute(
              path: 'admin',
              name: 'admin',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: const AdminScreen(),
                );
              },
            ),

            // 設定画面
            GoRoute(
              path: 'settings',
              name: 'settings',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: const SettingsScreen(),
                );
              },
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  '404 Not Found',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Path: ${state.matchedLocation}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.go(AppRoutes.taskBoard);
                  },
                  child: const Text('ホームに戻る'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
