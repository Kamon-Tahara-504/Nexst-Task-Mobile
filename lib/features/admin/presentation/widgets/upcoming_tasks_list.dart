import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import '../../../task/data/models/task_model.dart';
import '../../../task/domain/enums/task_status.dart';
import '../../../task/domain/enums/priority.dart';
import '../providers/admin_provider.dart';

/// 締切が近いタスク一覧Widget
class UpcomingTasksList extends ConsumerWidget {
  final bool isOverdue;
  final bool isHighPriority;

  const UpcomingTasksList({
    super.key,
    this.isOverdue = false,
    this.isHighPriority = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = _getTasksProvider(ref);

    return tasksAsync.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return _buildEmptyState();
        }
        return _buildTasksList(tasks);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(error),
    );
  }

  /// 適切なProviderを取得
  AsyncValue<List<TaskModel>> _getTasksProvider(WidgetRef ref) {
    if (isOverdue) {
      return ref.watch(overdueTasksProvider);
    } else if (isHighPriority) {
      return ref.watch(adminHighPriorityTasksProvider);
    } else {
      return ref.watch(adminUpcomingTasksProvider);
    }
  }

  /// タスク一覧を構築
  Widget _buildTasksList(List<TaskModel> tasks) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.padding),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(context, task);
      },
    );
  }

  /// タスクカードを構築
  Widget _buildTaskCard(BuildContext context, TaskModel task) {
    return LiquidGlassContainer(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceMd),
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ヘッダー: タイトル + ステータス
          Row(
            children: [
              // アイコン
              if (task.hasIcon) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    border: Border.all(color: AppColors.primary, width: 1),
                  ),
                  child: const Icon(
                    Icons.task_alt,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSizes.spaceSm),
              ],
              // タイトル
              Expanded(
                child: Text(
                  task.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // ステータスバッジ
              _buildStatusBadge(task.status),
            ],
          ),
          const SizedBox(height: AppSizes.spaceMd),
          // 詳細情報
          Row(
            children: [
              _buildPriorityBadge(task.priority),
              const SizedBox(width: AppSizes.spaceSm),
              _buildDeadlineBadge(task.deadline),
              const SizedBox(width: AppSizes.spaceSm),
              if (task.categories.isNotEmpty)
                _buildCategoryBadge(task.categories.first),
            ],
          ),
          const SizedBox(height: AppSizes.spaceMd),
          // 担当者・作成者情報
          Row(
            children: [
              Expanded(
                child: _buildUserInfo('担当者', task.assignedToName, Icons.person),
              ),
              const SizedBox(width: AppSizes.spaceMd),
              Expanded(
                child: _buildUserInfo(
                  '作成者',
                  task.createdByName,
                  Icons.person_add,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceMd),
          // 日付情報
          Row(
            children: [
              Expanded(
                child: _buildDateInfo(
                  '作成日',
                  AppDateUtils.formatDate(task.createdAt),
                ),
              ),
              const SizedBox(width: AppSizes.spaceMd),
              Expanded(
                child: _buildDateInfo(
                  '締切',
                  AppDateUtils.formatDate(task.deadline),
                ),
              ),
            ],
          ),
          // 一行説明（あれば表示）
          if (task.hasOneLine) ...[
            const SizedBox(height: AppSizes.spaceMd),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.paddingSm),
              decoration: BoxDecoration(
                color: AppColors.glassBackground.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                border: Border.all(color: AppColors.glassBorder, width: 1),
              ),
              child: Text(
                task.oneLine,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// ステータスバッジを構築
  Widget _buildStatusBadge(TaskStatus status) {
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
          fontSize: AppSizes.fontXs,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  /// 優先度バッジを構築
  Widget _buildPriorityBadge(Priority priority) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm,
        vertical: AppSizes.paddingXs,
      ),
      decoration: BoxDecoration(
        color: priority.lightColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: priority.color, width: 1),
      ),
      child: Text(
        priority.label,
        style: TextStyle(
          fontSize: AppSizes.fontXs,
          fontWeight: FontWeight.bold,
          color: priority.darkColor,
        ),
      ),
    );
  }

  /// 締切バッジを構築
  Widget _buildDeadlineBadge(DateTime deadline) {
    final urgency = AppDateUtils.getDeadlineUrgency(deadline);
    final status = AppDateUtils.getDeadlineStatus(deadline);

    Color backgroundColor;
    Color textColor;
    Color borderColor;

    if (urgency >= 3) {
      // 期限切れ
      backgroundColor = AppColors.deadlineOverdue;
      textColor = AppColors.deadlineOverdueText;
      borderColor = AppColors.deadlineOverdueBorder;
    } else if (urgency >= 2) {
      // 緊急
      backgroundColor = AppColors.deadlineUrgent;
      textColor = AppColors.deadlineUrgentText;
      borderColor = AppColors.deadlineUrgentBorder;
    } else if (urgency >= 1) {
      // 注意
      backgroundColor = AppColors.deadlineWarning;
      textColor = AppColors.deadlineWarningText;
      borderColor = AppColors.deadlineWarningBorder;
    } else {
      // 安全
      backgroundColor = AppColors.deadlineSafe;
      textColor = AppColors.deadlineSafeText;
      borderColor = AppColors.deadlineSafeBorder;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm,
        vertical: AppSizes.paddingXs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: AppSizes.fontXs,
          fontWeight: urgency >= 2 ? FontWeight.bold : FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  /// カテゴリバッジを構築
  Widget _buildCategoryBadge(dynamic category) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm,
        vertical: AppSizes.paddingXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.categoryBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: AppColors.categoryBorder, width: 1),
      ),
      child: Text(
        '#${category.label}',
        style: const TextStyle(
          fontSize: AppSizes.fontXs,
          color: AppColors.categoryText,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// ユーザー情報を構築
  Widget _buildUserInfo(String label, String name, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingSm),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: AppSizes.spaceXs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppSizes.fontXs,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: AppSizes.fontXs,
                    color: AppColors.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 日付情報を構築
  Widget _buildDateInfo(String label, String date) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingSm),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppSizes.fontXs,
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: AppSizes.fontXs,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 空状態を構築
  Widget _buildEmptyState() {
    String title;
    String message;
    IconData icon;

    if (isOverdue) {
      title = '期限切れタスクはありません';
      message = 'すべてのタスクが期限内に完了されています';
      icon = Icons.check_circle_outline;
    } else if (isHighPriority) {
      title = '高優先度タスクはありません';
      message = '現在、高優先度のタスクはありません';
      icon = Icons.flag_outlined;
    } else {
      title = '今週の締切タスクはありません';
      message = '今週締切のタスクはありません';
      icon = Icons.schedule;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.white),
          const SizedBox(height: AppSizes.spaceXl),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSizes.space),
          Text(
            message,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// エラー状態を構築
  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.white),
          const SizedBox(height: AppSizes.spaceXl),
          const Text(
            'エラーが発生しました',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSizes.space),
          Text(
            error.toString(),
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
