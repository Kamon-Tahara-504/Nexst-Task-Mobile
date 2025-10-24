import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/date_utils.dart';

/// 締切タグWidget
class DeadlineTag extends StatelessWidget {
  final DateTime deadline;
  final double? fontSize;

  const DeadlineTag({super.key, required this.deadline, this.fontSize});

  @override
  Widget build(BuildContext context) {
    final urgency = AppDateUtils.getDeadlineUrgency(deadline);
    final status = AppDateUtils.getDeadlineStatus(deadline);

    Color backgroundColor;
    Color textColor;
    Color borderColor;

    switch (urgency) {
      case 3: // 期限切れ
        backgroundColor = AppColors.deadlineOverdue;
        textColor = AppColors.deadlineOverdueText;
        borderColor = AppColors.deadlineOverdueBorder;
        break;
      case 2: // 緊急（0-1日）
        backgroundColor = AppColors.deadlineUrgent;
        textColor = AppColors.deadlineUrgentText;
        borderColor = AppColors.deadlineUrgentBorder;
        break;
      case 1: // 注意（2-3日）
        backgroundColor = AppColors.deadlineWarning;
        textColor = AppColors.deadlineWarningText;
        borderColor = AppColors.deadlineWarningBorder;
        break;
      default: // 安全（4日以上）
        backgroundColor = AppColors.deadlineSafe;
        textColor = AppColors.deadlineSafeText;
        borderColor = AppColors.deadlineSafeBorder;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm,
        vertical: AppSizes.paddingXs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: fontSize ?? AppSizes.fontXs,
          fontWeight: urgency >= 2 ? FontWeight.bold : FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

/// 締切インジケーター（円形）
class DeadlineIndicator extends StatelessWidget {
  final DateTime deadline;
  final double size;

  const DeadlineIndicator({
    super.key,
    required this.deadline,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final urgency = AppDateUtils.getDeadlineUrgency(deadline);

    Color color;
    switch (urgency) {
      case 3: // 期限切れ
      case 2: // 緊急
        color = AppColors.priorityHigh;
        break;
      case 1: // 注意
        color = AppColors.priorityMedium;
        break;
      default: // 安全
        color = AppColors.priorityLow;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: urgency >= 2
          ? Icon(Icons.warning, size: size * 0.6, color: Colors.white)
          : null,
    );
  }
}
