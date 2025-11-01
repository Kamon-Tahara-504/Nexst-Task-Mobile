import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/supabase_provider.dart';
import '../../data/repositories/auth_repository.dart';

/// 認証ローディング状態
final authLoadingProvider = StateProvider<bool>((ref) => false);

/// 認証エラーメッセージ
final authErrorProvider = StateProvider<String?>((ref) => null);

/// 現在のユーザー情報（usersテーブルから取得）
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authUser = ref.watch(currentAuthUserProvider);

  if (authUser == null) {
    return null;
  }

  final repository = ref.read(authRepositoryProvider);
  return repository.getCurrentUser();
});

/// ログイン処理のプロバイダー
final loginProvider =
    Provider<Future<void> Function(String email, String password)>((ref) {
      return (email, password) async {
        final repository = ref.read(authRepositoryProvider);
        ref.read(authLoadingProvider.notifier).state = true;
        ref.read(authErrorProvider.notifier).state = null;

        try {
          await repository.login(email: email, password: password);

          if (kDebugMode) {
            print('ログイン成功');
          }
        } catch (e) {
          if (kDebugMode) {
            print('ログインエラー: $e');
          }

          // エラーメッセージを設定
          ref.read(authErrorProvider.notifier).state = _getErrorMessage(e);
          rethrow;
        } finally {
          ref.read(authLoadingProvider.notifier).state = false;
        }
      };
    });

/// 新規登録処理のプロバイダー
final signUpProvider =
    Provider<
      Future<void> Function(String email, String password, String userName)
    >((ref) {
      return (email, password, userName) async {
        final repository = ref.read(authRepositoryProvider);
        ref.read(authLoadingProvider.notifier).state = true;
        ref.read(authErrorProvider.notifier).state = null;

        try {
          await repository.signUp(
            email: email,
            password: password,
            userName: userName,
          );

          if (kDebugMode) {
            print('新規登録成功');
          }
        } catch (e) {
          if (kDebugMode) {
            print('登録エラー: $e');
          }

          // エラーメッセージを設定
          ref.read(authErrorProvider.notifier).state = _getErrorMessage(e);
          rethrow;
        } finally {
          ref.read(authLoadingProvider.notifier).state = false;
        }
      };
    });

/// ログアウト処理のプロバイダー
final logoutProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final repository = ref.read(authRepositoryProvider);

    try {
      await repository.logout();

      if (kDebugMode) {
        print('ログアウト成功');
      }

      // すべての状態をクリア
      ref.invalidate(currentUserProvider);
    } catch (e) {
      if (kDebugMode) {
        print('ログアウトエラー: $e');
      }
      rethrow;
    }
  };
});

/// エラーメッセージを取得
String _getErrorMessage(Object error) {
  final errorString = error.toString().toLowerCase();

  if (errorString.contains('invalid login credentials') ||
      errorString.contains('invalid email or password')) {
    return 'メールアドレスまたはパスワードが正しくありません';
  }

  if (errorString.contains('email already registered') ||
      errorString.contains('user already registered')) {
    return 'このメールアドレスは既に登録されています';
  }

  if (errorString.contains('network') || errorString.contains('connection')) {
    return 'ネットワーク接続を確認してください';
  }

  if (errorString.contains('weak password')) {
    return 'パスワードは8文字以上で入力してください';
  }

  return 'エラーが発生しました。もう一度お試しください。';
}
