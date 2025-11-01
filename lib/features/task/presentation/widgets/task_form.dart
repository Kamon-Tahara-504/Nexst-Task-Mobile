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
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../project/presentation/providers/project_provider.dart';

/// タスク入力フォームWidget
class TaskForm extends ConsumerStatefulWidget {
  final TaskModel? initialTask;
  final Function(TaskFormData) onSubmit;
  final bool isLoading;
  final bool showButton;
  final GlobalKey<FormState>? formKey;
  final ValueNotifier<bool>? submitTrigger;

  const TaskForm({
    super.key,
    this.initialTask,
    required this.onSubmit,
    this.isLoading = false,
    this.showButton = true,
    this.formKey,
    this.submitTrigger,
  });

  @override
  ConsumerState<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<TaskForm> {
  late final GlobalKey<FormState> _formKey;

  void _onSubmitTriggered() {
    if (widget.submitTrigger?.value == true) {
      _handleSubmit();
      // トリガーをリセット
      widget.submitTrigger?.value = false;
    }
  }

  /// フォームデータを取得（外部から呼び出し可能）
  TaskFormData? getFormData() {
    if (!_formKey.currentState!.validate()) {
      return null;
    }
    return TaskFormData(
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
  }

  /// フォームを送信（外部から呼び出し可能）
  void submit() {
    _handleSubmit();
  }

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
    _formKey = widget.formKey ?? GlobalKey<FormState>();
    if (widget.initialTask != null) {
      _initializeWithTask(widget.initialTask!);
    }
    // 外部送信トリガーを監視
    widget.submitTrigger?.addListener(_onSubmitTriggered);
  }

  @override
  void dispose() {
    widget.submitTrigger?.removeListener(_onSubmitTriggered);
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
    // final selectedProject = ref.watch(selectedProjectProvider).value;

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
                  child: _buildSelectableField(
                    label: '優先度',
                    icon: Icons.flag_outlined,
                    value: _priority.label,
                    onTap: (context, position) =>
                        _showPriorityPopup(context, position),
                    valueWidget: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _priority.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(_priority.label),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.space),
                Expanded(
                  child: _buildSelectableField(
                    label: 'ステータス',
                    icon: Icons.check_circle_outline,
                    value: _status.label,
                    onTap: (context, position) =>
                        _showStatusPopup(context, position),
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

            // 送信ボタン（showButtonがtrueの場合のみ表示）
            if (widget.showButton) ...[
              const SizedBox(height: AppSizes.spaceXl),
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
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
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
        InkWell(
          onTap: _showIconSelector,
          child: Container(
            padding: const EdgeInsets.all(AppSizes.padding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              border: Border.all(color: AppColors.glassBorder, width: 1),
            ),
            child: Row(
              children: [
                IconPreview(iconName: _selectedIcon, size: AppSizes.icon),
                const SizedBox(width: AppSizes.spaceSm),
                Expanded(
                  child: Text(
                    _selectedIcon != null ? _selectedIcon! : 'アイコンを選択',
                    style: TextStyle(
                      color: _selectedIcon != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// アイコン選択モーダルを表示
  void _showIconSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => IconSelectorModal(
        selectedIcon: _selectedIcon,
        onIconSelected: (iconName) {
          setState(() {
            _selectedIcon = iconName;
          });
        },
      ),
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
    final selectedProject = ref.watch(selectedProjectProvider).value;

    if (selectedProject == null) {
      return _buildSelectableField(
        label: '担当者',
        icon: Icons.person,
        value: currentUserId != null ? '自分' : '選択してください',
        onTap: (context, position) {}, // プロジェクト未選択時はタップ無効
      );
    }

    final projectMembers = ref.watch(
      projectMembersWithUserInfoProvider(selectedProject.id),
    );

    return projectMembers.when(
      data: (members) {
        // 選択中の担当者名を取得
        String displayValue = '選択してください';
        if (_assignedToId != null) {
          try {
            final selectedMember = members.firstWhere(
              (m) => m.id == _assignedToId,
            );
            displayValue = selectedMember.displayName;
          } catch (e) {
            // メンバーが見つからない場合は自分を表示
            if (currentUserId != null && _assignedToId == currentUserId) {
              displayValue = '自分';
            }
          }
        } else if (currentUserId != null) {
          displayValue = '自分';
        }

        return _buildSelectableField(
          label: '担当者',
          icon: Icons.person,
          value: displayValue,
          onTap: (context, position) =>
              _showAssigneePopup(context, position, members, currentUserId),
        );
      },
      loading: () => _buildSelectableField(
        label: '担当者',
        icon: Icons.person,
        value: currentUserId != null ? '自分' : '読み込み中...',
        onTap: (context, position) {}, // 読み込み中はタップ無効
      ),
      error: (_, __) => _buildSelectableField(
        label: '担当者',
        icon: Icons.person,
        value: currentUserId != null ? '自分' : 'エラー',
        onTap: (context, position) {}, // エラー時はタップ無効
      ),
    );
  }

  /// 選択可能なフィールドを構築
  Widget _buildSelectableField({
    required String label,
    required IconData icon,
    required String value,
    required void Function(BuildContext, RelativeRect) onTap,
    Widget? valueWidget,
  }) {
    final GlobalKey fieldKey = GlobalKey();
    return GestureDetector(
      onTap: () {
        try {
          final BuildContext? fieldContext = fieldKey.currentContext;
          if (fieldContext == null) return;

          final RenderBox? renderBox =
              fieldContext.findRenderObject() as RenderBox?;
          if (renderBox == null || !renderBox.hasSize) return;

          final screenSize = MediaQuery.of(context).size;
          final globalPosition = renderBox.localToGlobal(Offset.zero);
          final fieldBottom = globalPosition.dy + renderBox.size.height;

          // フィールドの下に表示する位置を計算
          final position = RelativeRect.fromLTRB(
            globalPosition.dx, // フィールドの左端
            fieldBottom, // フィールドの下
            screenSize.width -
                (globalPosition.dx + renderBox.size.width), // 右端からの距離
            screenSize.height - fieldBottom, // 下からの距離
          );
          onTap(context, position);
        } catch (e) {
          // エラーが発生した場合はデフォルトの位置で表示
          debugPrint('Error calculating popup position: $e');
          final screenSize = MediaQuery.of(context).size;
          final position = RelativeRect.fromLTRB(
            0,
            screenSize.height * 0.5,
            screenSize.width,
            screenSize.height * 0.5,
          );
          onTap(context, position);
        }
      },
      child: Container(
        key: fieldKey,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.glassBorder, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            suffixIcon: const Icon(Icons.arrow_drop_down),
          ),
          child: valueWidget ?? Text(value),
        ),
      ),
    );
  }

  /// 優先度選択ポップアップを表示
  Future<void> _showPriorityPopup(
    BuildContext context,
    RelativeRect position,
  ) async {
    try {
      final items = Priority.values.map((priority) {
        final isSelected = priority == _priority;
        return PopupMenuItem<Priority>(
          value: priority,
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: priority.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(priority.label)),
              if (isSelected)
                const Icon(Icons.check, color: AppColors.primary, size: 20),
            ],
          ),
        );
      }).toList();

      final selected = await showMenu<Priority>(
        context: context,
        position: position,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 8,
        items: items,
      );

      if (selected != null) {
        setState(() {
          _priority = selected;
        });
      }
    } catch (e, stackTrace) {
      debugPrint('Error showing priority popup: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// ステータス選択ポップアップを表示
  Future<void> _showStatusPopup(
    BuildContext context,
    RelativeRect position,
  ) async {
    try {
      final items = TaskStatus.values.map((status) {
        final isSelected = status == _status;
        return PopupMenuItem<TaskStatus>(
          value: status,
          child: Row(
            children: [
              Expanded(child: Text(status.label)),
              if (isSelected)
                const Icon(Icons.check, color: AppColors.primary, size: 20),
            ],
          ),
        );
      }).toList();

      final selected = await showMenu<TaskStatus>(
        context: context,
        position: position,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 8,
        items: items,
      );

      if (selected != null) {
        setState(() {
          _status = selected;
        });
      }
    } catch (e, stackTrace) {
      debugPrint('Error showing status popup: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// 担当者選択ポップアップを表示
  Future<void> _showAssigneePopup(
    BuildContext context,
    RelativeRect position,
    List<UserModel> members,
    String? currentUserId,
  ) async {
    final items = <String?>[];
    final displayNames = <String?, String>{};

    // 自分を最初に追加
    if (currentUserId != null) {
      items.add(currentUserId);
      displayNames[currentUserId] = '自分';
    }

    // プロジェクトメンバーを追加
    for (final member in members) {
      if (member.id != currentUserId) {
        items.add(member.id);
        displayNames[member.id] = member.displayName;
      }
    }

    final menuItems = items.map((id) {
      final isSelected = id == _assignedToId;
      return PopupMenuItem<String>(
        value: id,
        child: Row(
          children: [
            const Icon(Icons.person, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(displayNames[id] ?? '')),
            if (isSelected)
              const Icon(Icons.check, color: AppColors.primary, size: 20),
          ],
        ),
      );
    }).toList();

    try {
      final selected = await showMenu<String>(
        context: context,
        position: position,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 8,
        items: menuItems,
      );

      if (selected != null) {
        setState(() {
          _assignedToId = selected;
        });
      }
    } catch (e, stackTrace) {
      debugPrint('Error showing assignee popup: $e');
      debugPrint('Stack trace: $stackTrace');
    }
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
