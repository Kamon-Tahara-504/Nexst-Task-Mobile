import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import '../../data/models/project_model.dart';
import '../providers/project_provider.dart';

/// プロジェクトカードWidget
class ProjectCard extends ConsumerWidget {
  final ProjectModel project;
  final VoidCallback onTap;

  const ProjectCard({super.key, required this.project, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberCountAsync = ref.watch(projectMemberCountProvider(project.id));

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.space),
      child: LiquidGlassCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // プロジェクト名
            Row(
              children: [
                const Icon(
                  Icons.folder,
                  color: AppColors.primary,
                  size: AppSizes.iconLg,
                ),
                const SizedBox(width: AppSizes.spaceSm),
                Expanded(
                  child: Text(
                    project.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: AppSizes.iconSm,
                ),
              ],
            ),

            const SizedBox(height: AppSizes.spaceSm),

            // プロジェクトコード
            Row(
              children: [
                const Icon(
                  Icons.vpn_key,
                  color: Colors.white,
                  size: AppSizes.iconSm,
                ),
                const SizedBox(width: AppSizes.spaceXs),
                Text(
                  'コード: ${project.code}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.spaceXs),

            // メンバー数
            memberCountAsync.when(
              data: (count) => Row(
                children: [
                  const Icon(
                    Icons.people,
                    color: Colors.white,
                    size: AppSizes.iconSm,
                  ),
                  const SizedBox(width: AppSizes.spaceXs),
                  Text(
                    'メンバー: $count人',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
