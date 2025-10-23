/// タスクのカテゴリを表すEnum
enum TaskCategory {
  /// 個人タスク
  solo('solo', 'Solo Task'),

  /// チームタスク
  team('team', 'Team Task'),

  /// フロントエンド
  front('front', 'Front'),

  /// バックエンド
  back('back', 'Back'),

  /// 設定・環境構築
  setting('setting', 'Setting');

  const TaskCategory(this.value, this.label);

  /// データベースでの値
  final String value;

  /// 表示用ラベル
  final String label;

  /// 文字列からTaskCategoryを取得
  static TaskCategory fromString(String value) {
    return TaskCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => TaskCategory.solo,
    );
  }

  /// データベース保存用の文字列に変換
  String toJson() => value;

  /// 文字列リストからTaskCategoryリストに変換
  static List<TaskCategory> listFromStringList(List<dynamic> values) {
    return values.map((value) => fromString(value.toString())).toList();
  }

  /// TaskCategoryリストから文字列リストに変換
  static List<String> listToStringList(List<TaskCategory> categories) {
    return categories.map((category) => category.value).toList();
  }
}
