import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import '../../../../shared/widgets/icon_selector.dart';
import '../../data/models/task_model.dart';
import '../../domain/enums/task_status.dart';
import '../../domain/enums/task_category.dart';
import '../../domain/enums/priority.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../project/presentation/providers/project_provider.dart';
import 'priority_badge.dart';

/// タスク入力フォームWidget
class TaskForm extends ConsumerStatefulWidget {
  final TaskModel? initialTask;
  final Function(TaskFormData) onSubmit;
  final bool isLoading;

  const TaskForm({
    super.key,
    this.initialTask,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  ConsumerState<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _oneLineController = TextEditingController();
  final _memoController = TextEditingController();
  final _relatedUrlController = TextEditingController();

  TaskStatus _status = TaskStatus.todo;
  Priority _priority = Priority.low;
  List<TaskCategory> _categories = [];
  String? _selectedIcon;
  DateTime _deadline = DateTime.now().add(const Duration(days: 7));
  String? _assignedToId;

  @override
  void initState() {
    super.initState();
    if (widget.initialTask != null) {
      _initializeWithTask(widget.initialTask!);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _oneLineController.dispose();
    _memoController.dispose();
    _relatedUrlController.dispose();
    super.dispose();
  }

  void _initializeWithTask(TaskModel task) {
    _titleController.text = task.title;
    _oneLineController.text = task.oneLine;
    _memoController.text = task.memo;
    _relatedUrlController.text = task.relatedUrl ?? '';
    _status = task.status;
    _priority = task.priority;
    _categories = List.from(task.categories);
    _selectedIcon = task.icon;
    _deadline = task.deadline;
    _assignedToId = task.assignedToId;
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).value;
    final selectedProject = ref.watch(selectedProjectProvider).value;

    return LiquidGlassContainer(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // タイトル
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: AppStrings.taskTitle,
                prefixIcon: Icon(Icons.title),
                hintText: 'タスクのタイトルを入力してください',
              ),
              validator: (value) => Validators.validateTaskTitle(value),
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: AppSizes.space),

            // 一行説明
            TextFormField(
              controller: _oneLineController,
              decoration: const InputDecoration(
                labelText: '一行説明（任意）',
                prefixIcon: Icon(Icons.description),
                hintText: 'タスクの概要を一行で説明',
              ),
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: AppSizes.space),

            // 優先度とステータス
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<Priority>(
                    value: _priority,
                    decoration: const InputDecoration(
                      labelText: '優先度',
                      prefixIcon: Icon(Icons.flag_outlined),
                    ),
                    items: Priority.values.map((priority) {
                      return DropdownMenuItem<Priority>(
                        value: priority,
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: priority.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(priority.label),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _priority = value;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: AppSizes.space),
                Expanded(
                  child: DropdownButtonFormField<TaskStatus>(
                    value: _status,
                    decoration: const InputDecoration(
                      labelText: 'ステータス',
                      prefixIcon: Icon(Icons.check_circle_outline),
                    ),
                    items: TaskStatus.values.map((status) {
                      return DropdownMenuItem<TaskStatus>(
                        value: status,
                        child: Text(status.label),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _status = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.space),

            // カテゴリ選択
            _buildCategorySelector(),

            const SizedBox(height: AppSizes.space),

            // アイコン選択
            _buildIconSelector(),

            const SizedBox(height: AppSizes.space),

            // 締切日
            _buildDeadlineSelector(),

            const SizedBox(height: AppSizes.space),

            // 担当者選択
            _buildAssigneeSelector(currentUser?.id),

            const SizedBox(height: AppSizes.space),

            // 詳細メモ
            TextFormField(
              controller: _memoController,
              decoration: const InputDecoration(
                labelText: '詳細メモ（任意）',
                prefixIcon: Icon(Icons.notes),
                hintText: 'タスクの詳細な説明やメモ',
              ),
              maxLines: 3,
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: AppSizes.space),

            // 関連URL
            TextFormField(
              controller: _relatedUrlController,
              decoration: const InputDecoration(
                labelText: '関連URL（任意）',
                prefixIcon: Icon(Icons.link),
                hintText: 'https://example.com',
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return Validators.validateUrl(value);
                }
                return null;
              },
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
            ),

            const SizedBox(height: AppSizes.spaceXl),

            // 送信ボタン
            ElevatedButton(
              onPressed: widget.isLoading ? null : _handleSubmit,
              child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      widget.initialTask != null
                          ? AppStrings.updateTask
                          : AppStrings.createTask,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// カテゴリ選択を構築
  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'カテゴリ（複数選択可）',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TaskCategory.values.map((category) {
            final isSelected = _categories.contains(category);
            return FilterChip(
              label: Text(category.label),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _categories.add(category);
                  } else {
                    _categories.remove(category);
                  }
                });
              },
              selectedColor: AppColors.primary.withOpacity(0.3),
              checkmarkColor: AppColors.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  /// アイコン選択を構築
  Widget _buildIconSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'アイコン（任意）',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        IconSelector(
          selectedIcon: _selectedIcon,
          onIconSelected: (iconName) {
            setState(() {
              _selectedIcon = iconName;
            });
          },
        ),
      ],
    );
  }

  /// 締切日選択を構築
  Widget _buildDeadlineSelector() {
    return InkWell(
      onTap: _selectDeadline,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: '締切日',
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_deadline.year}/${_deadline.month}/${_deadline.day}',
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  /// 担当者選択を構築
  Widget _buildAssigneeSelector(String? currentUserId) {
    return DropdownButtonFormField<String>(
      value: _assignedToId ?? currentUserId,
      decoration: const InputDecoration(
        labelText: '担当者',
        prefixIcon: Icon(Icons.person),
      ),
      items: [
        DropdownMenuItem<String>(value: currentUserId, child: const Text('自分')),
        // TODO: プロジェクトメンバー一覧を取得して表示
      ],
      onChanged: (value) {
        setState(() {
          _assignedToId = value;
        });
      },
    );
  }

  /// 締切日選択
  Future<void> _selectDeadline() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      setState(() {
        _deadline = selectedDate;
      });
    }
  }

  /// フォーム送信処理
  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final formData = TaskFormData(
      title: _titleController.text.trim(),
      status: _status,
      priority: _priority,
      categories: _categories,
      icon: _selectedIcon,
      assignedToId: _assignedToId ?? '',
      deadline: _deadline,
      oneLine: _oneLineController.text.trim(),
      memo: _memoController.text.trim(),
      relatedUrl: _relatedUrlController.text.trim().isEmpty
          ? null
          : _relatedUrlController.text.trim(),
    );

    widget.onSubmit(formData);
  }
}

/// タスクフォームデータ
class TaskFormData {
  final String title;
  final TaskStatus status;
  final Priority priority;
  final List<TaskCategory> categories;
  final String? icon;
  final String assignedToId;
  final DateTime deadline;
  final String oneLine;
  final String memo;
  final String? relatedUrl;

  const TaskFormData({
    required this.title,
    required this.status,
    required this.priority,
    required this.categories,
    this.icon,
    required this.assignedToId,
    required this.deadline,
    required this.oneLine,
    required this.memo,
    this.relatedUrl,
  });
}
