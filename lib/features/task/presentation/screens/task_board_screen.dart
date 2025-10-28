import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../project/presentation/providers/project_provider.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';
import '../providers/task_filter_provider.dart';
import '../widgets/task_board.dart';
import '../widgets/task_bottom_navigation_bar.dart';
import '../../domain/enums/task_category.dart';

/// タスクボード画面（メイン画面）
class TaskBoardScreen extends ConsumerStatefulWidget {
  const TaskBoardScreen({super.key});

  @override
  ConsumerState<TaskBoardScreen> createState() => _TaskBoardScreenState();
}

class _TaskBoardScreenState extends ConsumerState<TaskBoardScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = ref.watch(filteredTasksProvider);
    final selectedProject = ref.watch(selectedProjectProvider).value;
    final currentCategoryFilter = ref.watch(currentCategoryFilterProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(context, ref, selectedProject?.name),
        body: SafeArea(
          child: Column(
            children: [
              // 検索バー
              if (searchQuery.isNotEmpty)
                _buildSearchAndFilterBar(
                  context,
                  ref,
                  searchQuery,
                  currentCategoryFilter,
                ),
              // タスクボード
              Expanded(
                child: Stack(
                  children: [
                    TaskBoard(
                      tasks: filteredTasks,
                      pageController: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
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
                    // ソートボタン（右下）
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: FloatingActionButton(
                        onPressed: () {
                          _showSortDialog(context, ref);
                        },
                        backgroundColor: AppColors.primary,
                        elevation: 2,
                        child: const Icon(Icons.sort, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: TaskBottomNavigationBar(
          currentIndex: _currentIndex,
          onNavItemTapped: _onNavItemTapped,
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
      leading: IconButton(
        icon: const Icon(Icons.settings, color: Colors.white),
        onPressed: () {
          context.go(AppRoutes.settings);
        },
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

  /// ナビゲーションアイテムタップ処理
  void _onNavItemTapped(int index) {
    if (index < 3) {
      // 未着手、進行中、完了のみ
      setState(() {
        _currentIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// カテゴリフィルタダイアログを表示（ソートボタンから）
  void _showSortDialog(BuildContext context, WidgetRef ref) {
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
}
