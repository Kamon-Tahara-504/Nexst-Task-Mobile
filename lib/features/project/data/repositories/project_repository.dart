import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../auth/data/providers/supabase_provider.dart';
import '../models/project_model.dart';
import '../models/project_member_model.dart';

/// プロジェクトリポジトリのProvider
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return ProjectRepository(supabase);
});

/// プロジェクト操作を管理するリポジトリ
class ProjectRepository {
  final SupabaseClient _supabase;

  ProjectRepository(this._supabase);

  /// ユーザーが所属するプロジェクト一覧を取得
  Future<List<ProjectModel>> getUserProjects(String userId) async {
    try {
      // project_membersテーブルから所属プロジェクトIDを取得
      final membershipResponse = await _supabase
          .from('project_members')
          .select('project_id')
          .eq('user_id', userId)
          .eq('is_active', true);

      if (membershipResponse.isEmpty) {
        return [];
      }

      // プロジェクトIDのリストを抽出
      final projectIds = (membershipResponse as List)
          .map((m) => m['project_id'] as String)
          .toList();

      // プロジェクト情報を取得
      final projectsResponse = await _supabase
          .from('project')
          .select()
          .inFilter('id', projectIds);

      return (projectsResponse as List)
          .map((json) => ProjectModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('ユーザープロジェクト取得エラー: $e');
      }
      rethrow;
    }
  }

  /// プロジェクトIDからプロジェクト情報を取得
  Future<ProjectModel?> getProjectById(String projectId) async {
    try {
      final response = await _supabase
          .from('project')
          .select()
          .eq('id', projectId)
          .single();

      return ProjectModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('プロジェクト取得エラー: $e');
      }
      return null;
    }
  }

  /// プロジェクトを作成（管理者のみ）
  Future<ProjectModel> createProject({
    required String name,
    required String code,
  }) async {
    try {
      final response = await _supabase
          .from('project')
          .insert({'name': name, 'code': code})
          .select()
          .single();

      final project = ProjectModel.fromJson(response);

      if (kDebugMode) {
        print('プロジェクト作成成功: ${project.name}');
      }

      return project;
    } catch (e) {
      if (kDebugMode) {
        print('プロジェクト作成エラー: $e');
      }
      rethrow;
    }
  }

  /// プロジェクトコードでプロジェクトに参加
  Future<ProjectModel?> joinProjectByCode({
    required String code,
    required String userId,
  }) async {
    try {
      // プロジェクトコードでプロジェクトを検索
      final projectResponse = await _supabase
          .from('project')
          .select()
          .eq('code', code)
          .maybeSingle();

      if (projectResponse == null) {
        throw Exception('プロジェクトコードが見つかりません');
      }

      final project = ProjectModel.fromJson(projectResponse);

      // 既にメンバーかチェック
      final existingMember = await _supabase
          .from('project_members')
          .select()
          .eq('project_id', project.id)
          .eq('user_id', userId)
          .maybeSingle();

      if (existingMember != null) {
        if (kDebugMode) {
          print('既にプロジェクトのメンバーです');
        }
        return project;
      }

      // メンバーとして追加
      await _supabase.from('project_members').insert({
        'project_id': project.id,
        'user_id': userId,
        'role': 'member',
        'is_active': true,
      });

      if (kDebugMode) {
        print('プロジェクト参加成功: ${project.name}');
      }

      return project;
    } catch (e) {
      if (kDebugMode) {
        print('プロジェクト参加エラー: $e');
      }
      rethrow;
    }
  }

  /// プロジェクトのメンバー一覧を取得
  Future<List<ProjectMemberModel>> getProjectMembers(String projectId) async {
    try {
      final response = await _supabase
          .from('project_members')
          .select()
          .eq('project_id', projectId)
          .eq('is_active', true);

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

  /// プロジェクトにメンバーを追加
  Future<ProjectMemberModel> addMemberToProject({
    required String projectId,
    required String userId,
    String role = 'member',
  }) async {
    try {
      final response = await _supabase
          .from('project_members')
          .insert({
            'project_id': projectId,
            'user_id': userId,
            'role': role,
            'is_active': true,
          })
          .select()
          .single();

      return ProjectMemberModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('メンバー追加エラー: $e');
      }
      rethrow;
    }
  }

  /// プロジェクトメンバーを削除
  Future<void> removeMemberFromProject(String membershipId) async {
    try {
      await _supabase
          .from('project_members')
          .update({'is_active': false})
          .eq('id', membershipId);

      if (kDebugMode) {
        print('メンバー削除成功');
      }
    } catch (e) {
      if (kDebugMode) {
        print('メンバー削除エラー: $e');
      }
      rethrow;
    }
  }

  /// プロジェクトのメンバー数を取得
  Future<int> getProjectMemberCount(String projectId) async {
    try {
      final response = await _supabase
          .from('project_members')
          .select()
          .eq('project_id', projectId)
          .eq('is_active', true);

      return (response as List).length;
    } catch (e) {
      if (kDebugMode) {
        print('メンバー数取得エラー: $e');
      }
      return 0;
    }
  }

  /// ユーザーがプロジェクトのメンバーかチェック
  Future<bool> isProjectMember({
    required String projectId,
    required String userId,
  }) async {
    try {
      final response = await _supabase
          .from('project_members')
          .select()
          .eq('project_id', projectId)
          .eq('user_id', userId)
          .eq('is_active', true)
          .maybeSingle();

      return response != null;
    } catch (e) {
      if (kDebugMode) {
        print('メンバー確認エラー: $e');
      }
      return false;
    }
  }
}
