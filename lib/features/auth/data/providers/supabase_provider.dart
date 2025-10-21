import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/supabase_config.dart';

/// SupabaseクライアントのProvider
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return SupabaseConfig.client;
});

/// Supabase Authのストリーム
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return supabase.auth.onAuthStateChange;
});

/// 現在の認証ユーザー
final currentAuthUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateChangesProvider).value;
  return authState?.session?.user;
});

/// 認証されているかどうか
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentAuthUserProvider);
  return user != null;
});
