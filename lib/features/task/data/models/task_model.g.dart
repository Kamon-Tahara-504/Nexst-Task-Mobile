// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskModelImpl _$$TaskModelImplFromJson(Map<String, dynamic> json) =>
    _$TaskModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      status: _taskStatusFromJson(json['task_status']),
      priority: _priorityFromJson(json['priority']),
      categories: _categoriesFromJson(json['task_category']),
      icon: json['icon'] as String?,
      createdById: json['created_by'] as String,
      assignedToId: json['assigned_to'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      oneLine: json['one_line'] as String? ?? '',
      memo: json['memo'] as String? ?? '',
      relatedUrl: json['related_url'] as String?,
      projectId: json['project_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$TaskModelImplToJson(_$TaskModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'task_status': _taskStatusToJson(instance.status),
      'priority': _priorityToJson(instance.priority),
      'task_category': _categoriesToJson(instance.categories),
      'icon': instance.icon,
      'created_by': instance.createdById,
      'assigned_to': instance.assignedToId,
      'deadline': instance.deadline.toIso8601String(),
      'one_line': instance.oneLine,
      'memo': instance.memo,
      'related_url': instance.relatedUrl,
      'project_id': instance.projectId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
