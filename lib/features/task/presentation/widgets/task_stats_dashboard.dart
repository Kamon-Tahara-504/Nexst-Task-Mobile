import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import '../providers/task_stats_provider.dart';
import '../../domain/enums/task_status.dart';
import '../../domain/enums/task_category.dart';
import '../../domain/enums/priority.dart';

/// タスク統計ダッシュボードWidget
class TaskStatsDashboard extends ConsumerWidget {
  const TaskStatsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(taskStatsProvider);
    final upcomingTasks = ref.watch(upcomingTasksProvider);
    final overdueTasks = ref.watch(overdueTasksProvider);
    final highPriorityTasks = ref.watch(highPriorityTasksProvider);

    return LiquidGlassContainer(
      margin: const EdgeInsets.all(AppSizes.padding),
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ヘッダー
          Row(
            children: [
              const Icon(Icons.analytics, color: AppColors.primary),
              const SizedBox(width: AppSizes.spaceSm),
              Text(
                'タスク統計',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceXl),

          // 基本統計カード
          _buildBasicStatsCards(context, stats),
          const SizedBox(height: AppSizes.spaceXl),

          // 進捗率
          _buildCompletionRate(context, stats),
          const SizedBox(height: AppSizes.spaceXl),

          // 緊急タスク
          if (overdueTasks.isNotEmpty || highPriorityTasks.isNotEmpty)
            _buildUrgentTasks(context, overdueTasks, highPriorityTasks),

          if (overdueTasks.isNotEmpty || highPriorityTasks.isNotEmpty)
            const SizedBox(height: AppSizes.spaceXl),

          // 締切が近いタスク
          if (upcomingTasks.isNotEmpty)
            _buildUpcomingTasks(context, upcomingTasks),
        ],
      ),
    );
  }

  /// 基本統計カードを構築
  Widget _buildBasicStatsCards(BuildContext context, TaskStats stats) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            '総タスク',
            stats.totalTasks.toString(),
            Icons.task_alt,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSizes.spaceSm),
        Expanded(
          child: _buildStatCard(
            context,
            '完了',
            stats.doneTasks.toString(),
            Icons.check_circle,
            AppColors.statusDone,
          ),
        ),
        const SizedBox(width: AppSizes.spaceSm),
        Expanded(
          child: _buildStatCard(
            context,
            '進行中',
            stats.inProgressTasks.toString(),
            Icons.play_circle,
            AppColors.statusInProgress,
          ),
        ),
        const SizedBox(width: AppSizes.spaceSm),
        Expanded(
          child: _buildStatCard(
            context,
            '未着手',
            stats.todoTasks.toString(),
            Icons.radio_button_unchecked,
            AppColors.statusTodo,
          ),
        ),
      ],
    );
  }

  /// 統計カードを構築
  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingSm),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppSizes.spaceXs),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  /// 完了率を構築
  Widget _buildCompletionRate(BuildContext context, TaskStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '完了率',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSizes.spaceSm),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: stats.completionRate / 100,
                backgroundColor: AppColors.glassBorder,
                valueColor: AlwaysStoppedAnimation<Color>(
                  stats.completionRate >= 80
                      ? AppColors.statusDone
                      : stats.completionRate >= 50
                      ? AppColors.statusInProgress
                      : AppColors.statusTodo,
                ),
              ),
            ),
            const SizedBox(width: AppSizes.spaceSm),
            Text(
              '${stats.completionRate.toStringAsFixed(1)}%',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  /// 緊急タスクを構築
  Widget _buildUrgentTasks(
    BuildContext context,
    List<dynamic> overdueTasks,
    List<dynamic> highPriorityTasks,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '緊急タスク',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSizes.spaceSm),
        Row(
          children: [
            if (overdueTasks.isNotEmpty)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.paddingSm),
                  decoration: BoxDecoration(
                    color: AppColors.priorityHigh.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    border: Border.all(color: AppColors.priorityHigh, width: 1),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.warning, color: AppColors.priorityHigh),
                      const SizedBox(height: AppSizes.spaceXs),
                      Text(
                        overdueTasks.length.toString(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.priorityHigh,
                        ),
                      ),
                      Text(
                        '期限切れ',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.priorityHigh,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (overdueTasks.isNotEmpty && highPriorityTasks.isNotEmpty)
              const SizedBox(width: AppSizes.spaceSm),
            if (highPriorityTasks.isNotEmpty)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.paddingSm),
                  decoration: BoxDecoration(
                    color: AppColors.priorityMedium.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    border: Border.all(
                      color: AppColors.priorityMedium,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.flag, color: AppColors.priorityMedium),
                      const SizedBox(height: AppSizes.spaceXs),
                      Text(
                        highPriorityTasks.length.toString(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.priorityMedium,
                        ),
                      ),
                      Text(
                        '高優先度',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.priorityMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  /// 締切が近いタスクを構築
  Widget _buildUpcomingTasks(
    BuildContext context,
    List<dynamic> upcomingTasks,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '今週の締切',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSizes.spaceSm),
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingSm),
          decoration: BoxDecoration(
            color: AppColors.priorityLow.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            border: Border.all(color: AppColors.priorityLow, width: 1),
          ),
          child: Row(
            children: [
              const Icon(Icons.schedule, color: AppColors.priorityLow),
              const SizedBox(width: AppSizes.spaceSm),
              Text(
                '${upcomingTasks.length}件のタスクが今週締切です',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.priorityLow,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
