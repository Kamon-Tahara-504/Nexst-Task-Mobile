import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';

/// 管理者権限チェックProvider
final isAdminProvider = Provider<bool>((ref) {
  final currentUser = ref.watch(currentUserProvider).value;
  return currentUser?.isAdmin ?? false;
});

/// 管理者権限チェック（非同期）
final isAdminAsyncProvider = FutureProvider<bool>((ref) async {
  final currentUser = await ref.watch(currentUserProvider.future);
  return currentUser?.isAdmin ?? false;
});

/// 管理者権限が必要な操作のガードProvider
final adminGuardProvider = Provider<AdminGuard>((ref) {
  final isAdmin = ref.watch(isAdminProvider);
  return AdminGuard(isAdmin);
});

/// 管理者権限ガードクラス
class AdminGuard {
  final bool _isAdmin;

  AdminGuard(this._isAdmin);

  /// 管理者権限があるかチェック
  bool get isAdmin => _isAdmin;

  /// 管理者権限が必要な操作を実行
  T? executeIfAdmin<T>(T Function() action) {
    if (_isAdmin) {
      return action();
    }
    return null;
  }

  /// 管理者権限が必要な操作を実行（エラー付き）
  T executeIfAdminOrThrow<T>(T Function() action) {
    if (_isAdmin) {
      return action();
    }
    throw AdminPermissionException('管理者権限が必要です');
  }

  /// 管理者権限が必要な操作を実行（デフォルト値付き）
  T executeIfAdminOrDefault<T>(T Function() action, T defaultValue) {
    if (_isAdmin) {
      return action();
    }
    return defaultValue;
  }
}

/// 管理者権限例外
class AdminPermissionException implements Exception {
  final String message;
  AdminPermissionException(this.message);

  @override
  String toString() => 'AdminPermissionException: $message';
}
