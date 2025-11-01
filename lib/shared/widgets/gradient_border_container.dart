import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// リキッドグラスコンテナ（ボトムナビゲーションバーと同じデザイン）
/// 上部のボーダーが強調されたシンプルなデザイン
class GradientBorderContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GradientBorderContainer({
    super.key,
    required this.child,
    this.borderRadius = AppSizes.radiusLiquidGlass,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.glassShadow,
            blurRadius: AppSizes.glassShadowBlur,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppSizes.glassBlurSigma,
            sigmaY: AppSizes.glassBlurSigma,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(borderRadius),
              // ボトムナビゲーションバーと同じデザイン: 上部のボーダーのみ強調
              border: const Border(
                top: BorderSide(
                  color: AppColors.glassBorder,
                  width: AppSizes.glassBorderWidth,
                ),
              ),
            ),
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
