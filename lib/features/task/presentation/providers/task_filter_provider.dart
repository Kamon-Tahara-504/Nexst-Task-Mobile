import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/enums/task_category.dart';

/// 現在のカテゴリフィルタ
final currentCategoryFilterProvider = StateProvider<TaskCategory?>(
  (ref) => null,
);

/// 検索クエリ
final searchQueryProvider = StateProvider<String>((ref) => '');

/// フィルタリングされたタスク（カテゴリ＋検索）
///
/// 実際の使用例：
/// ```dart
/// final filteredTasks = ref.watch(filteredTasksProvider);
/// ```
final filteredTasksProvider = Provider((ref) {
  // 実装はtask_providerで行う
  // ここでは基本的なフィルタ状態のみを管理
});
