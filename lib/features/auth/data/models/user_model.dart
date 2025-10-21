import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/enums/user_role.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// ユーザーモデル
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    /// ユーザーID (uuid)
    required String id,

    /// ユーザー名
    @JsonKey(name: 'user_name') required String userName,

    /// メールアドレス
    required String email,

    /// 所属プロジェクトID (nullable)
    @JsonKey(name: 'project_id') String? projectId,

    /// 権限（文字列として保存）
    @JsonKey(name: 'role', fromJson: _userRoleFromJson, toJson: _userRoleToJson)
    @Default(UserRole.member)
    UserRole role,

    /// アクティブ状態
    @JsonKey(name: 'is_active') @Default(true) bool isActive,

    /// 作成日時
    @JsonKey(name: 'created_at') required DateTime createdAt,

    /// 更新日時
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _UserModel;

  const UserModel._();

  /// JSONからUserModelを生成
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// 新規ユーザー作成用のファクトリー
  factory UserModel.create({
    required String id,
    required String userName,
    required String email,
    UserRole role = UserRole.member,
  }) {
    final now = DateTime.now();
    return UserModel(
      id: id,
      userName: userName,
      email: email,
      role: role,
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// 管理者かどうか
  bool get isAdmin => role == UserRole.admin;

  /// メンバーかどうか
  bool get isMember => role == UserRole.member;

  /// プロジェクトに所属しているか
  bool get hasProject => projectId != null;

  /// 表示用の名前を取得
  String get displayName =>
      userName.isEmpty ? email.split('@').first : userName;
}

/// JSON変換用ヘルパー関数: UserRole -> String
String _userRoleToJson(UserRole role) => role.value;

/// JSON変換用ヘルパー関数: String -> UserRole
UserRole _userRoleFromJson(dynamic value) {
  if (value is String) {
    return UserRole.fromString(value);
  }
  return UserRole.member;
}
