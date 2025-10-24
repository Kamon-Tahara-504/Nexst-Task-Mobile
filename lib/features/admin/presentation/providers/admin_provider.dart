import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/admin_repository.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../project/data/models/project_model.dart';
import '../../../task/data/models/task_model.dart';

/// 全ユーザー一覧Provider
final allUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  final repository = ref.read(adminRepositoryProvider);
  return repository.getAllUsers();
});

/// アクティブユーザー一覧Provider
final activeUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  final repository = ref.read(adminRepositoryProvider);
  return repository.getActiveUsers();
});

/// 全プロジェクト一覧Provider
final allProjectsProvider = FutureProvider<List<ProjectModel>>((ref) async {
  final repository = ref.read(adminRepositoryProvider);
  return repository.getAllProjects();
});

/// 締切が近いタスクProvider
final adminUpcomingTasksProvider = FutureProvider<List<TaskModel>>((ref) async {
  final repository = ref.read(adminRepositoryProvider);
  return repository.getUpcomingTasks();
});

/// 期限切れタスクProvider
final overdueTasksProvider = FutureProvider<List<TaskModel>>((ref) async {
  final repository = ref.read(adminRepositoryProvider);
  return repository.getOverdueTasks();
});

/// 高優先度タスクProvider
final adminHighPriorityTasksProvider = FutureProvider<List<TaskModel>>((
  ref,
) async {
  final repository = ref.read(adminRepositoryProvider);
  return repository.getHighPriorityTasks();
});

/// プロジェクトタスク統計Provider
final projectTaskStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final repository = ref.read(adminRepositoryProvider);
  return repository.getProjectTaskStats();
});

/// ユーザータスク統計Provider
final userTaskStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final repository = ref.read(adminRepositoryProvider);
  return repository.getUserTaskStats();
});

/// 管理者操作のローディング状態
final adminLoadingProvider = StateProvider<bool>((ref) => false);

/// 管理者エラーメッセージ
final adminErrorProvider = StateProvider<String?>((ref) => null);
