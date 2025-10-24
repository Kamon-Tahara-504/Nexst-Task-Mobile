import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../../data/models/task_model.dart';
import '../../domain/enums/task_status.dart';
import '../../domain/enums/task_category.dart';
import '../../domain/enums/priority.dart';
import '../../../../core/utils/date_utils.dart';

/// タスク統計データ
class TaskStats {
  final int totalTasks;
  final int todoTasks;
  final int inProgressTasks;
  final int doneTasks;
  final int overdueTasks;
  final int urgentTasks;
  final int highPriorityTasks;
  final Map<TaskCategory, int> tasksByCategory;
  final Map<Priority, int> tasksByPriority;
  final double completionRate;

  const TaskStats({
    required this.totalTasks,
    required this.todoTasks,
    required this.inProgressTasks,
    required this.doneTasks,
    required this.overdueTasks,
    required this.urgentTasks,
    required this.highPriorityTasks,
    required this.tasksByCategory,
    required this.tasksByPriority,
    required this.completionRate,
  });

  /// 空の統計データ
  static const TaskStats empty = TaskStats(
    totalTasks: 0,
    todoTasks: 0,
    inProgressTasks: 0,
    doneTasks: 0,
    overdueTasks: 0,
    urgentTasks: 0,
    highPriorityTasks: 0,
    tasksByCategory: {},
    tasksByPriority: {},
    completionRate: 0.0,
  );
}

/// タスク統計Provider
final taskStatsProvider = Provider<TaskStats>((ref) {
  final tasks = ref.watch(tasksProvider).value ?? [];

  if (tasks.isEmpty) {
    return TaskStats.empty;
  }

  final now = DateTime.now();

  // 基本統計
  final totalTasks = tasks.length;
  final todoTasks = tasks.where((t) => t.isTodo).length;
  final inProgressTasks = tasks.where((t) => t.isInProgress).length;
  final doneTasks = tasks.where((t) => t.isDone).length;

  // 締切関連統計
  final overdueTasks = tasks
      .where(
        (t) => !t.isDone && AppDateUtils.getDeadlineUrgency(t.deadline) >= 3,
      )
      .length;

  final urgentTasks = tasks
      .where(
        (t) => !t.isDone && AppDateUtils.getDeadlineUrgency(t.deadline) >= 2,
      )
      .length;

  // 優先度統計
  final highPriorityTasks = tasks.where((t) => t.isHighPriority).length;

  // カテゴリ別統計
  final tasksByCategory = <TaskCategory, int>{};
  for (final category in TaskCategory.values) {
    tasksByCategory[category] = tasks
        .where((t) => t.categories.contains(category))
        .length;
  }

  // 優先度別統計
  final tasksByPriority = <Priority, int>{};
  for (final priority in Priority.values) {
    tasksByPriority[priority] = tasks
        .where((t) => t.priority == priority)
        .length;
  }

  // 完了率
  final completionRate = totalTasks > 0 ? (doneTasks / totalTasks) * 100 : 0.0;

  return TaskStats(
    totalTasks: totalTasks,
    todoTasks: todoTasks,
    inProgressTasks: inProgressTasks,
    doneTasks: doneTasks,
    overdueTasks: overdueTasks,
    urgentTasks: urgentTasks,
    highPriorityTasks: highPriorityTasks,
    tasksByCategory: tasksByCategory,
    tasksByPriority: tasksByPriority,
    completionRate: completionRate,
  );
});

/// 締切が近いタスクProvider
final upcomingTasksProvider = Provider<List<TaskModel>>((ref) {
  final tasks = ref.watch(tasksProvider).value ?? [];
  final now = DateTime.now();
  final nextWeek = now.add(const Duration(days: 7));

  return tasks.where((task) {
    if (task.isDone) return false;

    final deadline = task.deadline;
    return deadline.isAfter(now) && deadline.isBefore(nextWeek);
  }).toList()..sort((a, b) => a.deadline.compareTo(b.deadline));
});

/// 期限切れタスクProvider
final overdueTasksProvider = Provider<List<TaskModel>>((ref) {
  final tasks = ref.watch(tasksProvider).value ?? [];
  final now = DateTime.now();

  return tasks.where((task) {
    if (task.isDone) return false;
    return task.deadline.isBefore(now);
  }).toList()..sort((a, b) => a.deadline.compareTo(b.deadline));
});

/// 高優先度タスクProvider
final highPriorityTasksProvider = Provider<List<TaskModel>>((ref) {
  final tasks = ref.watch(tasksProvider).value ?? [];

  return tasks.where((task) => task.isHighPriority && !task.isDone).toList()
    ..sort((a, b) => a.deadline.compareTo(b.deadline));
});
