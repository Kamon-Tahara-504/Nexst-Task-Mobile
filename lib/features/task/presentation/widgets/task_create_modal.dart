import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import '../../../project/presentation/providers/project_provider.dart';
import '../../data/repositories/task_repository.dart';
import 'task_form.dart';

/// タスク作成モーダル
class TaskCreateModal {
  /// モーダルを表示
  static Future<void> show(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) =>
            _TaskCreateModalContent(scrollController: scrollController),
      ),
    );
  }
}

/// タスク作成モーダルのコンテンツ
class _TaskCreateModalContent extends ConsumerStatefulWidget {
  final ScrollController scrollController;

  const _TaskCreateModalContent({required this.scrollController});

  @override
  ConsumerState<_TaskCreateModalContent> createState() =>
      _TaskCreateModalContentState();
}

class _TaskCreateModalContentState
    extends ConsumerState<_TaskCreateModalContent> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final selectedProject = ref.watch(selectedProjectProvider).value;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppSizes.radiusLiquidGlass),
        topRight: Radius.circular(AppSizes.radiusLiquidGlass),
      ),
      child: LiquidGlassContainer(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        borderRadius: 0,
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0.95),
                Colors.white.withOpacity(0.90),
                Colors.white.withOpacity(0.85),
              ],
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ドラッグハンドル
                Container(
                  margin: const EdgeInsets.only(top: AppSizes.paddingSm),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // ヘッダー
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.padding,
                    vertical: AppSizes.paddingSm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.createTask,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.textPrimary,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                // コンテンツ
                Expanded(
                  child: selectedProject == null
                      ? _buildNoProjectSelected()
                      : _buildTaskForm(
                          scrollController: widget.scrollController,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// プロジェクト未選択時の表示
  Widget _buildNoProjectSelected() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_off, size: 80, color: AppColors.textSecondary),
            const SizedBox(height: AppSizes.spaceXl),
            Text(
              'プロジェクトが選択されていません',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.space),
            Text(
              'プロジェクトを選択してからタスクを作成してください',
              style: TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// タスクフォームを構築
  Widget _buildTaskForm({required ScrollController scrollController}) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(AppSizes.padding),
      child: TaskForm(isLoading: _isLoading, onSubmit: _handleCreateTask),
    );
  }

  /// タスク作成処理
  Future<void> _handleCreateTask(TaskFormData formData) async {
    final selectedProject = ref.read(selectedProjectProvider).value;
    if (selectedProject == null) {
      context.showErrorSnackbar('プロジェクトが選択されていません');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final repository = ref.read(taskRepositoryProvider);

      await repository.createTask(
        title: formData.title,
        assignedToId: formData.assignedToId,
        deadline: formData.deadline,
        projectId: selectedProject.id,
        status: formData.status,
        priority: formData.priority,
        categories: formData.categories,
        icon: formData.icon,
        oneLine: formData.oneLine,
        memo: formData.memo,
        relatedUrl: formData.relatedUrl,
      );

      if (mounted) {
        context.showSuccessSnackbar('タスクを作成しました');
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackbar('タスクの作成に失敗しました: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
