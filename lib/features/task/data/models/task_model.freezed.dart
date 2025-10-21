// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) {
  return _TaskModel.fromJson(json);
}

/// @nodoc
mixin _$TaskModel {
  /// タスクID (uuid)
  String get id => throw _privateConstructorUsedError;

  /// タスク名
  String get title => throw _privateConstructorUsedError;

  /// タスクステータス
  @JsonKey(
    name: 'task_status',
    fromJson: _taskStatusFromJson,
    toJson: _taskStatusToJson,
  )
  TaskStatus get status => throw _privateConstructorUsedError;

  /// 優先度
  @JsonKey(fromJson: _priorityFromJson, toJson: _priorityToJson)
  Priority get priority => throw _privateConstructorUsedError;

  /// タスクカテゴリ（配列）
  @JsonKey(
    name: 'task_category',
    fromJson: _categoriesFromJson,
    toJson: _categoriesToJson,
  )
  List<TaskCategory> get categories => throw _privateConstructorUsedError;

  /// アイコン
  String? get icon => throw _privateConstructorUsedError;

  /// 作成者ID (uuid)
  @JsonKey(name: 'created_by')
  String get createdById => throw _privateConstructorUsedError;

  /// 作成者名（UIでの表示用、JSONには含めない）
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get createdByName => throw _privateConstructorUsedError;

  /// 担当者ID (uuid)
  @JsonKey(name: 'assigned_to')
  String get assignedToId => throw _privateConstructorUsedError;

  /// 担当者名（UIでの表示用、JSONには含めない）
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get assignedToName => throw _privateConstructorUsedError;

  /// 締切日時
  DateTime get deadline => throw _privateConstructorUsedError;

  /// 一行説明
  @JsonKey(name: 'one_line')
  String get oneLine => throw _privateConstructorUsedError;

  /// 詳細メモ
  String get memo => throw _privateConstructorUsedError;

  /// 関連URL
  @JsonKey(name: 'related_url')
  String? get relatedUrl => throw _privateConstructorUsedError;

  /// プロジェクトID (uuid)
  @JsonKey(name: 'project_id')
  String get projectId => throw _privateConstructorUsedError;

  /// 作成日時
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 更新日時
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TaskModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskModelCopyWith<TaskModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskModelCopyWith<$Res> {
  factory $TaskModelCopyWith(TaskModel value, $Res Function(TaskModel) then) =
      _$TaskModelCopyWithImpl<$Res, TaskModel>;
  @useResult
  $Res call({
    String id,
    String title,
    @JsonKey(
      name: 'task_status',
      fromJson: _taskStatusFromJson,
      toJson: _taskStatusToJson,
    )
    TaskStatus status,
    @JsonKey(fromJson: _priorityFromJson, toJson: _priorityToJson)
    Priority priority,
    @JsonKey(
      name: 'task_category',
      fromJson: _categoriesFromJson,
      toJson: _categoriesToJson,
    )
    List<TaskCategory> categories,
    String? icon,
    @JsonKey(name: 'created_by') String createdById,
    @JsonKey(includeFromJson: false, includeToJson: false) String createdByName,
    @JsonKey(name: 'assigned_to') String assignedToId,
    @JsonKey(includeFromJson: false, includeToJson: false)
    String assignedToName,
    DateTime deadline,
    @JsonKey(name: 'one_line') String oneLine,
    String memo,
    @JsonKey(name: 'related_url') String? relatedUrl,
    @JsonKey(name: 'project_id') String projectId,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$TaskModelCopyWithImpl<$Res, $Val extends TaskModel>
    implements $TaskModelCopyWith<$Res> {
  _$TaskModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? status = null,
    Object? priority = null,
    Object? categories = null,
    Object? icon = freezed,
    Object? createdById = null,
    Object? createdByName = null,
    Object? assignedToId = null,
    Object? assignedToName = null,
    Object? deadline = null,
    Object? oneLine = null,
    Object? memo = null,
    Object? relatedUrl = freezed,
    Object? projectId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TaskStatus,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as Priority,
            categories: null == categories
                ? _value.categories
                : categories // ignore: cast_nullable_to_non_nullable
                      as List<TaskCategory>,
            icon: freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdById: null == createdById
                ? _value.createdById
                : createdById // ignore: cast_nullable_to_non_nullable
                      as String,
            createdByName: null == createdByName
                ? _value.createdByName
                : createdByName // ignore: cast_nullable_to_non_nullable
                      as String,
            assignedToId: null == assignedToId
                ? _value.assignedToId
                : assignedToId // ignore: cast_nullable_to_non_nullable
                      as String,
            assignedToName: null == assignedToName
                ? _value.assignedToName
                : assignedToName // ignore: cast_nullable_to_non_nullable
                      as String,
            deadline: null == deadline
                ? _value.deadline
                : deadline // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            oneLine: null == oneLine
                ? _value.oneLine
                : oneLine // ignore: cast_nullable_to_non_nullable
                      as String,
            memo: null == memo
                ? _value.memo
                : memo // ignore: cast_nullable_to_non_nullable
                      as String,
            relatedUrl: freezed == relatedUrl
                ? _value.relatedUrl
                : relatedUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            projectId: null == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskModelImplCopyWith<$Res>
    implements $TaskModelCopyWith<$Res> {
  factory _$$TaskModelImplCopyWith(
    _$TaskModelImpl value,
    $Res Function(_$TaskModelImpl) then,
  ) = __$$TaskModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    @JsonKey(
      name: 'task_status',
      fromJson: _taskStatusFromJson,
      toJson: _taskStatusToJson,
    )
    TaskStatus status,
    @JsonKey(fromJson: _priorityFromJson, toJson: _priorityToJson)
    Priority priority,
    @JsonKey(
      name: 'task_category',
      fromJson: _categoriesFromJson,
      toJson: _categoriesToJson,
    )
    List<TaskCategory> categories,
    String? icon,
    @JsonKey(name: 'created_by') String createdById,
    @JsonKey(includeFromJson: false, includeToJson: false) String createdByName,
    @JsonKey(name: 'assigned_to') String assignedToId,
    @JsonKey(includeFromJson: false, includeToJson: false)
    String assignedToName,
    DateTime deadline,
    @JsonKey(name: 'one_line') String oneLine,
    String memo,
    @JsonKey(name: 'related_url') String? relatedUrl,
    @JsonKey(name: 'project_id') String projectId,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$TaskModelImplCopyWithImpl<$Res>
    extends _$TaskModelCopyWithImpl<$Res, _$TaskModelImpl>
    implements _$$TaskModelImplCopyWith<$Res> {
  __$$TaskModelImplCopyWithImpl(
    _$TaskModelImpl _value,
    $Res Function(_$TaskModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? status = null,
    Object? priority = null,
    Object? categories = null,
    Object? icon = freezed,
    Object? createdById = null,
    Object? createdByName = null,
    Object? assignedToId = null,
    Object? assignedToName = null,
    Object? deadline = null,
    Object? oneLine = null,
    Object? memo = null,
    Object? relatedUrl = freezed,
    Object? projectId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$TaskModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TaskStatus,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as Priority,
        categories: null == categories
            ? _value._categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as List<TaskCategory>,
        icon: freezed == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdById: null == createdById
            ? _value.createdById
            : createdById // ignore: cast_nullable_to_non_nullable
                  as String,
        createdByName: null == createdByName
            ? _value.createdByName
            : createdByName // ignore: cast_nullable_to_non_nullable
                  as String,
        assignedToId: null == assignedToId
            ? _value.assignedToId
            : assignedToId // ignore: cast_nullable_to_non_nullable
                  as String,
        assignedToName: null == assignedToName
            ? _value.assignedToName
            : assignedToName // ignore: cast_nullable_to_non_nullable
                  as String,
        deadline: null == deadline
            ? _value.deadline
            : deadline // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        oneLine: null == oneLine
            ? _value.oneLine
            : oneLine // ignore: cast_nullable_to_non_nullable
                  as String,
        memo: null == memo
            ? _value.memo
            : memo // ignore: cast_nullable_to_non_nullable
                  as String,
        relatedUrl: freezed == relatedUrl
            ? _value.relatedUrl
            : relatedUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        projectId: null == projectId
            ? _value.projectId
            : projectId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskModelImpl extends _TaskModel {
  const _$TaskModelImpl({
    required this.id,
    required this.title,
    @JsonKey(
      name: 'task_status',
      fromJson: _taskStatusFromJson,
      toJson: _taskStatusToJson,
    )
    required this.status,
    @JsonKey(fromJson: _priorityFromJson, toJson: _priorityToJson)
    required this.priority,
    @JsonKey(
      name: 'task_category',
      fromJson: _categoriesFromJson,
      toJson: _categoriesToJson,
    )
    required final List<TaskCategory> categories,
    this.icon,
    @JsonKey(name: 'created_by') required this.createdById,
    @JsonKey(includeFromJson: false, includeToJson: false)
    this.createdByName = '',
    @JsonKey(name: 'assigned_to') required this.assignedToId,
    @JsonKey(includeFromJson: false, includeToJson: false)
    this.assignedToName = '',
    required this.deadline,
    @JsonKey(name: 'one_line') this.oneLine = '',
    this.memo = '',
    @JsonKey(name: 'related_url') this.relatedUrl,
    @JsonKey(name: 'project_id') required this.projectId,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  }) : _categories = categories,
       super._();

  factory _$TaskModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskModelImplFromJson(json);

  /// タスクID (uuid)
  @override
  final String id;

  /// タスク名
  @override
  final String title;

  /// タスクステータス
  @override
  @JsonKey(
    name: 'task_status',
    fromJson: _taskStatusFromJson,
    toJson: _taskStatusToJson,
  )
  final TaskStatus status;

  /// 優先度
  @override
  @JsonKey(fromJson: _priorityFromJson, toJson: _priorityToJson)
  final Priority priority;

  /// タスクカテゴリ（配列）
  final List<TaskCategory> _categories;

  /// タスクカテゴリ（配列）
  @override
  @JsonKey(
    name: 'task_category',
    fromJson: _categoriesFromJson,
    toJson: _categoriesToJson,
  )
  List<TaskCategory> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  /// アイコン
  @override
  final String? icon;

  /// 作成者ID (uuid)
  @override
  @JsonKey(name: 'created_by')
  final String createdById;

  /// 作成者名（UIでの表示用、JSONには含めない）
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String createdByName;

  /// 担当者ID (uuid)
  @override
  @JsonKey(name: 'assigned_to')
  final String assignedToId;

  /// 担当者名（UIでの表示用、JSONには含めない）
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String assignedToName;

  /// 締切日時
  @override
  final DateTime deadline;

  /// 一行説明
  @override
  @JsonKey(name: 'one_line')
  final String oneLine;

  /// 詳細メモ
  @override
  @JsonKey()
  final String memo;

  /// 関連URL
  @override
  @JsonKey(name: 'related_url')
  final String? relatedUrl;

  /// プロジェクトID (uuid)
  @override
  @JsonKey(name: 'project_id')
  final String projectId;

  /// 作成日時
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// 更新日時
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, status: $status, priority: $priority, categories: $categories, icon: $icon, createdById: $createdById, createdByName: $createdByName, assignedToId: $assignedToId, assignedToName: $assignedToName, deadline: $deadline, oneLine: $oneLine, memo: $memo, relatedUrl: $relatedUrl, projectId: $projectId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.createdById, createdById) ||
                other.createdById == createdById) &&
            (identical(other.createdByName, createdByName) ||
                other.createdByName == createdByName) &&
            (identical(other.assignedToId, assignedToId) ||
                other.assignedToId == assignedToId) &&
            (identical(other.assignedToName, assignedToName) ||
                other.assignedToName == assignedToName) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.oneLine, oneLine) || other.oneLine == oneLine) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.relatedUrl, relatedUrl) ||
                other.relatedUrl == relatedUrl) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    status,
    priority,
    const DeepCollectionEquality().hash(_categories),
    icon,
    createdById,
    createdByName,
    assignedToId,
    assignedToName,
    deadline,
    oneLine,
    memo,
    relatedUrl,
    projectId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskModelImplCopyWith<_$TaskModelImpl> get copyWith =>
      __$$TaskModelImplCopyWithImpl<_$TaskModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskModelImplToJson(this);
  }
}

abstract class _TaskModel extends TaskModel {
  const factory _TaskModel({
    required final String id,
    required final String title,
    @JsonKey(
      name: 'task_status',
      fromJson: _taskStatusFromJson,
      toJson: _taskStatusToJson,
    )
    required final TaskStatus status,
    @JsonKey(fromJson: _priorityFromJson, toJson: _priorityToJson)
    required final Priority priority,
    @JsonKey(
      name: 'task_category',
      fromJson: _categoriesFromJson,
      toJson: _categoriesToJson,
    )
    required final List<TaskCategory> categories,
    final String? icon,
    @JsonKey(name: 'created_by') required final String createdById,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final String createdByName,
    @JsonKey(name: 'assigned_to') required final String assignedToId,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final String assignedToName,
    required final DateTime deadline,
    @JsonKey(name: 'one_line') final String oneLine,
    final String memo,
    @JsonKey(name: 'related_url') final String? relatedUrl,
    @JsonKey(name: 'project_id') required final String projectId,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$TaskModelImpl;
  const _TaskModel._() : super._();

  factory _TaskModel.fromJson(Map<String, dynamic> json) =
      _$TaskModelImpl.fromJson;

  /// タスクID (uuid)
  @override
  String get id;

  /// タスク名
  @override
  String get title;

  /// タスクステータス
  @override
  @JsonKey(
    name: 'task_status',
    fromJson: _taskStatusFromJson,
    toJson: _taskStatusToJson,
  )
  TaskStatus get status;

  /// 優先度
  @override
  @JsonKey(fromJson: _priorityFromJson, toJson: _priorityToJson)
  Priority get priority;

  /// タスクカテゴリ（配列）
  @override
  @JsonKey(
    name: 'task_category',
    fromJson: _categoriesFromJson,
    toJson: _categoriesToJson,
  )
  List<TaskCategory> get categories;

  /// アイコン
  @override
  String? get icon;

  /// 作成者ID (uuid)
  @override
  @JsonKey(name: 'created_by')
  String get createdById;

  /// 作成者名（UIでの表示用、JSONには含めない）
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get createdByName;

  /// 担当者ID (uuid)
  @override
  @JsonKey(name: 'assigned_to')
  String get assignedToId;

  /// 担当者名（UIでの表示用、JSONには含めない）
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get assignedToName;

  /// 締切日時
  @override
  DateTime get deadline;

  /// 一行説明
  @override
  @JsonKey(name: 'one_line')
  String get oneLine;

  /// 詳細メモ
  @override
  String get memo;

  /// 関連URL
  @override
  @JsonKey(name: 'related_url')
  String? get relatedUrl;

  /// プロジェクトID (uuid)
  @override
  @JsonKey(name: 'project_id')
  String get projectId;

  /// 作成日時
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// 更新日時
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskModelImplCopyWith<_$TaskModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
