import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../shared/widgets/icon_selector.dart';
import '../../data/models/task_model.dart';
import '../../domain/enums/task_status.dart';
import 'priority_badge.dart';
import 'deadline_tag.dart';

/// タスクカードWidget
class TaskCard extends ConsumerWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleStatus;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onToggleStatus,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 締切による枠線の色
    final urgency = AppDateUtils.getDeadlineUrgency(task.deadline);
    Color borderColor;

    if (task.isDone) {
      borderColor = AppColors.glassBorder;
    } else {
      switch (urgency) {
        case 3: // 期限切れ
        case 2: // 緊急
          borderColor = AppColors.deadlineUrgentBorder;
          break;
        case 1: // 注意
          borderColor = AppColors.deadlineWarningBorder;
          break;
        default: // 安全
          borderColor = AppColors.glassBorder;
      }
    }

    Widget cardContent = Container(
      padding: const EdgeInsets.all(AppSizes.padding),
      decoration: BoxDecoration(
        color: Colors.white, // タスクカードは白い背景
        borderRadius: BorderRadius.circular(AppSizes.radiusLiquidGlass),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLiquidGlass),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1列目: タイトル + アイコン + ステータスボタン
            Row(
              children: [
                // アイコン
                if (task.hasIcon) ...[
                  IconPreview(iconName: task.icon, size: AppSizes.iconSm),
                  const SizedBox(width: AppSizes.spaceSm),
                ],

                // タイトル
                Expanded(
                  child: Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary, // 白い背景に適した色
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(width: AppSizes.spaceSm),

                // ステータスボタン
                _buildStatusButton(context),
              ],
            ),

            const SizedBox(height: AppSizes.spaceMd),

            // 2列目: 優先度 + カテゴリタグ + 締切タグ
            Wrap(
              spacing: AppSizes.spaceSm,
              runSpacing: AppSizes.spaceXs,
              children: [
                PriorityBadge(priority: task.priority),
                _buildCategoryTag(context),
                if (!task.isDone) DeadlineTag(deadline: task.deadline),
              ],
            ),

            const SizedBox(height: AppSizes.spaceMd),

            // 3列目: 作成者 / 担当者
            Text(
              '作成: ${task.createdByName} / 担当: ${task.assignedToName}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),

            const SizedBox(height: AppSizes.spaceXs),

            // 4列目: 日付
            Text(
              '作成日: ${AppDateUtils.formatDate(task.createdAt)} / 締切: ${AppDateUtils.formatDate(task.deadline)}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),

            // 一行メモ（あれば表示）
            if (task.hasOneLine) ...[
              const SizedBox(height: AppSizes.spaceMd),
              Text(
                task.oneLine,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary, // 白い背景に適した色
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.taskSpacing),
      child: cardContent,
    );
  }

  /// ステータスボタンを構築
  Widget _buildStatusButton(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (task.status) {
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

    return InkWell(
      onTap: onToggleStatus,
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingSm,
          vertical: AppSizes.paddingXs,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
        child: Text(
          task.status.label,
          style: TextStyle(
            fontSize: AppSizes.fontXs,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  /// カテゴリタグを構築
  Widget _buildCategoryTag(BuildContext context) {
    if (task.categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm,
        vertical: AppSizes.paddingXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.categoryBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: AppColors.categoryBorder, width: 1.0),
      ),
      child: Text(
        '#${task.categories.first.label}',
        style: const TextStyle(
          fontSize: AppSizes.fontXs,
          color: AppColors.categoryText,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
