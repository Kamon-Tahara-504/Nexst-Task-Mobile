import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../data/models/project_model.dart';
import '../../data/repositories/project_repository.dart';

/// SharedPreferencesのキー
const String _selectedProjectIdKey = 'nexst_task_selected_project_id';

/// SharedPreferencesのProvider
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return await SharedPreferences.getInstance();
});

/// 選択中のプロジェクトID（永続化）
final selectedProjectIdProvider =
    StateNotifierProvider<SelectedProjectNotifier, String?>((ref) {
      return SelectedProjectNotifier(ref);
    });

/// 選択中のプロジェクトID管理用のNotifier
class SelectedProjectNotifier extends StateNotifier<String?> {
  final Ref _ref;

  SelectedProjectNotifier(this._ref) : super(null) {
    _loadSelectedProjectId();
  }

  /// 保存されているプロジェクトIDを読み込み
  Future<void> _loadSelectedProjectId() async {
    try {
      final prefs = await _ref.read(sharedPreferencesProvider.future);
      final projectId = prefs.getString(_selectedProjectIdKey);

      if (projectId != null && projectId.isNotEmpty) {
        state = projectId;
        if (kDebugMode) {
          print('プロジェクトIDを復元: $projectId');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('プロジェクトID読み込みエラー: $e');
      }
    }
  }

  /// プロジェクトを選択
  Future<void> selectProject(String projectId) async {
    try {
      final prefs = await _ref.read(sharedPreferencesProvider.future);
      await prefs.setString(_selectedProjectIdKey, projectId);
      state = projectId;

      if (kDebugMode) {
        print('プロジェクトを選択: $projectId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('プロジェクト選択エラー: $e');
      }
      rethrow;
    }
  }

  /// プロジェクト選択をクリア
  Future<void> clearSelectedProject() async {
    try {
      final prefs = await _ref.read(sharedPreferencesProvider.future);
      await prefs.remove(_selectedProjectIdKey);
      state = null;

      if (kDebugMode) {
        print('プロジェクト選択をクリア');
      }
    } catch (e) {
      if (kDebugMode) {
        print('プロジェクトクリアエラー: $e');
      }
    }
  }
}

/// 選択中のプロジェクト詳細
final selectedProjectProvider = FutureProvider<ProjectModel?>((ref) async {
  final projectId = ref.watch(selectedProjectIdProvider);
  if (projectId == null) return null;

  final repository = ref.read(projectRepositoryProvider);
  return repository.getProjectById(projectId);
});

/// プロジェクトが選択されているか
final hasSelectedProjectProvider = Provider<bool>((ref) {
  final projectId = ref.watch(selectedProjectIdProvider);
  return projectId != null;
});

/// ユーザーの所属プロジェクト一覧
final userProjectsProvider = FutureProvider<List<ProjectModel>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return [];

  final repository = ref.read(projectRepositoryProvider);
  return repository.getUserProjects(user.id);
});

/// プロジェクトのメンバー数を取得
final projectMemberCountProvider = FutureProvider.family<int, String>((
  ref,
  projectId,
) async {
  final repository = ref.read(projectRepositoryProvider);
  return repository.getProjectMemberCount(projectId);
});

/// プロジェクト作成のローディング状態
final projectCreatingProvider = StateProvider<bool>((ref) => false);

/// プロジェクト参加のローディング状態
final projectJoiningProvider = StateProvider<bool>((ref) => false);

/// プロジェクトエラーメッセージ
final projectErrorProvider = StateProvider<String?>((ref) => null);
