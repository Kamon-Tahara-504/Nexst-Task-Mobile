// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectMemberModelImpl _$$ProjectMemberModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProjectMemberModelImpl(
  id: json['id'] as String,
  projectId: json['project_id'] as String,
  userId: json['user_id'] as String,
  role: json['role'] == null
      ? ProjectMemberRole.member
      : _roleFromJson(json['role']),
  isActive: json['is_active'] as bool? ?? true,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$ProjectMemberModelImplToJson(
  _$ProjectMemberModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'project_id': instance.projectId,
  'user_id': instance.userId,
  'role': _roleToJson(instance.role),
  'is_active': instance.isActive,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
