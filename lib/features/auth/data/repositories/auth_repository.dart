import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../providers/supabase_provider.dart';
import '../../domain/enums/user_role.dart';

/// 認証リポジトリのProvider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return AuthRepository(supabase);
});

/// 認証操作を管理するリポジトリ
class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository(this._supabase);

  /// メールアドレスとパスワードでログイン
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      if (kDebugMode) {
        print('ログイン試行: $email');
      }

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (kDebugMode) {
        print('ログイン成功: ${response.user?.id}');
      }

      // ログイン成功後、プロジェクトメンバーシップをチェック
      if (response.user != null) {
        try {
          await _ensureUserHasProject(response.user!.id);
        } catch (e) {
          if (kDebugMode) {
            print('プロジェクトメンバーシップの確認に失敗: $e');
          }
          // プロジェクト確認の失敗は致命的ではないので、ログインは継続
        }
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('ログイン処理でエラー: $e');
      }
      rethrow;
    }
  }

  /// 新規ユーザー登録
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String userName,
  }) async {
    try {
      // Supabase Authでユーザー作成
      final authResponse = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception('ユーザー作成に失敗しました');
      }

      final userId = authResponse.user!.id;

      // usersテーブルにユーザー情報を追加
      final userResponse = await _supabase
          .from('users')
          .insert({
            'id': userId,
            'user_name': userName,
            'email': email,
            'role': UserRole.member.value,
            'is_active': true,
          })
          .select()
          .single();

      if (kDebugMode) {
        print('ユーザー登録完了: $userName');
      }

      // プロジェクトメンバーシップを確保
      await _ensureUserHasProject(userId);

      return UserModel.fromJson(userResponse);
    } catch (e) {
      if (kDebugMode) {
        print('登録処理でエラー: $e');
      }
      rethrow;
    }
  }

  /// ログアウト
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
      if (kDebugMode) {
        print('ログアウト成功');
      }
    } catch (e) {
      if (kDebugMode) {
        print('ログアウトエラー: $e');
      }
      rethrow;
    }
  }

  /// 現在ログイン中のユーザー情報を取得（Supabase Auth）
  Future<User?> getCurrentAuthUser() async {
    try {
      final response = await _supabase.auth.getUser();
      return response.user;
    } catch (e) {
      if (kDebugMode) {
        print('認証ユーザー取得エラー: $e');
      }
      return null;
    }
  }

  /// 現在ログイン中のユーザー情報を取得（usersテーブル）
  Future<UserModel?> getCurrentUser() async {
    try {
      final authUser = await getCurrentAuthUser();
      if (authUser == null) return null;

      final response = await _supabase
          .from('users')
          .select()
          .eq('id', authUser.id)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('ユーザー情報取得エラー: $e');
      }

      // フォールバック: 認証ユーザーから基本情報を作成
      final authUser = await getCurrentAuthUser();
      if (authUser != null) {
        return UserModel.create(
          id: authUser.id,
          userName: authUser.email?.split('@').first ?? 'ユーザー',
          email: authUser.email ?? '',
        );
      }

      return null;
    }
  }

  /// ユーザーIDからユーザー情報を取得
  Future<UserModel?> getUserById(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('ユーザー取得エラー: $e');
      }
      return null;
    }
  }

  /// 複数のユーザーIDからユーザー情報を一括取得
  Future<List<UserModel>> getUsersByIds(List<String> userIds) async {
    try {
      if (userIds.isEmpty) return [];

      final response = await _supabase
          .from('users')
          .select()
          .inFilter('id', userIds);

      return (response as List)
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('ユーザー一括取得エラー: $e');
      }
      return [];
    }
  }

  /// 認証状態の変更を監視
  Stream<AuthState> get authStateChanges {
    return _supabase.auth.onAuthStateChange;
  }

  /// ユーザーがプロジェクトに所属していることを確認
  /// 必要に応じてデフォルトプロジェクトに追加
  Future<void> _ensureUserHasProject(String userId) async {
    try {
      if (kDebugMode) {
        print('プロジェクトメンバーシップ確認開始: $userId');
      }

      // ユーザーが所属するプロジェクトをチェック
      final userProjects = await _supabase
          .from('project_members')
          .select('project_id')
          .eq('user_id', userId)
          .eq('is_active', true);

      if (userProjects.isEmpty) {
        if (kDebugMode) {
          print('ユーザーはプロジェクトに所属していません。デフォルトプロジェクトに追加します。');
        }
        await _addUserToDefaultProject(userId);
      } else {
        if (kDebugMode) {
          print('ユーザーは既にプロジェクトに所属しています: ${userProjects.length}個');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('プロジェクトメンバーシップ確認エラー: $e');
      }
      // エラーは握りつぶす（致命的ではない）
    }
  }

  /// デフォルトプロジェクトにユーザーを追加
  Future<void> _addUserToDefaultProject(String userId) async {
    try {
      // 既存のデフォルトプロジェクトを検索
      final projects = await _supabase
          .from('project')
          .select()
          .eq('name', 'デフォルトプロジェクト')
          .limit(1);

      String? defaultProjectId;

      if (projects.isNotEmpty) {
        defaultProjectId = projects.first['id'] as String;
        if (kDebugMode) {
          print('既存のデフォルトプロジェクトを使用: $defaultProjectId');
        }
      } else {
        // デフォルトプロジェクトが存在しない場合、最初のプロジェクトを使用
        final allProjects = await _supabase.from('project').select().limit(1);

        if (allProjects.isNotEmpty) {
          defaultProjectId = allProjects.first['id'] as String;
          if (kDebugMode) {
            print('既存のプロジェクトを使用: $defaultProjectId');
          }
        } else {
          if (kDebugMode) {
            print('プロジェクトが存在しません。管理者に連絡してください。');
          }
          return;
        }
      }

      // ユーザーをプロジェクトメンバーとして追加
      await _supabase.from('project_members').insert({
        'project_id': defaultProjectId,
        'user_id': userId,
        'role': UserRole.member.value,
        'is_active': true,
      });

      if (kDebugMode) {
        print('ユーザーをデフォルトプロジェクトに追加完了');
      }
    } catch (e) {
      // 既にメンバーとして存在する場合などはエラーを無視
      if (kDebugMode) {
        print('プロジェクトメンバー追加エラー（無視）: $e');
      }
    }
  }
}
