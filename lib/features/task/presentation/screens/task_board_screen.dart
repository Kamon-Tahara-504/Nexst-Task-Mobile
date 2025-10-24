import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import '../../../../shared/widgets/app_drawer.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../project/presentation/providers/project_provider.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';
import '../providers/task_provider.dart';
import '../providers/task_filter_provider.dart';
import '../widgets/task_board.dart';

/// タスクボード画面（メイン画面）
class TaskBoardScreen extends ConsumerWidget {
  const TaskBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);
    final selectedProject = ref.watch(selectedProjectProvider).value;
    final currentUser = ref.watch(currentUserProvider).value;
    final currentCategoryFilter = ref.watch(currentCategoryFilterProvider);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(context, ref, selectedProject?.name),
        drawer: AppDrawer(
          projectName: selectedProject?.name,
          userName: currentUser?.userName,
          isAdmin: currentUser?.isAdmin ?? false,
          onLogout: () async {
            final logout = ref.read(logoutProvider);
            await logout();
            if (context.mounted) {
              context.go(AppRoutes.login);
            }
          },
          onChangeProject: () async {
            await ref
                .read(selectedProjectIdProvider.notifier)
                .clearSelectedProject();
            if (context.mounted) {
              context.go(AppRoutes.projectSelection);
            }
          },
        ),
        body: SafeArea(
          child: tasksAsync.when(
            data: (tasks) {
              // カテゴリフィルタリング
              final filteredTasks = currentCategoryFilter != null
                  ? tasks
                        .where(
                          (t) => t.categories.contains(currentCategoryFilter),
                        )
                        .toList()
                  : tasks;

              return TaskBoard(
                tasks: filteredTasks,
                onTaskTap: (task) {
                  context.go('/task/${task.id}');
                },
                onTaskToggleStatus: (task) async {
                  await _handleToggleStatus(ref, task);
                },
                onTaskDelete: (task) async {
                  final confirmed = await context.showConfirmDialog(
                    title: AppStrings.confirmDelete,
                    message: '「${task.title}」を削除しますか？',
                  );

                  if (confirmed) {
                    await _handleDeleteTask(ref, task, context);
                  }
                },
              );
            },
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
                      color: Colors.white.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.go('/task/create');
          },
          icon: const Icon(Icons.add),
          label: const Text(AppStrings.createTask),
        ),
      ),
    );
  }

  /// AppBarを構築
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    String? projectName,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      title: Text(
        projectName ?? AppStrings.appName,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // フィルタボタン
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white),
          onPressed: () {
            _showFilterMenu(context, ref);
          },
        ),
      ],
    );
  }

  /// フィルタメニューを表示
  void _showFilterMenu(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.read(currentCategoryFilterProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => LiquidGlassContainer(
        margin: const EdgeInsets.all(AppSizes.padding),
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'カテゴリフィルター',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.space),
            ListTile(
              title: const Text('すべて'),
              trailing: currentFilter == null
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                ref.read(currentCategoryFilterProvider.notifier).state = null;
                Navigator.pop(context);
              },
            ),
            const Divider(),
            // カテゴリ選択は次のフェーズで実装
          ],
        ),
      ),
    );
  }

  /// タスクステータス切り替え処理
  Future<void> _handleToggleStatus(WidgetRef ref, TaskModel task) async {
    try {
      final repository = ref.read(taskRepositoryProvider);
      await repository.updateTaskStatus(task.id, task.nextStatus);
    } catch (e) {
      if (kDebugMode) {
        print('ステータス更新エラー: $e');
      }
    }
  }

  /// タスク削除処理
  Future<void> _handleDeleteTask(
    WidgetRef ref,
    TaskModel task,
    BuildContext context,
  ) async {
    try {
      final repository = ref.read(taskRepositoryProvider);
      await repository.deleteTask(task.id);

      if (context.mounted) {
        context.showSuccessSnackbar('タスクを削除しました');
      }
    } catch (e) {
      if (context.mounted) {
        context.showErrorSnackbar('削除に失敗しました: ${e.toString()}');
      }
    }
  }
}
