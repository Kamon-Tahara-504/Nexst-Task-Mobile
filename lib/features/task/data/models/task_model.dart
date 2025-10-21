import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/enums/task_status.dart';
import '../../domain/enums/task_category.dart';
import '../../domain/enums/priority.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

/// タスクモデル
@freezed
class TaskModel with _$TaskModel {
  const factory TaskModel({
    /// タスクID (uuid)
    required String id,

    /// タスク名
    required String title,

    /// タスクステータス
    @JsonKey(
      name: 'task_status',
      fromJson: _taskStatusFromJson,
      toJson: _taskStatusToJson,
    )
    required TaskStatus status,

    /// 優先度
    @JsonKey(fromJson: _priorityFromJson, toJson: _priorityToJson)
    required Priority priority,

    /// タスクカテゴリ（配列）
    @JsonKey(
      name: 'task_category',
      fromJson: _categoriesFromJson,
      toJson: _categoriesToJson,
    )
    required List<TaskCategory> categories,

    /// アイコン
    String? icon,

    /// 作成者ID (uuid)
    @JsonKey(name: 'created_by') required String createdById,

    /// 作成者名（UIでの表示用、JSONには含めない）
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String createdByName,

    /// 担当者ID (uuid)
    @JsonKey(name: 'assigned_to') required String assignedToId,

    /// 担当者名（UIでの表示用、JSONには含めない）
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String assignedToName,

    /// 締切日時
    required DateTime deadline,

    /// 一行説明
    @JsonKey(name: 'one_line') @Default('') String oneLine,

    /// 詳細メモ
    @Default('') String memo,

    /// 関連URL
    @JsonKey(name: 'related_url') String? relatedUrl,

    /// プロジェクトID (uuid)
    @JsonKey(name: 'project_id') required String projectId,

    /// 作成日時
    @JsonKey(name: 'created_at') required DateTime createdAt,

    /// 更新日時
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _TaskModel;

  const TaskModel._();

  /// JSONからTaskModelを生成
  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  /// 新規タスク作成用のファクトリー
  factory TaskModel.create({
    required String id,
    required String title,
    required String createdById,
    required String assignedToId,
    required DateTime deadline,
    required String projectId,
    TaskStatus status = TaskStatus.todo,
    Priority priority = Priority.low,
    List<TaskCategory> categories = const [],
    String? icon,
    String oneLine = '',
    String memo = '',
    String? relatedUrl,
  }) {
    final now = DateTime.now();
    return TaskModel(
      id: id,
      title: title,
      status: status,
      priority: priority,
      categories: categories,
      icon: icon,
      createdById: createdById,
      assignedToId: assignedToId,
      deadline: deadline,
      oneLine: oneLine,
      memo: memo,
      relatedUrl: relatedUrl,
      projectId: projectId,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// 未着手かどうか
  bool get isTodo => status == TaskStatus.todo;

  /// 進行中かどうか
  bool get isInProgress => status == TaskStatus.inProgress;

  /// 完了かどうか
  bool get isDone => status == TaskStatus.done;

  /// 高優先度かどうか
  bool get isHighPriority => priority == Priority.high;

  /// 中優先度かどうか
  bool get isMediumPriority => priority == Priority.medium;

  /// 低優先度かどうか
  bool get isLowPriority => priority == Priority.low;

  /// Soloタスクかどうか
  bool get isSoloTask => categories.contains(TaskCategory.solo);

  /// Teamタスクかどうか
  bool get isTeamTask => categories.contains(TaskCategory.team);

  /// 関連URLを持っているかどうか
  bool get hasRelatedUrl => relatedUrl != null && relatedUrl!.isNotEmpty;

  /// アイコンを持っているかどうか
  bool get hasIcon => icon != null && icon!.isNotEmpty;

  /// 一行説明を持っているかどうか
  bool get hasOneLine => oneLine.isNotEmpty;

  /// 詳細メモを持っているかどうか
  bool get hasMemo => memo.isNotEmpty;

  /// アイコンのパスを取得
  String? get iconPath => hasIcon ? 'assets/icons/$icon.svg' : null;

  /// カテゴリの表示用文字列
  String get categoriesText {
    if (categories.isEmpty) return '';
    return categories.map((c) => c.label).join(', ');
  }

  /// 次のステータス
  TaskStatus get nextStatus => status.next;

  /// 前のステータス
  TaskStatus get previousStatus => status.previous;
}

/// JSON変換用ヘルパー関数: TaskStatus -> String
String _taskStatusToJson(TaskStatus status) => status.value;

/// JSON変換用ヘルパー関数: String -> TaskStatus
TaskStatus _taskStatusFromJson(dynamic value) {
  if (value is String) {
    return TaskStatus.fromString(value);
  }
  return TaskStatus.todo;
}

/// JSON変換用ヘルパー関数: Priority -> int
int _priorityToJson(Priority priority) => priority.value;

/// JSON変換用ヘルパー関数: int -> Priority
Priority _priorityFromJson(dynamic value) {
  if (value is int) {
    return Priority.fromInt(value);
  } else if (value is String) {
    return Priority.fromInt(int.tryParse(value) ?? 1);
  }
  return Priority.low;
}

/// JSON変換用ヘルパー関数: List<TaskCategory> -> List<String>
List<String> _categoriesToJson(List<TaskCategory> categories) {
  return TaskCategory.listToStringList(categories);
}

/// JSON変換用ヘルパー関数: List<dynamic> -> List<TaskCategory>
List<TaskCategory> _categoriesFromJson(dynamic value) {
  if (value is List) {
    return TaskCategory.listFromStringList(value);
  }
  return [];
}
