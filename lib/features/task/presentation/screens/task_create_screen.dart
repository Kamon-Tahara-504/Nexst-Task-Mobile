import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../project/presentation/providers/project_provider.dart';
import '../../data/repositories/task_repository.dart';
import '../providers/task_provider.dart';
import '../widgets/task_form.dart';

/// タスク作成画面
class TaskCreateScreen extends ConsumerStatefulWidget {
  const TaskCreateScreen({super.key});

  @override
  ConsumerState<TaskCreateScreen> createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends ConsumerState<TaskCreateScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final selectedProject = ref.watch(selectedProjectProvider).value;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            AppStrings.createTask,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: selectedProject == null
              ? _buildNoProjectSelected()
              : _buildTaskForm(),
        ),
      ),
    );
  }

  /// プロジェクト未選択時の表示
  Widget _buildNoProjectSelected() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_off, size: 80, color: Colors.white),
          SizedBox(height: AppSizes.spaceXl),
          Text(
            'プロジェクトが選択されていません',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppSizes.space),
          Text(
            'プロジェクトを選択してからタスクを作成してください',
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// タスクフォームを構築
  Widget _buildTaskForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: TaskForm(isLoading: _isLoading, onSubmit: _handleCreateTask),
    );
  }

  /// タスク作成処理
  Future<void> _handleCreateTask(TaskFormData formData) async {
    final selectedProject = ref.read(selectedProjectProvider).value;
    if (selectedProject == null) {
      context.showErrorSnackbar('プロジェクトが選択されていません');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final repository = ref.read(taskRepositoryProvider);

      await repository.createTask(
        title: formData.title,
        assignedToId: formData.assignedToId,
        deadline: formData.deadline,
        projectId: selectedProject.id,
        status: formData.status,
        priority: formData.priority,
        categories: formData.categories,
        icon: formData.icon,
        oneLine: formData.oneLine,
        memo: formData.memo,
        relatedUrl: formData.relatedUrl,
      );

      if (mounted) {
        context.showSuccessSnackbar('タスクを作成しました');
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackbar('タスクの作成に失敗しました: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
