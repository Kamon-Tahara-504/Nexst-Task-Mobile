import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// リキッドグラス（グラスモーフィズム）デザインのコンテナWidget
///
/// 透過背景 + ブラー効果 + 白いボーダーで構成される
class LiquidGlassContainer extends StatelessWidget {
  /// 子Widget
  final Widget child;

  /// ボーダー半径（デフォルト: 20px）
  final double borderRadius;

  /// 背景の透明度（0.0 - 1.0、デフォルト: 0.3）
  final double opacity;

  /// ボーダーの色（デフォルト: 白60%透過）
  final Color? borderColor;

  /// ボーダーの幅（デフォルト: 1.5px）
  final double borderWidth;

  /// ブラーの強度（デフォルト: 10.0）
  final double blurSigma;

  /// パディング
  final EdgeInsetsGeometry? padding;

  /// マージン
  final EdgeInsetsGeometry? margin;

  /// 幅
  final double? width;

  /// 高さ
  final double? height;

  /// シャドウを表示するか（デフォルト: true）
  final bool showShadow;

  const LiquidGlassContainer({
    super.key,
    required this.child,
    this.borderRadius = AppSizes.radiusLiquidGlass,
    this.opacity = 0.3,
    this.borderColor,
    this.borderWidth = AppSizes.glassBorderWidth,
    this.blurSigma = AppSizes.glassBlurSigma,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: AppColors.glassShadow,
                  blurRadius: AppSizes.glassShadowBlur,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: opacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor ?? AppColors.glassBorder,
                width: borderWidth,
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

/// リキッドグラスカードWidget（パディング付き）
class LiquidGlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const LiquidGlassCard({
    super.key,
    required this.child,
    this.borderRadius = AppSizes.radiusLiquidGlass,
    this.padding = const EdgeInsets.all(AppSizes.padding),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = LiquidGlassContainer(
      borderRadius: borderRadius,
      padding: padding,
      margin: margin,
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: card,
      );
    }

    return card;
  }
}
