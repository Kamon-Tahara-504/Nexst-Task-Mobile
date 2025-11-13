import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../admin/presentation/providers/admin_auth_provider.dart';
import '../../../project/presentation/providers/project_provider.dart';

/// 設定画面
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;
    final selectedProject = ref.watch(selectedProjectProvider).value;
    final isAdmin = ref.watch(isAdminProvider);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // プロジェクト情報
                _buildProjectInfo(context, selectedProject?.name),

                const SizedBox(height: AppSizes.spaceXl),

                // ユーザー情報
                _buildUserInfo(context, currentUser?.userName),

                const SizedBox(height: AppSizes.spaceXl),

                // メニュー項目
                _buildMenuItems(context, ref, isAdmin),

                const SizedBox(height: AppSizes.spaceXl),

                // フッター
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// AppBarを構築
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        '設定',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// プロジェクト情報を構築
  Widget _buildProjectInfo(BuildContext context, String? projectName) {
    return LiquidGlassContainer(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.folder,
                size: AppSizes.iconLg,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSizes.spaceSm),
              Text(
                'プロジェクト',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceSm),
          const Divider(),
          const SizedBox(height: AppSizes.spaceSm),
          Text(
            projectName ?? 'プロジェクトが選択されていません',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  /// ユーザー情報を構築
  Widget _buildUserInfo(BuildContext context, String? userName) {
    return LiquidGlassContainer(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person,
                size: AppSizes.iconLg,
                color: AppColors.secondary,
              ),
              const SizedBox(width: AppSizes.spaceSm),
              Text(
                'ユーザー情報',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceSm),
          const Divider(),
          const SizedBox(height: AppSizes.spaceSm),
          Text(
            userName ?? 'ユーザー情報が取得できません',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  /// メニュー項目を構築
  Widget _buildMenuItems(BuildContext context, WidgetRef ref, bool isAdmin) {
    return LiquidGlassContainer(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'メニュー',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSizes.space),

          // 管理者ページ（管理者のみ表示）
          if (isAdmin) ...[
            const Divider(height: AppSizes.space),
            _buildMenuItem(
              context,
              icon: Icons.admin_panel_settings,
              title: AppStrings.adminPage,
              onTap: () {
                context.go(AppRoutes.admin);
              },
            ),
          ],

          const Divider(height: AppSizes.space),

          // プロジェクト変更
          _buildMenuItem(
            context,
            icon: Icons.swap_horiz,
            title: AppStrings.changeProject,
            onTap: () async {
              await ref
                  .read(selectedProjectIdProvider.notifier)
                  .clearSelectedProject();
              if (context.mounted) {
                context.go(AppRoutes.projectSelection);
              }
            },
          ),

          // ログアウト
          _buildMenuItem(
            context,
            icon: Icons.logout,
            title: AppStrings.logout,
            textColor: AppColors.error,
            onTap: () async {
              final logout = ref.read(logoutProvider);
              await logout();
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
          ),
        ],
      ),
    );
  }

  /// メニュー項目を構築
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback? onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppColors.textPrimary),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.padding,
        vertical: AppSizes.paddingXs,
      ),
    );
  }

  /// フッターを構築
  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Text(
        AppStrings.copyright,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textDisabled,
          fontSize: AppSizes.fontXs,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
