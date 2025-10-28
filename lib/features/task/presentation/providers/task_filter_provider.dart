import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/enums/task_category.dart';
import '../providers/task_provider.dart';
import '../../data/models/task_model.dart';

/// 現在のカテゴリフィルタ（初期値: Solo Task）
final currentCategoryFilterProvider = StateProvider<TaskCategory?>(
  (ref) => TaskCategory.solo,
);

/// 検索クエリ
final searchQueryProvider = StateProvider<String>((ref) => '');

/// フィルタリングされたタスク（カテゴリ＋検索）
final filteredTasksProvider = Provider<List<TaskModel>>((ref) {
  final tasks = ref.watch(tasksProvider).value ?? [];
  final categoryFilter = ref.watch(currentCategoryFilterProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  var filteredTasks = tasks;

  // カテゴリフィルタリング（初期値Solo Taskが設定されているため常にフィルタリング）
  filteredTasks = filteredTasks
      .where((task) => task.categories.contains(categoryFilter))
      .toList();

  // 検索クエリフィルタリング
  if (searchQuery.isNotEmpty) {
    final query = searchQuery.toLowerCase();
    filteredTasks = filteredTasks.where((task) {
      return task.title.toLowerCase().contains(query) ||
          task.oneLine.toLowerCase().contains(query) ||
          task.memo.toLowerCase().contains(query) ||
          task.createdByName.toLowerCase().contains(query) ||
          task.assignedToName.toLowerCase().contains(query);
    }).toList();
  }

  return filteredTasks;
});
