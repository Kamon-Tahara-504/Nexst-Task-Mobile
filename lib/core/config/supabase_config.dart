import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase設定クラス
class SupabaseConfig {
  SupabaseConfig._(); // プライベートコンストラクタ

  /// Supabaseクライアントのインスタンス
  static SupabaseClient get client => Supabase.instance.client;

  /// Supabaseの初期化
  ///
  /// アプリ起動時に一度だけ呼び出す必要があります
  static Future<void> initialize() async {
    try {
      // 環境変数から認証情報を取得
      final supabaseUrl = dotenv.env['SUPABASE_URL'];
      final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

      if (supabaseUrl == null || supabaseUrl.isEmpty) {
        throw Exception('SUPABASE_URLが設定されていません。.envファイルを確認してください。');
      }

      if (supabaseAnonKey == null || supabaseAnonKey.isEmpty) {
        throw Exception('SUPABASE_ANON_KEYが設定されていません。.envファイルを確認してください。');
      }

      // Supabaseの初期化
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
        realtimeClientOptions: const RealtimeClientOptions(
          logLevel: kDebugMode ? RealtimeLogLevel.info : RealtimeLogLevel.error,
        ),
        storageOptions: const StorageClientOptions(retryAttempts: 3),
        postgrestOptions: const PostgrestClientOptions(schema: 'public'),
      );

      if (kDebugMode) {
        print('Supabase初期化成功');
        print('   URL: $supabaseUrl');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Supabase初期化エラー: $e');
        print('StackTrace: $stackTrace');
      }
      rethrow;
    }
  }

  /// 認証状態のチェック
  static bool get isAuthenticated {
    return client.auth.currentSession != null;
  }

  /// 現在のユーザーを取得
  static User? get currentUser {
    return client.auth.currentUser;
  }

  /// 現在のセッションを取得
  static Session? get currentSession {
    return client.auth.currentSession;
  }

  /// 認証状態の変更を監視
  static Stream<AuthState> get authStateChanges {
    return client.auth.onAuthStateChange;
  }

  /// データベースクライアントを取得
  static PostgrestClient get db {
    return client.from('') as PostgrestClient;
  }

  /// ストレージクライアントを取得
  static SupabaseStorageClient get storage {
    return client.storage;
  }

  /// Realtimeクライアントを取得
  static RealtimeClient get realtime {
    return client.realtime;
  }

  /// 接続状態の確認
  static Future<bool> checkConnection() async {
    try {
      // 簡単なクエリを実行して接続を確認
      await client.from('project').select('id').limit(1);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Supabase接続エラー: $e');
      }
      return false;
    }
  }

  /// 環境変数のバリデーション
  static bool validateEnvironmentVariables() {
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

    return supabaseUrl != null &&
        supabaseUrl.isNotEmpty &&
        supabaseAnonKey != null &&
        supabaseAnonKey.isNotEmpty;
  }
}
