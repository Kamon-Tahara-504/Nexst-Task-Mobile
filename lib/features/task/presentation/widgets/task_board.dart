import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import '../../data/models/task_model.dart';
import '../../domain/enums/task_status.dart';
import 'task_card.dart';

/// タスクボード（カンバン形式）Widget
class TaskBoard extends ConsumerWidget {
  final List<TaskModel> tasks;
  final Function(TaskModel)? onTaskTap;
  final Function(TaskModel)? onTaskToggleStatus;
  final Function(TaskModel)? onTaskDelete;

  const TaskBoard({
    super.key,
    required this.tasks,
    this.onTaskTap,
    this.onTaskToggleStatus,
    this.onTaskDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ステータスごとにタスクを分類
    final todoTasks = tasks.where((t) => t.isTodo).toList();
    final inProgressTasks = tasks.where((t) => t.isInProgress).toList();
    final doneTasks = tasks.where((t) => t.isDone).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        // モバイル（縦スクロール）かタブレット以上（横スクロール）か判定
        final isMobile = constraints.maxWidth < 600;

        if (isMobile) {
          // モバイル: 縦スクロール（タブで切り替え）
          return _buildMobileLayout(
            context,
            todoTasks,
            inProgressTasks,
            doneTasks,
          );
        } else {
          // タブレット以上: 横3カラム
          return _buildTabletLayout(
            context,
            todoTasks,
            inProgressTasks,
            doneTasks,
          );
        }
      },
    );
  }

  /// モバイルレイアウト（タブ切り替え）
  Widget _buildMobileLayout(
    BuildContext context,
    List<TaskModel> todoTasks,
    List<TaskModel> inProgressTasks,
    List<TaskModel> doneTasks,
  ) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          LiquidGlassContainer(
            margin: const EdgeInsets.all(AppSizes.padding),
            padding: const EdgeInsets.all(AppSizes.paddingXs),
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.6),
              indicator: BoxDecoration(
                color: AppColors.primary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              tabs: [
                Tab(text: '未着手 (${todoTasks.length})'),
                Tab(text: '進行中 (${inProgressTasks.length})'),
                Tab(text: '完了 (${doneTasks.length})'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildTaskColumn(context, TaskStatus.todo, todoTasks),
                _buildTaskColumn(
                  context,
                  TaskStatus.inProgress,
                  inProgressTasks,
                ),
                _buildTaskColumn(context, TaskStatus.done, doneTasks),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// タブレットレイアウト（3カラム）
  Widget _buildTabletLayout(
    BuildContext context,
    List<TaskModel> todoTasks,
    List<TaskModel> inProgressTasks,
    List<TaskModel> doneTasks,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildTaskColumn(context, TaskStatus.todo, todoTasks)),
        const SizedBox(width: AppSizes.columnGap),
        Expanded(
          child: _buildTaskColumn(
            context,
            TaskStatus.inProgress,
            inProgressTasks,
          ),
        ),
        const SizedBox(width: AppSizes.columnGap),
        Expanded(child: _buildTaskColumn(context, TaskStatus.done, doneTasks)),
      ],
    );
  }

  /// タスクカラムを構築
  Widget _buildTaskColumn(
    BuildContext context,
    TaskStatus status,
    List<TaskModel> columnTasks,
  ) {
    return _buildTaskColumnContent(
      context,
      status,
      columnTasks,
      false, // ドラッグハイライトを無効化
    );
  }

  /// タスクカラムの内容を構築
  Widget _buildTaskColumnContent(
    BuildContext context,
    TaskStatus status,
    List<TaskModel> columnTasks,
    bool isHighlighted,
  ) {
    // 締切別の件数を計算
    final deadlineCounts = _getDeadlineCounts(columnTasks);

    return LiquidGlassContainer(
      margin: const EdgeInsets.all(AppSizes.paddingSm),
      padding: const EdgeInsets.all(AppSizes.columnPadding),
      opacity: 0.3, // ログイン画面と同じ透明度に統一
      borderColor: AppColors.glassBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ヘッダー
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                status.label,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '(${columnTasks.length})',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          // 締切別件数表示（完了カラム以外）
          if (columnTasks.isNotEmpty && !status.isDone) ...[
            const SizedBox(height: AppSizes.spaceXs),
            _buildDeadlineCountIndicators(deadlineCounts),
          ],

          const SizedBox(height: AppSizes.space),

          // タスクリスト
          Expanded(
            child: columnTasks.isEmpty
                ? _buildEmptyColumn(context)
                : ListView.builder(
                    itemCount: columnTasks.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        task: columnTasks[index],
                        onTap: () => onTaskTap?.call(columnTasks[index]),
                        onToggleStatus: () =>
                            onTaskToggleStatus?.call(columnTasks[index]),
                        onDelete: () => onTaskDelete?.call(columnTasks[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// 空のカラムを構築
  Widget _buildEmptyColumn(BuildContext context) {
    return Center(
      child: Text(
        'タスクなし',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
      ),
    );
  }

  /// 締切別件数インジケーター
  Widget _buildDeadlineCountIndicators(Map<String, int> counts) {
    return Wrap(
      spacing: AppSizes.spaceXs,
      children: [
        if (counts['safe']! > 0)
          _buildCountBadge('安全', counts['safe']!, AppColors.priorityLow),
        if (counts['warning']! > 0)
          _buildCountBadge('注意', counts['warning']!, AppColors.priorityMedium),
        if (counts['urgent']! > 0)
          _buildCountBadge('緊急', counts['urgent']!, AppColors.priorityHigh),
      ],
    );
  }

  /// 件数バッジを構築
  Widget _buildCountBadge(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingXs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
              child: Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSizes.fontXs,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// 締切別の件数を計算
  Map<String, int> _getDeadlineCounts(List<TaskModel> tasks) {
    int safe = 0;
    int warning = 0;
    int urgent = 0;

    for (final task in tasks) {
      final urgency = AppDateUtils.getDeadlineUrgency(task.deadline);
      switch (urgency) {
        case 0: // 安全
          safe++;
          break;
        case 1: // 注意
          warning++;
          break;
        case 2: // 緊急
        case 3: // 期限切れ
          urgent++;
          break;
      }
    }

    return {'safe': safe, 'warning': warning, 'urgent': urgent};
  }
}

/// TaskStatus拡張
extension TaskStatusX on TaskStatus {
  bool get isDone => this == TaskStatus.done;
}
