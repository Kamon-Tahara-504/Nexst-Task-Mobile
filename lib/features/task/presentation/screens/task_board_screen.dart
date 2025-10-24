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
import '../../domain/enums/task_category.dart';
import '../../domain/enums/task_status.dart';

/// タスクボード画面（メイン画面）
class TaskBoardScreen extends ConsumerWidget {
  const TaskBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTasks = ref.watch(filteredTasksProvider);
    final selectedProject = ref.watch(selectedProjectProvider).value;
    final currentUser = ref.watch(currentUserProvider).value;
    final currentCategoryFilter = ref.watch(currentCategoryFilterProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(context, ref, selectedProject?.name),
        drawer: AppDrawer(
          projectName: selectedProject?.name,
          userName: currentUser?.userName,
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
          child: Column(
            children: [
              // 検索バー
              if (searchQuery.isNotEmpty || currentCategoryFilter != null)
                _buildSearchAndFilterBar(
                  context,
                  ref,
                  searchQuery,
                  currentCategoryFilter,
                ),
              // タスクボード
              Expanded(
                child: TaskBoard(
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
                ),
              ),
            ],
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
    final searchQuery = ref.watch(searchQueryProvider);
    final currentCategoryFilter = ref.watch(currentCategoryFilterProvider);
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
        // 検索ボタン
        IconButton(
          icon: Icon(
            searchQuery.isNotEmpty ? Icons.search_off : Icons.search,
            color: searchQuery.isNotEmpty ? AppColors.primary : Colors.white,
          ),
          onPressed: () {
            _showSearchDialog(context, ref, searchQuery);
          },
        ),
        // フィルタ状態表示
        if (currentCategoryFilter != null)
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary, width: 1),
            ),
            child: Text(
              currentCategoryFilter!.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        // フィルタボタン
        IconButton(
          icon: Icon(
            currentCategoryFilter != null
                ? Icons.filter_alt
                : Icons.filter_list,
            color: currentCategoryFilter != null
                ? AppColors.primary
                : Colors.white,
          ),
          onPressed: () {
            _showFilterMenu(context, ref);
          },
        ),
      ],
    );
  }

  /// 検索ダイアログを表示
  void _showSearchDialog(
    BuildContext context,
    WidgetRef ref,
    String currentQuery,
  ) {
    final controller = TextEditingController(text: currentQuery);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('タスクを検索'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'タイトル、説明、担当者名で検索',
            prefixIcon: Icon(Icons.search),
          ),
          autofocus: true,
          onSubmitted: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(searchQueryProvider.notifier).state = '';
              Navigator.pop(context);
            },
            child: const Text('クリア'),
          ),
          TextButton(
            onPressed: () {
              ref.read(searchQueryProvider.notifier).state = controller.text;
              Navigator.pop(context);
            },
            child: const Text('検索'),
          ),
        ],
      ),
    );
  }

  /// 検索・フィルタバーを構築
  Widget _buildSearchAndFilterBar(
    BuildContext context,
    WidgetRef ref,
    String searchQuery,
    TaskCategory? categoryFilter,
  ) {
    return LiquidGlassContainer(
      margin: const EdgeInsets.all(AppSizes.padding),
      padding: const EdgeInsets.all(AppSizes.paddingSm),
      child: Row(
        children: [
          // 検索クエリ表示
          if (searchQuery.isNotEmpty) ...[
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        searchQuery,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ref.read(searchQueryProvider.notifier).state = '';
                      },
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          // カテゴリフィルタ表示
          if (categoryFilter != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.secondary, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.category,
                    size: 16,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    categoryFilter.label,
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      ref.read(currentCategoryFilterProvider.notifier).state =
                          null;
                    },
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
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
            // カテゴリ選択
            ...TaskCategory.values.map((category) {
              final isSelected = currentFilter == category;
              return ListTile(
                title: Text(category.label),
                trailing: isSelected
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  ref.read(currentCategoryFilterProvider.notifier).state =
                      isSelected ? null : category;
                  Navigator.pop(context);
                },
              );
            }).toList(),
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
