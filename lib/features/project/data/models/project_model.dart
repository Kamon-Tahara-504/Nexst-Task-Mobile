import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_model.freezed.dart';
part 'project_model.g.dart';

/// プロジェクトモデル
@freezed
class ProjectModel with _$ProjectModel {
  const factory ProjectModel({
    /// プロジェクトID (uuid)
    required String id,

    /// プロジェクト名
    required String name,

    /// プロジェクトコード
    required String code,

    /// 作成日時
    @JsonKey(name: 'created_at') required DateTime createdAt,

    /// 更新日時
    @JsonKey(name: 'updated_at') required DateTime updatedAt,

    /// メンバー数（動的に追加される場合がある）
    @JsonKey(name: 'member_count', includeFromJson: false, includeToJson: false)
    int? memberCount,
  }) = _ProjectModel;

  const ProjectModel._();

  /// JSONからProjectModelを生成
  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);

  /// 新規プロジェクト作成用のファクトリー
  factory ProjectModel.create({
    required String id,
    required String name,
    required String code,
  }) {
    final now = DateTime.now();
    return ProjectModel(
      id: id,
      name: name,
      code: code,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// メンバー数の表示用文字列
  String get memberCountText {
    if (memberCount == null) return '';
    return '$memberCount人';
  }

  /// プロジェクトの説明文を取得
  String get description {
    return 'コード: $code${memberCount != null ? ' • $memberCountText' : ''}';
  }
}
