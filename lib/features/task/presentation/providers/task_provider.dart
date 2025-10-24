import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../project/presentation/providers/project_provider.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';
import '../../domain/enums/task_status.dart';
import '../../domain/enums/task_category.dart';

/// タスク一覧（選択中プロジェクトの全タスク）- Streamで監視
final tasksProvider = StreamProvider<List<TaskModel>>((ref) {
  final projectId = ref.watch(selectedProjectIdProvider);
  if (projectId == null) {
    return Stream.value([]);
  }

  final repository = ref.read(taskRepositoryProvider);
  return repository.watchTasksByProject(projectId);
});

/// ステータスでフィルタリング
final tasksByStatusProvider = Provider.family<List<TaskModel>, TaskStatus>((
  ref,
  status,
) {
  final tasks = ref.watch(tasksProvider).value ?? [];
  return tasks.where((task) => task.status == status).toList();
});

/// カテゴリでフィルタリング
final tasksByCategoryProvider = Provider.family<List<TaskModel>, TaskCategory?>(
  (ref, category) {
    final tasks = ref.watch(tasksProvider).value ?? [];
    if (category == null) return tasks;
    return tasks.where((task) => task.categories.contains(category)).toList();
  },
);

/// 未着手タスク一覧
final todoTasksProvider = Provider<List<TaskModel>>((ref) {
  return ref.watch(tasksByStatusProvider(TaskStatus.todo));
});

/// 進行中タスク一覧
final inProgressTasksProvider = Provider<List<TaskModel>>((ref) {
  return ref.watch(tasksByStatusProvider(TaskStatus.inProgress));
});

/// 完了タスク一覧
final doneTasksProvider = Provider<List<TaskModel>>((ref) {
  return ref.watch(tasksByStatusProvider(TaskStatus.done));
});

/// タスク作成のローディング状態
final taskCreatingProvider = StateProvider<bool>((ref) => false);

/// タスク更新のローディング状態
final taskUpdatingProvider = StateProvider<bool>((ref) => false);

/// タスク削除のローディング状態
final taskDeletingProvider = StateProvider<bool>((ref) => false);

/// タスクエラーメッセージ
final taskErrorProvider = StateProvider<String?>((ref) => null);
