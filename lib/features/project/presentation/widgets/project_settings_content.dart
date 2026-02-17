import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../providers/project_provider.dart';
import '../../data/models/project_member_model.dart';
import '../../data/models/project_model.dart';
import '../../data/repositories/project_repository.dart';
import '../../../auth/data/models/user_model.dart';

/// タスク一覧と同じカード形式で表示するプロジェクト設定コンテンツ（下部ナビ・フル画面共通）
class ProjectSettingsContent extends ConsumerStatefulWidget {
  const ProjectSettingsContent({
    super.key,
    required this.projectId,
    this.onSaved,
  });

  final String projectId;
  /// 保存成功時に呼ぶ（フル画面で閉じる用）
  final VoidCallback? onSaved;

  @override
  ConsumerState<ProjectSettingsContent> createState() =>
      _ProjectSettingsContentState();
}

class _ProjectSettingsContentState extends ConsumerState<ProjectSettingsContent> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _isSaving = false;
  bool _hasSetInitialValues = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    context.unfocus();
    setState(() => _isSaving = true);
    try {
      final repository = ref.read(projectRepositoryProvider);
      await repository.updateProject(
        widget.projectId,
        name: _nameController.text.trim(),
      );
      ref.invalidate(projectByIdProvider(widget.projectId));
      ref.invalidate(selectedProjectProvider);
      ref.invalidate(userProjectsProvider);
      if (mounted) {
        context.showSuccessSnackbar('プロジェクトを更新しました');
        widget.onSaved?.call();
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackbar(
          'プロジェクトの更新に失敗しました: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _handleLeaveProject() async {
    final confirmed = await context.showConfirmDialog(
      title: 'プロジェクトから退出',
      message: '本当にこのワークスペースから抜けますか？',
    );
    if (!confirmed) return;
    try {
      final member = await ref
          .read(currentUserProjectMemberProvider(widget.projectId).future);
      if (member == null) {
        if (mounted) context.showErrorSnackbar('このプロジェクトのメンバーではありません');
        return;
      }
      final members =
          await ref.read(projectMembersProvider(widget.projectId).future);
      final adminCount = members.where((m) => m.role.isAdmin).length;
      if (member.role.isAdmin && adminCount <= 1) {
        if (mounted) {
          context.showErrorSnackbar(
            '管理者が自分だけのため、別のメンバーを管理者にしてから退出してください',
          );
        }
        return;
      }
      final repository = ref.read(projectRepositoryProvider);
      await repository.removeMemberFromProject(member.id);
      await ref.read(selectedProjectIdProvider.notifier).clearSelectedProject();
      ref.invalidate(userProjectsProvider);
      ref.invalidate(selectedProjectProvider);
      if (mounted) {
        context.go(AppRoutes.home);
        context.showSuccessSnackbar('プロジェクトから退出しました');
      }
    } catch (e) {
      if (mounted) context.showErrorSnackbar('退出に失敗しました: $e');
    }
  }

  /// タスクカード風の白いカード
  Widget _card({
    required Widget child,
    EdgeInsets? padding,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.space),
      padding: padding ?? const EdgeInsets.all(AppSizes.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLiquidGlass),
        border: Border.all(color: AppColors.glassBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final projectAsync = ref.watch(projectByIdProvider(widget.projectId));
    final membersAsync = ref.watch(projectMembersProvider(widget.projectId));
    final usersAsync =
        ref.watch(projectMembersWithUserInfoProvider(widget.projectId));

    return projectAsync.when(
      data: (project) {
        if (project == null) {
          return Center(
            child: Text(
              'プロジェクトが見つかりません',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          );
        }
        if (!_hasSetInitialValues) {
          _nameController.text = project.name;
          _hasSetInitialValues = true;
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProjectInfoCard(project),
                _buildMembersCard(context, membersAsync, usersAsync),
                _card(
                  child: FilledButton.icon(
                    onPressed: _isSaving ? null : _handleSave,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(_isSaving ? '保存中...' : '保存'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.padding,
                      ),
                    ),
                  ),
                ),
                _card(
                  child: OutlinedButton.icon(
                    onPressed: _handleLeaveProject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.paddingSm,
                      ),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text('このワークスペースから抜ける'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: LoadingIndicator()),
      error: (err, _) => Center(
        child: Text(
          '読み込みに失敗しました: $err',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildProjectInfoCard(ProjectModel project) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'プロジェクト情報',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: AppSizes.space),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: AppStrings.projectName,
              hintText: AppStrings.placeholderProjectName,
              prefixIcon: Icon(Icons.folder),
              border: OutlineInputBorder(),
            ),
            validator: Validators.validateProjectName,
          ),
          const SizedBox(height: AppSizes.space),
          Row(
            children: [
              const Icon(Icons.vpn_key, color: AppColors.textSecondary),
              const SizedBox(width: AppSizes.spaceSm),
              Expanded(
                child: Text(
                  project.code,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: project.code));
                  if (context.mounted) {
                    context.showSuccessSnackbar('プロジェクトコードをコピーしました');
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMembersCard(
    BuildContext context,
    AsyncValue<List<ProjectMemberModel>> membersAsync,
    AsyncValue<List<UserModel>> usersAsync,
  ) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'メンバー',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: AppSizes.space),
          membersAsync.when(
            data: (members) {
              return usersAsync.when(
                data: (users) {
                  if (members.isEmpty) {
                    return Text(
                      'メンバーがいません',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    );
                  }
                  final userById = <String, UserModel>{
                    for (final u in users) u.id: u,
                  };
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: members.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSizes.spaceSm),
                    itemBuilder: (context, index) {
                      final member = members[index];
                      final user = userById[member.userId];
                      final displayName = user?.displayName ??
                          '不明なユーザー (${member.userId})';
                      return _memberCard(
                        displayName: displayName,
                        roleLabel: member.roleLabel,
                      );
                    },
                  );
                },
                loading: () => const Center(
                    child: Padding(
                  padding: EdgeInsets.all(AppSizes.space),
                  child: LoadingIndicator(),
                )),
                error: (e, _) => Text(
                  'メンバー情報の取得に失敗しました: $e',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.error,
                      ),
                ),
              );
            },
            loading: () => const Center(
                child: Padding(
              padding: EdgeInsets.all(AppSizes.space),
              child: LoadingIndicator(),
            )),
            error: (e, _) => Text(
              'メンバーの取得に失敗しました: $e',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  /// 1メンバー分のタスクカード風カード
  Widget _memberCard({
    required String displayName,
    required String roleLabel,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.padding,
        vertical: AppSizes.paddingSm,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.glassBorder.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            child: Text(
              displayName.isNotEmpty
                  ? displayName.characters.first.toUpperCase()
                  : '?',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.space),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                ),
                Text(
                  roleLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
