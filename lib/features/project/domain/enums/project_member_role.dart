/// プロジェクトメンバーの役割を表すEnum
enum ProjectMemberRole {
  /// 管理者
  admin('admin', '管理者'),

  /// メンバー
  member('member', 'メンバー');

  const ProjectMemberRole(this.value, this.label);

  /// データベースでの値
  final String value;

  /// 表示用ラベル
  final String label;

  /// 文字列からProjectMemberRoleを取得
  static ProjectMemberRole fromString(String value) {
    return ProjectMemberRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => ProjectMemberRole.member,
    );
  }

  /// データベース保存用の文字列に変換
  String toJson() => value;

  /// 管理者かどうか
  bool get isAdmin => this == ProjectMemberRole.admin;

  /// メンバーかどうか
  bool get isMember => this == ProjectMemberRole.member;
}
