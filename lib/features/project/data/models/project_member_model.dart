import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/enums/project_member_role.dart';

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
    @JsonKey(fromJson: _roleFromJson, toJson: _roleToJson)
    @Default(ProjectMemberRole.member)
    ProjectMemberRole role,

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
    ProjectMemberRole role = ProjectMemberRole.member,
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
  bool get isAdmin => role == ProjectMemberRole.admin;

  /// メンバーかどうか
  bool get isMember => role == ProjectMemberRole.member;

  /// 役割の表示用文字列
  String get roleLabel => role.label;
}

/// JSON変換用ヘルパー関数: ProjectMemberRole -> String
String _roleToJson(ProjectMemberRole role) => role.value;

/// JSON変換用ヘルパー関数: String -> ProjectMemberRole
ProjectMemberRole _roleFromJson(dynamic value) {
  if (value is String) {
    return ProjectMemberRole.fromString(value);
  }
  return ProjectMemberRole.member;
}
