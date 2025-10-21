// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_member_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProjectMemberModel _$ProjectMemberModelFromJson(Map<String, dynamic> json) {
  return _ProjectMemberModel.fromJson(json);
}

/// @nodoc
mixin _$ProjectMemberModel {
  /// メンバーシップID (uuid)
  String get id => throw _privateConstructorUsedError;

  /// プロジェクトID (uuid)
  @JsonKey(name: 'project_id')
  String get projectId => throw _privateConstructorUsedError;

  /// ユーザーID (uuid)
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;

  /// プロジェクト内での役割
  String get role => throw _privateConstructorUsedError;

  /// アクティブ状態
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// 作成日時
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 更新日時
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ProjectMemberModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectMemberModelCopyWith<ProjectMemberModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectMemberModelCopyWith<$Res> {
  factory $ProjectMemberModelCopyWith(
    ProjectMemberModel value,
    $Res Function(ProjectMemberModel) then,
  ) = _$ProjectMemberModelCopyWithImpl<$Res, ProjectMemberModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'project_id') String projectId,
    @JsonKey(name: 'user_id') String userId,
    String role,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$ProjectMemberModelCopyWithImpl<$Res, $Val extends ProjectMemberModel>
    implements $ProjectMemberModelCopyWith<$Res> {
  _$ProjectMemberModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? userId = null,
    Object? role = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            projectId: null == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$ProjectMemberModelImplCopyWith<$Res>
    implements $ProjectMemberModelCopyWith<$Res> {
  factory _$$ProjectMemberModelImplCopyWith(
    _$ProjectMemberModelImpl value,
    $Res Function(_$ProjectMemberModelImpl) then,
  ) = __$$ProjectMemberModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'project_id') String projectId,
    @JsonKey(name: 'user_id') String userId,
    String role,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$ProjectMemberModelImplCopyWithImpl<$Res>
    extends _$ProjectMemberModelCopyWithImpl<$Res, _$ProjectMemberModelImpl>
    implements _$$ProjectMemberModelImplCopyWith<$Res> {
  __$$ProjectMemberModelImplCopyWithImpl(
    _$ProjectMemberModelImpl _value,
    $Res Function(_$ProjectMemberModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProjectMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? userId = null,
    Object? role = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$ProjectMemberModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        projectId: null == projectId
            ? _value.projectId
            : projectId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$ProjectMemberModelImpl extends _ProjectMemberModel {
  const _$ProjectMemberModelImpl({
    required this.id,
    @JsonKey(name: 'project_id') required this.projectId,
    @JsonKey(name: 'user_id') required this.userId,
    this.role = 'member',
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  }) : super._();

  factory _$ProjectMemberModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectMemberModelImplFromJson(json);

  /// メンバーシップID (uuid)
  @override
  final String id;

  /// プロジェクトID (uuid)
  @override
  @JsonKey(name: 'project_id')
  final String projectId;

  /// ユーザーID (uuid)
  @override
  @JsonKey(name: 'user_id')
  final String userId;

  /// プロジェクト内での役割
  @override
  @JsonKey()
  final String role;

  /// アクティブ状態
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

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
    return 'ProjectMemberModel(id: $id, projectId: $projectId, userId: $userId, role: $role, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectMemberModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
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
    projectId,
    userId,
    role,
    isActive,
    createdAt,
    updatedAt,
  );

  /// Create a copy of ProjectMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectMemberModelImplCopyWith<_$ProjectMemberModelImpl> get copyWith =>
      __$$ProjectMemberModelImplCopyWithImpl<_$ProjectMemberModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectMemberModelImplToJson(this);
  }
}

abstract class _ProjectMemberModel extends ProjectMemberModel {
  const factory _ProjectMemberModel({
    required final String id,
    @JsonKey(name: 'project_id') required final String projectId,
    @JsonKey(name: 'user_id') required final String userId,
    final String role,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$ProjectMemberModelImpl;
  const _ProjectMemberModel._() : super._();

  factory _ProjectMemberModel.fromJson(Map<String, dynamic> json) =
      _$ProjectMemberModelImpl.fromJson;

  /// メンバーシップID (uuid)
  @override
  String get id;

  /// プロジェクトID (uuid)
  @override
  @JsonKey(name: 'project_id')
  String get projectId;

  /// ユーザーID (uuid)
  @override
  @JsonKey(name: 'user_id')
  String get userId;

  /// プロジェクト内での役割
  @override
  String get role;

  /// アクティブ状態
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// 作成日時
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// 更新日時
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of ProjectMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectMemberModelImplCopyWith<_$ProjectMemberModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
