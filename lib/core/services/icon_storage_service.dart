import '../config/supabase_config.dart';

/// Supabase Storage の言語アイコンバケット名（Web版と共通）
const String _iconsBucket = 'icons';

/// タスクの言語アイコンを Supabase Storage から取得するためのサービス
class IconStorageService {
  IconStorageService._();

  static final _cache = <String, String>{};

  /// アイコンの公開URLを取得する。
  /// [iconName] はアイコン名（例: 'react', 'typescript'）。拡張子なし。
  /// 取得したURLはメモリでキャッシュする。
  static String getIconUrl(String iconName) {
    if (_cache.containsKey(iconName)) {
      return _cache[iconName]!;
    }
    final path = '$iconName.svg';
    final url = SupabaseConfig.storage.from(_iconsBucket).getPublicUrl(path);
    _cache[iconName] = url;
    return url;
  }

  /// キャッシュをクリアする（主にテスト用）
  static void clearCache() {
    _cache.clear();
  }

  /// 指定アイコンのキャッシュのみ削除
  static void removeFromCache(String iconName) {
    _cache.remove(iconName);
  }
}
