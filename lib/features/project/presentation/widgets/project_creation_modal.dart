import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../data/repositories/project_repository.dart';
import '../providers/project_provider.dart';

/// プロジェクト作成モーダル
class ProjectCreationModal extends ConsumerStatefulWidget {
  const ProjectCreationModal({super.key});

  @override
  ConsumerState<ProjectCreationModal> createState() =>
      _ProjectCreationModalState();
}

class _ProjectCreationModalState extends ConsumerState<ProjectCreationModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    // バリデーション
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // フォーカスを外す
    context.unfocus();

    ref.read(projectCreatingProvider.notifier).state = true;

    try {
      final repository = ref.read(projectRepositoryProvider);
      final project = await repository.createProject(
        name: _nameController.text.trim(),
        code: _codeController.text.trim(),
      );

      // プロジェクト選択
      await ref
          .read(selectedProjectIdProvider.notifier)
          .selectProject(project.id);

      // プロジェクト一覧を更新
      ref.invalidate(userProjectsProvider);

      if (mounted) {
        Navigator.pop(context);
        context.showSuccessSnackbar('プロジェクトを作成しました');
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackbar('プロジェクトの作成に失敗しました: ${e.toString()}');
      }
    } finally {
      ref.read(projectCreatingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCreating = ref.watch(projectCreatingProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: LiquidGlassContainer(
        padding: const EdgeInsets.all(AppSizes.paddingXl),
        opacity: 0.95,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ヘッダー
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.createProject,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: isCreating ? null : () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.spaceXl),

              // プロジェクト名
              TextFormField(
                controller: _nameController,
                enabled: !isCreating,
                decoration: InputDecoration(
                  labelText: AppStrings.projectName,
                  hintText: AppStrings.placeholderProjectName,
                  prefixIcon: const Icon(Icons.folder),
                ),
                validator: Validators.validateProjectName,
              ),

              const SizedBox(height: AppSizes.spaceLg),

              // プロジェクトコード
              TextFormField(
                controller: _codeController,
                enabled: !isCreating,
                decoration: InputDecoration(
                  labelText: AppStrings.projectCode,
                  hintText: AppStrings.placeholderProjectCode,
                  prefixIcon: const Icon(Icons.vpn_key),
                  helperText: '英数字、ハイフン、アンダースコアのみ（4-20文字）',
                ),
                validator: Validators.validateProjectCode,
              ),

              const SizedBox(height: AppSizes.spaceXxl),

              // アクションボタン
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isCreating ? null : () => Navigator.pop(context),
                    child: const Text(AppStrings.cancel),
                  ),
                  const SizedBox(width: AppSizes.spaceSm),
                  ElevatedButton(
                    onPressed: isCreating ? null : _handleCreate,
                    child: isCreating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(AppStrings.create),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
