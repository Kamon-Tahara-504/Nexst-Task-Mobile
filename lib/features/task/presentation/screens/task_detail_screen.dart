import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/icon_selector.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';
import '../../domain/enums/task_status.dart';
import '../providers/task_provider.dart';
import '../widgets/priority_badge.dart';
import '../widgets/deadline_tag.dart';
import '../widgets/task_form.dart';

/// タスク詳細画面
class TaskDetailScreen extends ConsumerStatefulWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  bool _isLoading = false;
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(),
        body: SafeArea(child: _buildBody()),
      ),
    );
  }

  /// AppBarを構築
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'タスク詳細',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        if (!_isEditing) ...[
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              setState(() {
                _isEditing = true;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: _handleDeleteTask,
          ),
        ],
      ],
    );
  }

  /// ボディを構築
  Widget _buildBody() {
    return FutureBuilder<TaskModel?>(
      future: _getTask(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.white),
                const SizedBox(height: 16),
                Text(
                  'エラーが発生しました',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final task = snapshot.data;
        if (task == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.task_alt, size: 64, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'タスクが見つかりません',
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

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: _isEditing ? _buildEditForm(task) : _buildDetailView(task),
        );
      },
    );
  }

  /// タスクを取得
  Future<TaskModel?> _getTask() async {
    final repository = ref.read(taskRepositoryProvider);
    return repository.getTaskById(widget.taskId);
  }

  /// 詳細表示を構築
  Widget _buildDetailView(TaskModel task) {
    return LiquidGlassContainer(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ヘッダー: タイトル + アイコン
          Row(
            children: [
              if (task.hasIcon) ...[
                IconPreview(iconName: task.icon, size: AppSizes.iconLg),
                const SizedBox(width: AppSizes.space),
              ],
              Expanded(
                child: Text(
                  task.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spaceXl),

          // ステータス・優先度・締切
          Wrap(
            spacing: AppSizes.spaceSm,
            runSpacing: AppSizes.spaceSm,
            children: [
              _buildStatusChip(task.status),
              PriorityBadge(priority: task.priority),
              if (!task.isDone) DeadlineTag(deadline: task.deadline),
            ],
          ),

          const SizedBox(height: AppSizes.spaceXl),

          // カテゴリ
          if (task.categories.isNotEmpty) ...[
            _buildSectionTitle('カテゴリ'),
            const SizedBox(height: AppSizes.spaceSm),
            Wrap(
              spacing: AppSizes.spaceXs,
              children: task.categories.map((category) {
                return Chip(
                  label: Text(category.label),
                  backgroundColor: AppColors.categoryBackground,
                );
              }).toList(),
            ),
            const SizedBox(height: AppSizes.spaceXl),
          ],

          // 一行説明
          if (task.hasOneLine) ...[
            _buildSectionTitle('概要'),
            const SizedBox(height: AppSizes.spaceSm),
            Text(task.oneLine, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: AppSizes.spaceXl),
          ],

          // 詳細メモ
          if (task.hasMemo) ...[
            _buildSectionTitle('詳細'),
            const SizedBox(height: AppSizes.spaceSm),
            Text(task.memo, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSizes.spaceXl),
          ],

          // 関連URL
          if (task.hasRelatedUrl) ...[
            _buildSectionTitle('関連URL'),
            const SizedBox(height: AppSizes.spaceSm),
            InkWell(
              onTap: () {
                // TODO: URLを開く
                context.showSnackbar('URLを開く機能（今後実装）');
              },
              child: Text(
                task.relatedUrl!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceXl),
          ],

          // 担当者・作成者情報
          _buildSectionTitle('担当者・作成者'),
          const SizedBox(height: AppSizes.spaceSm),
          _buildUserInfo(task),

          const SizedBox(height: AppSizes.spaceXl),

          // 日付情報
          _buildSectionTitle('日付情報'),
          const SizedBox(height: AppSizes.spaceSm),
          _buildDateInfo(task),
        ],
      ),
    );
  }

  /// 編集フォームを構築
  Widget _buildEditForm(TaskModel task) {
    return TaskForm(
      initialTask: task,
      isLoading: _isLoading,
      onSubmit: (formData) => _handleUpdateTask(task, formData),
    );
  }

  /// セクションタイトルを構築
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  /// ステータスチップを構築
  Widget _buildStatusChip(TaskStatus status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case TaskStatus.todo:
        backgroundColor = AppColors.statusTodo;
        textColor = AppColors.statusTodoText;
        break;
      case TaskStatus.inProgress:
        backgroundColor = AppColors.statusInProgress;
        textColor = AppColors.statusInProgressText;
        break;
      case TaskStatus.done:
        backgroundColor = AppColors.statusDone;
        textColor = AppColors.statusDoneText;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm,
        vertical: AppSizes.paddingXs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: AppSizes.fontSm,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  /// ユーザー情報を構築
  Widget _buildUserInfo(TaskModel task) {
    return Column(
      children: [
        _buildInfoRow('作成者', task.createdByName),
        const SizedBox(height: AppSizes.spaceXs),
        _buildInfoRow('担当者', task.assignedToName),
      ],
    );
  }

  /// 日付情報を構築
  Widget _buildDateInfo(TaskModel task) {
    return Column(
      children: [
        _buildInfoRow('作成日', AppDateUtils.formatDate(task.createdAt)),
        const SizedBox(height: AppSizes.spaceXs),
        _buildInfoRow('更新日', AppDateUtils.formatDate(task.updatedAt)),
        const SizedBox(height: AppSizes.spaceXs),
        _buildInfoRow('締切', AppDateUtils.formatDate(task.deadline)),
      ],
    );
  }

  /// 情報行を構築
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  /// タスク更新処理
  Future<void> _handleUpdateTask(TaskModel task, TaskFormData formData) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final repository = ref.read(taskRepositoryProvider);

      await repository.updateTask(task.id, {
        'title': formData.title,
        'task_status': formData.status.value,
        'priority': formData.priority.value,
        'task_category': formData.categories.map((c) => c.value).toList(),
        'icon': formData.icon,
        'assigned_to': formData.assignedToId,
        'deadline': formData.deadline.toIso8601String(),
        'one_line': formData.oneLine,
        'memo': formData.memo,
        'related_url': formData.relatedUrl,
      });

      if (mounted) {
        context.showSuccessSnackbar('タスクを更新しました');
        setState(() {
          _isEditing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackbar('タスクの更新に失敗しました: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// タスク削除処理
  Future<void> _handleDeleteTask() async {
    final confirmed = await context.showConfirmDialog(
      title: AppStrings.confirmDelete,
      message: 'このタスクを削除しますか？',
    );

    if (!confirmed) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final repository = ref.read(taskRepositoryProvider);
      await repository.deleteTask(widget.taskId);

      if (mounted) {
        context.showSuccessSnackbar('タスクを削除しました');
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackbar('タスクの削除に失敗しました: ${e.toString()}');
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
