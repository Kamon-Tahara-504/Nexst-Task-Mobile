import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// タスクの優先度を表すEnum
enum Priority {
  /// 高優先度
  high(3, '高'),

  /// 中優先度
  medium(2, '中'),

  /// 低優先度
  low(1, '低');

  const Priority(this.value, this.label);

  /// データベースでの値（数値）
  final int value;

  /// 表示用ラベル
  final String label;

  /// 数値からPriorityを取得
  static Priority fromInt(int value) {
    return Priority.values.firstWhere(
      (priority) => priority.value == value,
      orElse: () => Priority.low,
    );
  }

  /// データベース保存用の数値に変換
  int toJson() => value;

  /// 優先度を示す色
  Color get color {
    switch (this) {
      case Priority.high:
        return AppColors.priorityHigh;
      case Priority.medium:
        return AppColors.priorityMedium;
      case Priority.low:
        return AppColors.priorityLow;
    }
  }

  /// 明るい色
  Color get lightColor {
    switch (this) {
      case Priority.high:
        return AppColors.priorityHighLight;
      case Priority.medium:
        return AppColors.priorityMediumLight;
      case Priority.low:
        return AppColors.priorityLowLight;
    }
  }

  /// 暗い色
  Color get darkColor {
    switch (this) {
      case Priority.high:
        return AppColors.priorityHighDark;
      case Priority.medium:
        return AppColors.priorityMediumDark;
      case Priority.low:
        return AppColors.priorityLowDark;
    }
  }
}
