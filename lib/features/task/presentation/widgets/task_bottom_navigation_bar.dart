import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// タスクボード用の下部ナビゲーションバー
class TaskBottomNavigationBar extends ConsumerWidget {
  /// 現在選択されているインデックス（0: 未着手, 1: 進行中, 2: 完了）
  final int currentIndex;

  /// ナビゲーションアイテムがタップされた時のコールバック
  final void Function(int index) onNavItemTapped;

  const TaskBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onNavItemTapped,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusLiquidGlass),
          topRight: Radius.circular(AppSizes.radiusLiquidGlass),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.glassShadow,
            blurRadius: AppSizes.glassShadowBlur,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: Colors.black.withOpacity(0.05),
            width: AppSizes.glassBorderWidth,
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusLiquidGlass),
          topRight: Radius.circular(AppSizes.radiusLiquidGlass),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.padding,
              vertical: AppSizes.paddingSm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.pause_circle_outline,
                  label: '未着手',
                  index: 0,
                  isSelected: currentIndex == 0,
                  onTap: () => onNavItemTapped(0),
                ),
                _NavItem(
                  icon: Icons.play_circle_outline,
                  label: '進行中',
                  index: 1,
                  isSelected: currentIndex == 1,
                  onTap: () => onNavItemTapped(1),
                ),
                _NavItem(
                  icon: Icons.check_circle_outline,
                  label: '完了',
                  index: 2,
                  isSelected: currentIndex == 2,
                  onTap: () => onNavItemTapped(2),
                ),
                _NavItem(
                  icon: Icons.settings,
                  label: '設定',
                  index: 3,
                  isSelected: currentIndex == 3,
                  onTap: () => onNavItemTapped(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ナビゲーションアイテムウィジェット
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            size: AppSizes.iconLg,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontSize: AppSizes.fontXs,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
