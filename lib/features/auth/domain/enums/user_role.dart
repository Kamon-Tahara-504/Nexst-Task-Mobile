/// ユーザーの権限を表すEnum
enum UserRole {
  /// 管理者
  admin('admin', '管理者'),

  /// メンバー
  member('member', 'メンバー');

  const UserRole(this.value, this.label);

  /// データベースでの値
  final String value;

  /// 表示用ラベル
  final String label;

  /// 文字列からUserRoleを取得
  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.member,
    );
  }

  /// データベース保存用の文字列に変換
  String toJson() => value;

  /// 管理者かどうか
  bool get isAdmin => this == UserRole.admin;

  /// メンバーかどうか
  bool get isMember => this == UserRole.member;
}
