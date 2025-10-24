import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../auth/data/providers/supabase_provider.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../project/data/models/project_model.dart';
import '../../../project/data/models/project_member_model.dart';
import '../../../task/data/models/task_model.dart';
import '../../../task/domain/enums/task_status.dart';

/// 管理者リポジトリのProvider
final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final authRepository = ref.read(authRepositoryProvider);
  return AdminRepository(supabase, authRepository);
});

/// 管理者機能を管理するリポジトリ
class AdminRepository {
  final SupabaseClient _supabase;
  final AuthRepository _authRepository;

  AdminRepository(this._supabase, this._authRepository);

  /// 全ユーザー一覧を取得
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('全ユーザー取得エラー: $e');
      }
      return [];
    }
  }

  /// アクティブユーザー一覧を取得
  Future<List<UserModel>> getActiveUsers() async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('アクティブユーザー取得エラー: $e');
      }
      return [];
    }
  }

  /// ユーザーのアクティブ状態を更新
  Future<void> updateUserActiveStatus(String userId, bool isActive) async {
    try {
      await _supabase
          .from('users')
          .update({'is_active': isActive})
          .eq('id', userId);

      if (kDebugMode) {
        print('ユーザーアクティブ状態更新成功: $userId -> $isActive');
      }
    } catch (e) {
      if (kDebugMode) {
        print('ユーザーアクティブ状態更新エラー: $e');
      }
      rethrow;
    }
  }

  /// ユーザーの権限を更新
  Future<void> updateUserRole(String userId, String role) async {
    try {
      await _supabase.from('users').update({'role': role}).eq('id', userId);

      if (kDebugMode) {
        print('ユーザー権限更新成功: $userId -> $role');
      }
    } catch (e) {
      if (kDebugMode) {
        print('ユーザー権限更新エラー: $e');
      }
      rethrow;
    }
  }

  /// 全プロジェクト一覧を取得
  Future<List<ProjectModel>> getAllProjects() async {
    try {
      final response = await _supabase
          .from('project')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ProjectModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('全プロジェクト取得エラー: $e');
      }
      return [];
    }
  }

  /// プロジェクトのメンバー一覧を取得
  Future<List<ProjectMemberModel>> getProjectMembers(String projectId) async {
    try {
      final response = await _supabase
          .from('project_members')
          .select()
          .eq('project_id', projectId)
          .order('created_at', ascending: false);

      return (response as List)
          .map(
            (json) => ProjectMemberModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('プロジェクトメンバー取得エラー: $e');
      }
      return [];
    }
  }

  /// プロジェクトからメンバーを削除
  Future<void> removeMemberFromProject(String projectId, String userId) async {
    try {
      await _supabase
          .from('project_members')
          .delete()
          .eq('project_id', projectId)
          .eq('user_id', userId);

      if (kDebugMode) {
        print('プロジェクトメンバー削除成功: $projectId, $userId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('プロジェクトメンバー削除エラー: $e');
      }
      rethrow;
    }
  }

  /// 締切が近いタスク一覧を取得
  Future<List<TaskModel>> getUpcomingTasks({int daysAhead = 7}) async {
    try {
      final today = DateTime.now();
      final futureDate = today.add(Duration(days: daysAhead));

      final response = await _supabase
          .from('task')
          .select()
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

  /// 期限切れタスク一覧を取得
  Future<List<TaskModel>> getOverdueTasks() async {
    try {
      final today = DateTime.now();

      final response = await _supabase
          .from('task')
          .select()
          .lt('deadline', today.toIso8601String())
          .neq('task_status', TaskStatus.done.value)
          .order('deadline', ascending: true);

      final tasks = (response as List)
          .map((json) => TaskModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return await _tasksWithUserNames(tasks);
    } catch (e) {
      if (kDebugMode) {
        print('期限切れタスク取得エラー: $e');
      }
      return [];
    }
  }

  /// 高優先度タスク一覧を取得
  Future<List<TaskModel>> getHighPriorityTasks() async {
    try {
      final response = await _supabase
          .from('task')
          .select()
          .eq('priority', 3) // 高優先度
          .neq('task_status', TaskStatus.done.value)
          .order('deadline', ascending: true);

      final tasks = (response as List)
          .map((json) => TaskModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return await _tasksWithUserNames(tasks);
    } catch (e) {
      if (kDebugMode) {
        print('高優先度タスク取得エラー: $e');
      }
      return [];
    }
  }

  /// プロジェクト別タスク統計を取得
  Future<Map<String, int>> getProjectTaskStats() async {
    try {
      final response = await _supabase
          .from('task')
          .select('project_id, task_status');

      final Map<String, int> stats = {};

      for (final task in response as List) {
        final projectId = task['project_id'] as String;
        final status = task['task_status'] as String;

        final key = '${projectId}_$status';
        stats[key] = (stats[key] ?? 0) + 1;
      }

      return stats;
    } catch (e) {
      if (kDebugMode) {
        print('プロジェクトタスク統計取得エラー: $e');
      }
      return {};
    }
  }

  /// ユーザー別タスク統計を取得
  Future<Map<String, int>> getUserTaskStats() async {
    try {
      final response = await _supabase
          .from('task')
          .select('assigned_to, task_status');

      final Map<String, int> stats = {};

      for (final task in response as List) {
        final userId = task['assigned_to'] as String;
        final status = task['task_status'] as String;

        final key = '${userId}_$status';
        stats[key] = (stats[key] ?? 0) + 1;
      }

      return stats;
    } catch (e) {
      if (kDebugMode) {
        print('ユーザータスク統計取得エラー: $e');
      }
      return {};
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
