import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/router/app_router.dart';
import 'liquid_glass_container.dart';
import '../../features/admin/presentation/providers/admin_auth_provider.dart';
import '../../features/auth/presentation/providers/auth_state_provider.dart';
import '../../features/project/presentation/providers/project_provider.dart';
import '../../features/project/data/models/project_model.dart';
import '../../shared/widgets/loading_indicator.dart';

/// アプリケーションのDrawer（サイドバー）
class AppDrawer extends ConsumerWidget {
  /// 現在のプロジェクト名
  final String? projectName;

  /// ユーザー名
  final String? userName;

  /// ログアウトコールバック
  final VoidCallback? onLogout;

  /// プロジェクト変更コールバック
  final VoidCallback? onChangeProject;

  const AppDrawer({
    super.key,
    this.projectName,
    this.userName,
    this.onLogout,
    this.onChangeProject,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider);
    final currentUser = ref.watch(currentUserProvider).value;
    final selectedProject = ref.watch(selectedProjectProvider).value;
    final selectedProjectId = ref.watch(selectedProjectIdProvider);
    final userProjectsAsync = ref.watch(userProjectsProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      width: screenWidth * 0.75, // 画面幅の75%
      backgroundColor: AppColors.backgroundLight,
      child: SafeArea(
        child: Column(
          children: [
            // ヘッダー（プロジェクト情報と権限）
            _buildHeader(
              context,
              selectedProject?.name,
              currentUser?.role.label,
            ),

            const SizedBox(height: AppSizes.space),

            // メニューリスト
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingSm,
                ),
                children: [
                  // プロジェクト一覧セクション
                  _buildProjectListSection(
                    context,
                    ref,
                    userProjectsAsync,
                    selectedProjectId,
                  ),

                  const Divider(height: AppSizes.space * 2),

                  // 管理者ページ（管理者のみ表示）
                  if (isAdmin) ...[
                    _buildMenuItem(
                      context,
                      icon: Icons.admin_panel_settings,
                      title: AppStrings.adminPage,
                      onTap: () {
                        Navigator.pop(context);
                        context.go(AppRoutes.admin);
                      },
                    ),
                    const Divider(height: AppSizes.space * 2),
                  ],

                  // プロジェクト変更
                  _buildMenuItem(
                    context,
                    icon: Icons.swap_horiz,
                    title: AppStrings.changeProject,
                    onTap: () {
                      Navigator.pop(context);
                      onChangeProject?.call();
                    },
                  ),

                  // ログアウト
                  _buildMenuItem(
                    context,
                    icon: Icons.logout,
                    title: AppStrings.logout,
                    textColor: AppColors.error,
                    onTap: () {
                      Navigator.pop(context);
                      onLogout?.call();
                    },
                  ),
                ],
              ),
            ),

            // フッター
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  /// ヘッダーを構築
  Widget _buildHeader(
    BuildContext context,
    String? projectName,
    String? userRole,
  ) {
    return LiquidGlassContainer(
      margin: const EdgeInsets.all(AppSizes.paddingSm),
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle,
                size: AppSizes.iconLg,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSizes.spaceSm),
              Text(
                AppStrings.appName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          if (projectName != null) ...[
            const SizedBox(height: AppSizes.spaceSm),
            const Divider(),
            const SizedBox(height: AppSizes.spaceSm),
            Text(
              projectName,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
          if (userName != null) ...[
            const SizedBox(height: AppSizes.spaceXs),
            Text(
              userName!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ],
          if (userRole != null) ...[
            const SizedBox(height: AppSizes.spaceXs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingSm,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                userRole,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: AppSizes.fontXs,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// プロジェクト一覧セクションを構築
  Widget _buildProjectListSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<ProjectModel>> userProjectsAsync,
    String? selectedProjectId,
  ) {
    return userProjectsAsync.when(
      data: (projects) {
        if (projects.isEmpty) {
          return _buildEmptyProjectState(context);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.padding,
                vertical: AppSizes.paddingSm,
              ),
              child: Text(
                'プロジェクト',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceSm),
            ...projects.map((project) {
              final isSelected = selectedProjectId == project.id;
              return _buildProjectItem(context, ref, project, isSelected);
            }),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSizes.padding),
        child: Center(child: LoadingIndicator()),
      ),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 32),
            const SizedBox(height: AppSizes.spaceSm),
            Text(
              'プロジェクトの取得に失敗しました',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// プロジェクト項目を構築
  Widget _buildProjectItem(
    BuildContext context,
    WidgetRef ref,
    ProjectModel project,
    bool isSelected,
  ) {
    return ListTile(
      dense: true,
      leading: Icon(
        isSelected ? Icons.check_circle : Icons.folder_outlined,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        size: 20,
      ),
      title: Text(
        project.name,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: AppSizes.fontSm,
        ),
      ),
      subtitle: Text(
        'コード: ${project.code}',
        style: TextStyle(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.7)
              : AppColors.textSecondary,
          fontSize: AppSizes.fontXs,
        ),
      ),
      onTap: () async {
        await ref
            .read(selectedProjectIdProvider.notifier)
            .selectProject(project.id);
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.padding,
        vertical: 4,
      ),
      minVerticalPadding: 4,
      tileColor: isSelected
          ? AppColors.primary.withValues(alpha: 0.1)
          : Colors.transparent,
    );
  }

  /// 空のプロジェクト状態を構築
  Widget _buildEmptyProjectState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        children: [
          const Icon(
            Icons.folder_open,
            size: 48,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSizes.spaceSm),
          Text(
            'プロジェクトがありません',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceXs),
          Text(
            'プロジェクトコードで参加してください',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textDisabled,
              fontSize: AppSizes.fontXs,
            ),
            textAlign: TextAlign.center,
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
