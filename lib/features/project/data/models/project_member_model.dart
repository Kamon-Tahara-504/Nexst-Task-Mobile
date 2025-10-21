import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_member_model.freezed.dart';
part 'project_member_model.g.dart';

/// プロジェクトメンバーモデル
@freezed
class ProjectMemberModel with _$ProjectMemberModel {
  const factory ProjectMemberModel({
    /// メンバーシップID (uuid)
    required String id,

    /// プロジェクトID (uuid)
    @JsonKey(name: 'project_id') required String projectId,

    /// ユーザーID (uuid)
    @JsonKey(name: 'user_id') required String userId,

    /// プロジェクト内での役割
    @Default('member') String role,

    /// アクティブ状態
    @JsonKey(name: 'is_active') @Default(true) bool isActive,

    /// 作成日時
    @JsonKey(name: 'created_at') required DateTime createdAt,

    /// 更新日時
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ProjectMemberModel;

  const ProjectMemberModel._();

  /// JSONからProjectMemberModelを生成
  factory ProjectMemberModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectMemberModelFromJson(json);

  /// 新規メンバーシップ作成用のファクトリー
  factory ProjectMemberModel.create({
    required String id,
    required String projectId,
    required String userId,
    String role = 'member',
  }) {
    final now = DateTime.now();
    return ProjectMemberModel(
      id: id,
      projectId: projectId,
      userId: userId,
      role: role,
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// 管理者かどうか
  bool get isAdmin => role == 'admin';

  /// メンバーかどうか
  bool get isMember => role == 'member';

  /// 役割の表示用文字列
  String get roleLabel {
    switch (role) {
      case 'admin':
        return '管理者';
      case 'member':
        return 'メンバー';
      default:
        return role;
    }
  }
}
