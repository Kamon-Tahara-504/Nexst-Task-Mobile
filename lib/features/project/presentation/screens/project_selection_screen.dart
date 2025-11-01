import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../data/models/project_model.dart';
import '../../data/repositories/project_repository.dart';
import '../providers/project_provider.dart';
import '../widgets/project_card.dart';
import '../widgets/project_creation_modal.dart';

/// プロジェクト選択画面
class ProjectSelectionScreen extends ConsumerWidget {
  const ProjectSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProjectsAsync = ref.watch(userProjectsProvider);
    final currentUser = ref.watch(currentUserProvider).value;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            AppStrings.projectSelection,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            // ログアウトボタン
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                final confirmed = await context.showConfirmDialog(
                  title: AppStrings.confirmLogout,
                  message: 'ログアウトしますか？',
                );

                if (confirmed && context.mounted) {
                  final logout = ref.read(logoutProvider);
                  await logout();
                  if (context.mounted) {
                    context.go(AppRoutes.login);
                  }
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          child: userProjectsAsync.when(
            data: (projects) => _buildProjectList(
              context,
              ref,
              projects,
              currentUser?.isAdmin ?? false,
            ),
            loading: () => const Center(child: LoadingIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'エラーが発生しました',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectList(
    BuildContext context,
    WidgetRef ref,
    List<ProjectModel> projects,
    bool isAdmin,
  ) {
    if (projects.isEmpty) {
      return _buildEmptyState(context, ref, isAdmin);
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSizes.padding),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return ProjectCard(
                project: projects[index],
                onTap: () async {
                  await ref
                      .read(selectedProjectIdProvider.notifier)
                      .selectProject(projects[index].id);

                  if (context.mounted) {
                    context.go(AppRoutes.taskBoard);
                  }
                },
              );
            },
          ),
        ),

        // ボトムアクションエリア
        _buildBottomActions(context, ref, isAdmin),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref, bool isAdmin) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LiquidGlassContainer(
              padding: const EdgeInsets.all(AppSizes.paddingXxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.folder_open, size: 80, color: Colors.white),
                  const SizedBox(height: AppSizes.spaceXl),
                  Text(
                    AppStrings.noProjects,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.space),
                  Text(
                    isAdmin
                        ? '新しいプロジェクトを作成するか、\nプロジェクトコードで参加してください'
                        : 'プロジェクトコードで参加してください',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spaceXl),
            _buildBottomActions(context, ref, isAdmin),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    WidgetRef ref,
    bool isAdmin,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // プロジェクト作成ボタン（管理者のみ）
          if (isAdmin) ...[
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeightLg,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showProjectCreationModal(context, ref);
                },
                icon: const Icon(Icons.add),
                label: const Text(AppStrings.createProject),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.6),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.space),
          ],

          // プロジェクトコードで参加ボタン
          SizedBox(
            width: double.infinity,
            height: AppSizes.buttonHeightLg,
            child: OutlinedButton.icon(
              onPressed: () {
                _showJoinProjectDialog(context, ref);
              },
              icon: const Icon(Icons.vpn_key, color: Colors.white),
              label: const Text(
                AppStrings.joinProject,
                style: TextStyle(color: Colors.white),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.6),
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProjectCreationModal(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const ProjectCreationModal(),
    );
  }

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
                    context.go(AppRoutes.taskBoard);
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
}
