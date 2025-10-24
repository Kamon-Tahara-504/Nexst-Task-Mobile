import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/domain/enums/user_role.dart';
import '../providers/admin_provider.dart';
import '../../data/repositories/admin_repository.dart';

/// ユーザー一覧Widget
class UserList extends ConsumerStatefulWidget {
  const UserList({super.key});

  @override
  ConsumerState<UserList> createState() => _UserListState();
}

class _UserListState extends ConsumerState<UserList> {
  bool _showActiveOnly = false;

  @override
  Widget build(BuildContext context) {
    final usersAsync = _showActiveOnly
        ? ref.watch(activeUsersProvider)
        : ref.watch(allUsersProvider);

    return Column(
      children: [
        // フィルターバー
        _buildFilterBar(),
        // ユーザー一覧
        Expanded(
          child: usersAsync.when(
            data: (users) {
              if (users.isEmpty) {
                return _buildEmptyState();
              }
              return _buildUserList(users);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorState(error),
          ),
        ),
      ],
    );
  }

  /// フィルターバーを構築
  Widget _buildFilterBar() {
    return LiquidGlassContainer(
      margin: const EdgeInsets.all(AppSizes.padding),
      padding: const EdgeInsets.all(AppSizes.paddingSm),
      child: Row(
        children: [
          const Icon(Icons.filter_list, color: AppColors.primary),
          const SizedBox(width: AppSizes.spaceSm),
          const Text(
            'フィルター:',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          const SizedBox(width: AppSizes.spaceSm),
          FilterChip(
            label: Text(_showActiveOnly ? 'アクティブのみ' : 'すべて'),
            selected: _showActiveOnly,
            onSelected: (selected) {
              setState(() {
                _showActiveOnly = selected;
              });
            },
            selectedColor: AppColors.primary.withOpacity(0.3),
            checkmarkColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  /// ユーザー一覧を構築
  Widget _buildUserList(List<UserModel> users) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.padding),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserCard(user);
      },
    );
  }

  /// ユーザーカードを構築
  Widget _buildUserCard(UserModel user) {
    return LiquidGlassContainer(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceMd),
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ヘッダー: 名前 + ステータス
          Row(
            children: [
              // アバター
              CircleAvatar(
                backgroundColor: user.isActive
                    ? AppColors.primary
                    : AppColors.textSecondary,
                child: Text(
                  user.displayName.isNotEmpty
                      ? user.displayName[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.spaceMd),
              // ユーザー情報
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // ステータスバッジ
              _buildStatusBadge(user),
            ],
          ),
          const SizedBox(height: AppSizes.spaceMd),
          // 詳細情報
          Row(
            children: [
              _buildInfoChip(
                '権限',
                user.role.value,
                user.isAdmin ? AppColors.primary : AppColors.secondary,
              ),
              const SizedBox(width: AppSizes.spaceSm),
              _buildInfoChip(
                'プロジェクト',
                user.hasProject ? '参加中' : '未参加',
                user.hasProject ? AppColors.success : AppColors.warning,
              ),
              const SizedBox(width: AppSizes.spaceSm),
              _buildInfoChip(
                '登録日',
                AppDateUtils.formatDate(user.createdAt),
                AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceMd),
          // アクションボタン
          _buildActionButtons(user),
        ],
      ),
    );
  }

  /// ステータスバッジを構築
  Widget _buildStatusBadge(UserModel user) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm,
        vertical: AppSizes.paddingXs,
      ),
      decoration: BoxDecoration(
        color: user.isActive
            ? AppColors.success.withOpacity(0.2)
            : AppColors.error.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(
          color: user.isActive ? AppColors.success : AppColors.error,
          width: 1,
        ),
      ),
      child: Text(
        user.isActive ? 'アクティブ' : '非アクティブ',
        style: TextStyle(
          fontSize: AppSizes.fontXs,
          fontWeight: FontWeight.w600,
          color: user.isActive ? AppColors.success : AppColors.error,
        ),
      ),
    );
  }

  /// 情報チップを構築
  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm,
        vertical: AppSizes.paddingXs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppSizes.fontXs,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(fontSize: AppSizes.fontXs, color: color),
          ),
        ],
      ),
    );
  }

  /// アクションボタンを構築
  Widget _buildActionButtons(UserModel user) {
    return Row(
      children: [
        // アクティブ状態切替
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _toggleUserActiveStatus(user),
            icon: Icon(
              user.isActive ? Icons.person_off : Icons.person,
              size: 16,
            ),
            label: Text(user.isActive ? '非アクティブ化' : 'アクティブ化'),
            style: ElevatedButton.styleFrom(
              backgroundColor: user.isActive
                  ? AppColors.warning
                  : AppColors.success,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: AppSizes.spaceSm),
        // 権限変更
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _toggleUserRole(user),
            icon: Icon(
              user.isAdmin ? Icons.admin_panel_settings : Icons.person,
              size: 16,
            ),
            label: Text(user.isAdmin ? 'メンバー化' : '管理者化'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  /// 空状態を構築
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.white),
          SizedBox(height: AppSizes.spaceXl),
          Text(
            'ユーザーが見つかりません',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// エラー状態を構築
  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.white),
          const SizedBox(height: AppSizes.spaceXl),
          const Text(
            'エラーが発生しました',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSizes.space),
          Text(
            error.toString(),
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// ユーザーのアクティブ状態を切替
  Future<void> _toggleUserActiveStatus(UserModel user) async {
    final confirmed = await context.showConfirmDialog(
      title: 'ユーザー状態変更',
      message:
          '${user.displayName}を${user.isActive ? '非アクティブ' : 'アクティブ'}にしますか？',
    );

    if (!confirmed) return;

    try {
      final repository = ref.read(adminRepositoryProvider);
      await repository.updateUserActiveStatus(user.id, !user.isActive);

      if (mounted) {
        context.showSuccessSnackbar(
          '${user.displayName}を${user.isActive ? '非アクティブ' : 'アクティブ'}にしました',
        );
        ref.invalidate(allUsersProvider);
        ref.invalidate(activeUsersProvider);
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackbar('状態変更に失敗しました: ${e.toString()}');
      }
    }
  }

  /// ユーザーの権限を切替
  Future<void> _toggleUserRole(UserModel user) async {
    final confirmed = await context.showConfirmDialog(
      title: 'ユーザー権限変更',
      message: '${user.displayName}を${user.isAdmin ? 'メンバー' : '管理者'}にしますか？',
    );

    if (!confirmed) return;

    try {
      final repository = ref.read(adminRepositoryProvider);
      final newRole = user.isAdmin
          ? UserRole.member.value
          : UserRole.admin.value;
      await repository.updateUserRole(user.id, newRole);

      if (mounted) {
        context.showSuccessSnackbar(
          '${user.displayName}を${user.isAdmin ? 'メンバー' : '管理者'}にしました',
        );
        ref.invalidate(allUsersProvider);
        ref.invalidate(activeUsersProvider);
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackbar('権限変更に失敗しました: ${e.toString()}');
      }
    }
  }
}
