import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/router/app_router.dart';
import '../../features/admin/presentation/providers/admin_auth_provider.dart';
import '../../features/project/presentation/providers/project_provider.dart';
import '../../features/project/presentation/providers/task_screen_trigger_provider.dart';
import '../../features/project/data/models/project_model.dart';
import '../../features/project/presentation/widgets/project_creation_modal.dart';
import '../../features/project/data/repositories/project_repository.dart';
import '../../features/auth/presentation/providers/auth_state_provider.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../shared/widgets/loading_indicator.dart';
import '../../shared/widgets/display_name_dialog.dart';
import '../../shared/extensions/context_extensions.dart';

/// アプリケーションのDrawer（サイドバー）
class AppDrawer extends ConsumerWidget {
  /// 現在のプロジェクト名
  final String? projectName;

  /// ユーザー名
  final String? userName;

  const AppDrawer({super.key, this.projectName, this.userName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider);
    final selectedProjectId = ref.watch(selectedProjectIdProvider);
    final userProjectsAsync = ref.watch(userProjectsProvider);

    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
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
                    isAdmin,
                  ),

                  Divider(
                    height: AppSizes.space * 2,
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.2),
                  ),

                  // 管理者ページ（管理者のみ表示）
                  if (isAdmin)
                    _buildMenuItem(
                      context,
                      icon: Icons.admin_panel_settings,
                      title: AppStrings.adminPage,
                      onTap: () {
                        context.go(AppRoutes.admin);
                      },
                    ),
                ],
              ),
            ),

            // ログアウト
            _buildLogoutButton(context, ref),

            // フッター
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  /// プロジェクト一覧セクションを構築
  Widget _buildProjectListSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<ProjectModel>> userProjectsAsync,
    String? selectedProjectId,
    bool isAdmin,
  ) {
    return userProjectsAsync.when(
      data: (projects) {
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
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceSm),
            if (projects.isEmpty)
              _buildEmptyProjectState(context)
            else ...[
              ...projects.map((project) {
                final isSelected = selectedProjectId == project.id;
                return _buildProjectItem(context, ref, project, isSelected);
              }),
              const SizedBox(height: AppSizes.spaceSm),
              // プロジェクト作成・参加統合ボタン
              _buildProjectActionButton(context, ref, isAdmin),
            ],
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

  /// プロジェクト項目を構築（Discord風: 1行＋右端メニューボタン）
  Widget _buildProjectItem(
    BuildContext context,
    WidgetRef ref,
    ProjectModel project,
    bool isSelected,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm,
        vertical: AppSizes.paddingXs,
      ),
      child: Material(
        color: isSelected
            ? colorScheme.primaryContainer
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: InkWell(
          onTap: () async {
            if (isSelected) {
              requestOpenTaskScreen(ref);
            } else {
              await ref
                  .read(selectedProjectIdProvider.notifier)
                  .selectProject(project.id);
            }
          },
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: isSelected
                  ? Border(
                      left: BorderSide(
                        color: colorScheme.primary,
                        width: 3,
                      ),
                    )
                  : null,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.padding,
              vertical: AppSizes.paddingSm,
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.check_circle : Icons.folder_outlined,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  size: 22,
                ),
                const SizedBox(width: AppSizes.spaceSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        project.name,
                        style: TextStyle(
                          color: isSelected
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w600,
                          fontSize: AppSizes.fontSm,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        project.code,
                        style: TextStyle(
                          color: isSelected
                              ? colorScheme.onPrimaryContainer
                                  .withValues(alpha: 0.7)
                              : colorScheme.onSurfaceVariant,
                          fontSize: AppSizes.fontXs,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: isSelected
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant,
                    size: 22,
                  ),
                  onPressed: () =>
                      _showProjectContextMenu(context, ref, project),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// プロジェクトのコンテキストメニュー（移動・表示名変更）を表示
  void _showProjectContextMenu(
    BuildContext context,
    WidgetRef ref,
    ProjectModel project,
  ) async {
    if (!context.mounted) return;
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.padding),
              child: Text(
                project.name,
                style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Divider(
              height: 1,
              color: Theme.of(sheetContext)
                  .colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
            ListTile(
              leading: Icon(
                Icons.open_in_new,
                color: Theme.of(sheetContext).colorScheme.primary,
              ),
              title: const Text('プロジェクトに移動'),
              onTap: () async {
                Navigator.pop(sheetContext);
                await ref
                    .read(selectedProjectIdProvider.notifier)
                    .selectProject(project.id);
                if (context.mounted) requestOpenTaskScreen(ref);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.badge,
                color: Theme.of(sheetContext).colorScheme.primary,
              ),
              title: const Text('表示名を変更'),
              onTap: () async {
                Navigator.pop(sheetContext);
                final user = await ref.read(currentUserProvider.future);
                if (!context.mounted || user == null) return;
                DisplayNameDialog.show(
                  context,
                  initialName: user.userName,
                  onSave: (name) async {
                    final repo = ref.read(authRepositoryProvider);
                    await repo.updateUserName(user.id, name);
                    ref.invalidate(currentUserProvider);
                    if (context.mounted) {
                      context.showSuccessSnackbar('表示名を変更しました');
                    }
                  },
                );
              },
            ),
            const SizedBox(height: AppSizes.space),
          ],
        ),
      ),
    );
  }

  /// 空のプロジェクト状態を構築
  Widget _buildEmptyProjectState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        children: [
          Icon(
            Icons.folder_open,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSizes.spaceSm),
          Text(
            'プロジェクトがありません',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceXs),
          Text(
            'プロジェクトコードで参加してください',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
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
    final colorScheme = Theme.of(context).colorScheme;
    final finalTextColor = textColor ?? colorScheme.onSurface;
    final finalIconColor = textColor ?? colorScheme.onSurfaceVariant;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm,
        vertical: AppSizes.paddingXs,
      ),
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: ListTile(
        leading: Icon(icon, color: finalIconColor, size: 24),
        title: Text(
          title,
          style: TextStyle(
            color: finalTextColor,
            fontWeight: FontWeight.w600,
            fontSize: AppSizes.fontSm,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.padding,
          vertical: AppSizes.paddingXs,
        ),
        minVerticalPadding: AppSizes.paddingXs,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
    );
  }

  /// プロジェクト作成・参加統合ボタンを構築
  Widget _buildProjectActionButton(
    BuildContext context,
    WidgetRef ref,
    bool isAdmin,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingSm),
      child: ElevatedButton.icon(
        onPressed: () {
          _showProjectActionBottomSheet(context, ref, isAdmin);
        },
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('プロジェクトを作成・参加'),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.padding,
            vertical: AppSizes.padding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        ),
      ),
    );
  }

  /// プロジェクト作成・参加の選択BottomSheetを表示
  void _showProjectActionBottomSheet(
    BuildContext context,
    WidgetRef ref,
    bool isAdmin,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.padding),
              child: Text(
                'プロジェクトを作成・参加',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
            ),
            ListTile(
              leading: Icon(
                Icons.add_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text(AppStrings.createProject),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                showDialog(
                  context: context,
                  builder: (dialogContext) => const ProjectCreationModal(),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.vpn_key,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: const Text(AppStrings.joinProject),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                _showJoinProjectDialog(context, ref);
              },
            ),
            const SizedBox(height: AppSizes.space),
          ],
        ),
      ),
    );
  }

  /// プロジェクトコードで参加するダイアログを表示
  void _showJoinProjectDialog(BuildContext context, WidgetRef ref) {
    final codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.joinProject),
        content: TextField(
          controller: codeController,
          decoration: const InputDecoration(
            labelText: AppStrings.projectCode,
            hintText: AppStrings.placeholderProjectCode,
            prefixIcon: Icon(Icons.vpn_key),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final code = codeController.text.trim();
              if (code.isEmpty) {
                return;
              }

              Navigator.pop(dialogContext);

              // ローディング開始
              ref.read(projectJoiningProvider.notifier).state = true;

              try {
                final currentUser = await ref.read(currentUserProvider.future);
                if (currentUser == null) {
                  throw Exception('ユーザー情報が取得できません');
                }

                final repository = ref.read(projectRepositoryProvider);
                final project = await repository.joinProjectByCode(
                  code: code,
                  userId: currentUser.id,
                );

                if (project != null) {
                  // プロジェクト選択
                  await ref
                      .read(selectedProjectIdProvider.notifier)
                      .selectProject(project.id);

                  // プロジェクト一覧を更新
                  ref.invalidate(userProjectsProvider);

                  if (context.mounted) {
                    context.showSuccessSnackbar('プロジェクトに参加しました');
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  context.showErrorSnackbar(
                    'プロジェクトへの参加に失敗しました: ${e.toString()}',
                  );
                }
              } finally {
                ref.read(projectJoiningProvider.notifier).state = false;
              }
            },
            child: const Text(AppStrings.joinProject),
          ),
        ],
      ),
    );
  }

  /// ログアウトボタンを構築
  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return _buildMenuItem(
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
