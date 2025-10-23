import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../auth/data/providers/supabase_provider.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../models/task_model.dart';
import '../../domain/enums/task_status.dart';
import '../../domain/enums/task_category.dart';
import '../../domain/enums/priority.dart';

/// タスクリポジトリのProvider
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final authRepository = ref.read(authRepositoryProvider);
  return TaskRepository(supabase, authRepository);
});

/// タスク操作を管理するリポジトリ
class TaskRepository {
  final SupabaseClient _supabase;
  final AuthRepository _authRepository;

  TaskRepository(this._supabase, this._authRepository);

  /// プロジェクトIDに基づいてタスクをストリームで監視
  Stream<List<TaskModel>> watchTasksByProject(String projectId) {
    return _supabase
        .from('task')
        .stream(primaryKey: ['id'])
        .eq('project_id', projectId)
        .order('created_at', ascending: false)
        .asyncMap((data) async {
          return await _tasksWithUserNames(
            data.map((json) => TaskModel.fromJson(json)).toList(),
          );
        });
  }

  /// プロジェクトIDに基づいてタスクを取得
  Future<List<TaskModel>> getTasksByProject(String projectId) async {
    try {
      final response = await _supabase
          .from('task')
          .select()
          .eq('project_id', projectId)
          .order('created_at', ascending: false);

      final tasks = (response as List)
          .map((json) => TaskModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return await _tasksWithUserNames(tasks);
    } catch (e) {
      if (kDebugMode) {
        print('タスク取得エラー: $e');
      }
      return [];
    }
  }

  /// カテゴリ別にタスクを取得
  Future<List<TaskModel>> getTasksByCategory(
    String projectId,
    TaskCategory category,
  ) async {
    try {
      final response = await _supabase
          .from('task')
          .select()
          .eq('project_id', projectId)
          .contains('task_category', [category.value])
          .order('created_at', ascending: false);

      final tasks = (response as List)
          .map((json) => TaskModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return await _tasksWithUserNames(tasks);
    } catch (e) {
      if (kDebugMode) {
        print('カテゴリ別タスク取得エラー: $e');
      }
      return [];
    }
  }

  /// ステータス別にタスクを取得
  Future<List<TaskModel>> getTasksByStatus(
    String projectId,
    TaskStatus status,
  ) async {
    try {
      final response = await _supabase
          .from('task')
          .select()
          .eq('project_id', projectId)
          .eq('task_status', status.value)
          .order('priority', ascending: false);

      final tasks = (response as List)
          .map((json) => TaskModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return await _tasksWithUserNames(tasks);
    } catch (e) {
      if (kDebugMode) {
        print('ステータス別タスク取得エラー: $e');
      }
      return [];
    }
  }

  /// タスクIDからタスクを取得
  Future<TaskModel?> getTaskById(String taskId) async {
    try {
      final response = await _supabase
          .from('task')
          .select()
          .eq('id', taskId)
          .single();

      final task = TaskModel.fromJson(response);
      final tasksWithNames = await _tasksWithUserNames([task]);
      return tasksWithNames.isNotEmpty ? tasksWithNames.first : null;
    } catch (e) {
      if (kDebugMode) {
        print('タスク取得エラー: $e');
      }
      return null;
    }
  }

  /// 新規タスクを作成
  Future<TaskModel> createTask({
    required String title,
    required String assignedToId,
    required DateTime deadline,
    required String projectId,
    TaskStatus status = TaskStatus.todo,
    Priority priority = Priority.low,
    List<TaskCategory> categories = const [],
    String? icon,
    String oneLine = '',
    String memo = '',
    String? relatedUrl,
  }) async {
    try {
      // 現在のユーザーを取得
      final currentUser = await _authRepository.getCurrentAuthUser();
      if (currentUser == null) {
        throw Exception('認証されていません');
      }

      final response = await _supabase
          .from('task')
          .insert({
            'title': title,
            'task_status': status.value,
            'priority': priority.value,
            'task_category': TaskCategory.listToStringList(categories),
            'icon': icon,
            'created_by': currentUser.id,
            'assigned_to': assignedToId,
            'deadline': deadline.toIso8601String(),
            'one_line': oneLine,
            'memo': memo,
            'related_url': relatedUrl,
            'project_id': projectId,
          })
          .select()
          .single();

      final task = TaskModel.fromJson(response);
      final tasksWithNames = await _tasksWithUserNames([task]);

      if (kDebugMode) {
        print('タスク作成成功: $title');
      }

      return tasksWithNames.first;
    } catch (e) {
      if (kDebugMode) {
        print('タスク作成エラー: $e');
      }
      rethrow;
    }
  }

  /// タスクを更新
  Future<TaskModel> updateTask(
    String taskId,
    Map<String, dynamic> updates,
  ) async {
    try {
      // updated_atを追加
      updates['updated_at'] = DateTime.now().toIso8601String();

      final response = await _supabase
          .from('task')
          .update(updates)
          .eq('id', taskId)
          .select()
          .single();

      final task = TaskModel.fromJson(response);
      final tasksWithNames = await _tasksWithUserNames([task]);

      if (kDebugMode) {
        print('タスク更新成功: $taskId');
      }

      return tasksWithNames.first;
    } catch (e) {
      if (kDebugMode) {
        print('タスク更新エラー: $e');
      }
      rethrow;
    }
  }

  /// タスクのステータスを更新
  Future<TaskModel> updateTaskStatus(String taskId, TaskStatus status) async {
    return updateTask(taskId, {'task_status': status.value});
  }

  /// タスクを削除
  Future<void> deleteTask(String taskId) async {
    try {
      await _supabase.from('task').delete().eq('id', taskId);

      if (kDebugMode) {
        print('タスク削除成功: $taskId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('タスク削除エラー: $e');
      }
      rethrow;
    }
  }

  /// 担当者別にタスクを取得
  Future<List<TaskModel>> getTasksByAssignedUser(
    String userId,
    String projectId,
  ) async {
    try {
      final response = await _supabase
          .from('task')
          .select()
          .eq('project_id', projectId)
          .eq('assigned_to', userId)
          .order('deadline', ascending: true);

      final tasks = (response as List)
          .map((json) => TaskModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return await _tasksWithUserNames(tasks);
    } catch (e) {
      if (kDebugMode) {
        print('担当者別タスク取得エラー: $e');
      }
      return [];
    }
  }

  /// 締め切りが近いタスクを取得
  Future<List<TaskModel>> getUpcomingTasks(
    String projectId, {
    int daysAhead = 7,
  }) async {
    try {
      final today = DateTime.now();
      final futureDate = today.add(Duration(days: daysAhead));

      final response = await _supabase
          .from('task')
          .select()
          .eq('project_id', projectId)
          .gte('deadline', today.toIso8601String())
          .lte('deadline', futureDate.toIso8601String())
          .neq('task_status', TaskStatus.done.value)
          .order('deadline', ascending: true);

      final tasks = (response as List)
          .map((json) => TaskModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return await _tasksWithUserNames(tasks);
    } catch (e) {
      if (kDebugMode) {
        print('締切が近いタスク取得エラー: $e');
      }
      return [];
    }
  }

  /// タスクリストにユーザー名を付与
  Future<List<TaskModel>> _tasksWithUserNames(List<TaskModel> tasks) async {
    if (tasks.isEmpty) return tasks;

    try {
      // ユーザーIDを収集（重複を除去）
      final userIds = <String>{};
      for (final task in tasks) {
        userIds.add(task.createdById);
        userIds.add(task.assignedToId);
      }

      // ユーザー情報を一括取得
      final users = await _authRepository.getUsersByIds(userIds.toList());
      final userMap = {for (var user in users) user.id: user.userName};

      // タスクにユーザー名を付与
      return tasks.map((task) {
        return task.copyWith(
          createdByName: userMap[task.createdById] ?? 'Unknown',
          assignedToName: userMap[task.assignedToId] ?? 'Unknown',
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('ユーザー名取得エラー: $e');
      }
      // エラーが発生してもタスクは返す（ユーザー名なし）
      return tasks;
    }
  }
}
