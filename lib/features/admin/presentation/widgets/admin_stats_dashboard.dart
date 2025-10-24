import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import '../providers/admin_provider.dart';

/// 管理者統計ダッシュボードWidget
class AdminStatsDashboard extends ConsumerWidget {
  const AdminStatsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUsersAsync = ref.watch(allUsersProvider);
    final activeUsersAsync = ref.watch(activeUsersProvider);
    final allProjectsAsync = ref.watch(allProjectsProvider);
    final upcomingTasksAsync = ref.watch(adminUpcomingTasksProvider);
    final overdueTasksAsync = ref.watch(overdueTasksProvider);
    final highPriorityTasksAsync = ref.watch(adminHighPriorityTasksProvider);

    return LiquidGlassContainer(
      margin: const EdgeInsets.all(AppSizes.padding),
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ヘッダー
          Row(
            children: [
              const Icon(Icons.admin_panel_settings, color: AppColors.primary),
              const SizedBox(width: AppSizes.spaceSm),
              Text(
                '管理者ダッシュボード',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceXl),

          // 統計カード
          _buildStatsCards(
            context,
            allUsersAsync,
            activeUsersAsync,
            allProjectsAsync,
            upcomingTasksAsync,
            overdueTasksAsync,
            highPriorityTasksAsync,
          ),
        ],
      ),
    );
  }

  /// 統計カードを構築
  Widget _buildStatsCards(
    BuildContext context,
    AsyncValue allUsers,
    AsyncValue activeUsers,
    AsyncValue allProjects,
    AsyncValue upcomingTasks,
    AsyncValue overdueTasks,
    AsyncValue highPriorityTasks,
  ) {
    return Column(
      children: [
        // 1行目: ユーザー・プロジェクト統計
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                '総ユーザー数',
                allUsers.when(
                  data: (users) => users.length.toString(),
                  loading: () => '-',
                  error: (_, __) => 'エラー',
                ),
                Icons.people,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSizes.spaceSm),
            Expanded(
              child: _buildStatCard(
                context,
                'アクティブユーザー',
                activeUsers.when(
                  data: (users) => users.length.toString(),
                  loading: () => '-',
                  error: (_, __) => 'エラー',
                ),
                Icons.person,
                AppColors.success,
              ),
            ),
            const SizedBox(width: AppSizes.spaceSm),
            Expanded(
              child: _buildStatCard(
                context,
                '総プロジェクト数',
                allProjects.when(
                  data: (projects) => projects.length.toString(),
                  loading: () => '-',
                  error: (_, __) => 'エラー',
                ),
                Icons.folder,
                AppColors.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceMd),

        // 2行目: タスク統計
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                '今週の締切',
                upcomingTasks.when(
                  data: (tasks) => tasks.length.toString(),
                  loading: () => '-',
                  error: (_, __) => 'エラー',
                ),
                Icons.schedule,
                AppColors.priorityLow,
              ),
            ),
            const SizedBox(width: AppSizes.spaceSm),
            Expanded(
              child: _buildStatCard(
                context,
                '期限切れ',
                overdueTasks.when(
                  data: (tasks) => tasks.length.toString(),
                  loading: () => '-',
                  error: (_, __) => 'エラー',
                ),
                Icons.warning,
                AppColors.priorityHigh,
              ),
            ),
            const SizedBox(width: AppSizes.spaceSm),
            Expanded(
              child: _buildStatCard(
                context,
                '高優先度',
                highPriorityTasks.when(
                  data: (tasks) => tasks.length.toString(),
                  loading: () => '-',
                  error: (_, __) => 'エラー',
                ),
                Icons.flag,
                AppColors.priorityMedium,
              ),
            ),
          ],
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
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
