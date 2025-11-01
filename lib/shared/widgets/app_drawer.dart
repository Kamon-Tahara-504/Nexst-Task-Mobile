import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import 'liquid_glass_container.dart';
import '../../features/admin/presentation/providers/admin_auth_provider.dart';

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
    return Drawer(
      backgroundColor: AppColors.backgroundLight,
      child: SafeArea(
        child: Column(
          children: [
            // ヘッダー（プロジェクト情報）
            _buildHeader(context),

            const SizedBox(height: AppSizes.space),

            // メニューリスト
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingSm,
                ),
                children: [
                  // Solo Task
                  _buildMenuItem(
                    context,
                    icon: Icons.person,
                    title: AppStrings.soloTask,
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Solo Taskページへ遷移
                    },
                  ),

                  // Group Task
                  _buildExpandableMenuItem(
                    context,
                    icon: Icons.group,
                    title: AppStrings.groupTask,
                    children: [
                      _buildSubMenuItem(
                        context,
                        title: AppStrings.front,
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Frontページへ遷移
                        },
                      ),
                      _buildSubMenuItem(
                        context,
                        title: AppStrings.back,
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Backページへ遷移
                        },
                      ),
                      _buildSubMenuItem(
                        context,
                        title: AppStrings.setting,
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Settingページへ遷移
                        },
                      ),
                    ],
                  ),

                  // Team Task
                  _buildMenuItem(
                    context,
                    icon: Icons.groups,
                    title: AppStrings.teamTask,
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Team Taskページへ遷移
                    },
                  ),

                  // 管理者ページ（管理者のみ表示）
                  if (isAdmin) ...[
                    const Divider(height: AppSizes.space * 2),
                    _buildMenuItem(
                      context,
                      icon: Icons.admin_panel_settings,
                      title: AppStrings.adminPage,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/admin');
                      },
                    ),
                  ],

                  const Divider(height: AppSizes.space * 2),

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
  Widget _buildHeader(BuildContext context) {
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
              projectName!,
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

  /// 展開可能なメニュー項目を構築
  Widget _buildExpandableMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: children,
      tilePadding: const EdgeInsets.symmetric(horizontal: AppSizes.padding),
      childrenPadding: const EdgeInsets.only(left: AppSizes.paddingLg),
    );
  }

  /// サブメニュー項目を構築
  Widget _buildSubMenuItem(
    BuildContext context, {
    required String title,
    required VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppSizes.fontSm,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.padding),
      dense: true,
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
