import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// 利用可能なアイコンのリスト（Web版から取得）
const List<String> availableIcons = [
  'angular',
  'aws',
  'bootstrap',
  'cpp',
  'csharp',
  'css3',
  'dart',
  'django',
  'docker',
  'express',
  'figma',
  'flutter',
  'git',
  'github',
  'go',
  'html5',
  'java',
  'javascript',
  'jest',
  'kotlin',
  'mongodb',
  'mysql',
  'nextjs',
  'nodejs',
  'npm',
  'nuxtjs',
  'php',
  'postgresql',
  'python',
  'react',
  'redux',
  'ruby',
  'rust',
  'sass',
  'spring',
  'swift',
  'tailwindcss',
  'typescript',
  'vite',
  'vscode',
  'vue',
  'webpack',
  'yarn',
];

/// アイコン選択Widget
class IconSelector extends StatelessWidget {
  /// 現在選択されているアイコン
  final String? selectedIcon;

  /// アイコン選択時のコールバック
  final ValueChanged<String?> onIconSelected;

  /// グリッドの列数
  final int crossAxisCount;

  const IconSelector({
    super.key,
    this.selectedIcon,
    required this.onIconSelected,
    this.crossAxisCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSizes.spaceSm,
        mainAxisSpacing: AppSizes.spaceSm,
        childAspectRatio: 1,
      ),
      itemCount: availableIcons.length + 1, // +1 for "None" option
      itemBuilder: (context, index) {
        if (index == 0) {
          // "アイコンなし" オプション
          return _IconItem(
            iconName: null,
            isSelected: selectedIcon == null,
            onTap: () => onIconSelected(null),
          );
        }

        final iconName = availableIcons[index - 1];
        return _IconItem(
          iconName: iconName,
          isSelected: selectedIcon == iconName,
          onTap: () => onIconSelected(iconName),
        );
      },
    );
  }
}

/// アイコン項目Widget
class _IconItem extends StatelessWidget {
  final String? iconName;
  final bool isSelected;
  final VoidCallback onTap;

  const _IconItem({
    this.iconName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.glassBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.glassBorder,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        padding: const EdgeInsets.all(AppSizes.paddingSm),
        child: iconName != null
            ? SvgPicture.asset(
                'assets/icons/$iconName.svg',
                width: AppSizes.icon,
                height: AppSizes.icon,
              )
            : const Icon(
                Icons.block,
                size: AppSizes.icon,
                color: AppColors.textDisabled,
              ),
      ),
    );
  }
}

/// アイコンプレビューWidget
class IconPreview extends StatelessWidget {
  /// アイコン名
  final String? iconName;

  /// サイズ
  final double size;

  const IconPreview({super.key, this.iconName, this.size = AppSizes.iconLg});

  @override
  Widget build(BuildContext context) {
    if (iconName == null || iconName!.isEmpty) {
      return Icon(Icons.code, size: size, color: AppColors.textDisabled);
    }

    return SvgPicture.asset(
      'assets/icons/$iconName.svg',
      width: size,
      height: size,
      placeholderBuilder: (context) => Icon(
        Icons.image_not_supported,
        size: size,
        color: AppColors.textDisabled,
      ),
    );
  }
}
