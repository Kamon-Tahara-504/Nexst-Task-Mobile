import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import 'liquid_glass_container.dart';

/// ローディングインジケーターWidget
class LoadingIndicator extends StatelessWidget {
  /// サイズ
  final double size;

  /// 色
  final Color? color;

  /// メッセージ
  final String? message;

  const LoadingIndicator({
    super.key,
    this.size = 40.0,
    this.color,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            color: color ?? AppColors.primary,
            strokeWidth: 3.0,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: TextStyle(
              color: color ?? AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }
}

/// 全画面ローディングオーバーレイ
class LoadingOverlay extends StatelessWidget {
  /// メッセージ
  final String message;

  /// 背景の透明度
  final double backgroundOpacity;

  const LoadingOverlay({
    super.key,
    this.message = AppStrings.loading,
    this.backgroundOpacity = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: backgroundOpacity),
      child: Center(
        child: LiquidGlassContainer(
          padding: const EdgeInsets.all(32),
          opacity: 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LoadingIndicator(
                size: 48,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// リキッドグラスデザインのローディングカード
class LoadingCard extends StatelessWidget {
  /// メッセージ
  final String message;

  /// 高さ
  final double? height;

  const LoadingCard({
    super.key,
    this.message = AppStrings.loading,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidGlassContainer(
      height: height,
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LoadingIndicator(
              size: 40,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ページローディング（全画面）
class PageLoading extends StatelessWidget {
  /// メッセージ
  final String message;

  const PageLoading({
    super.key,
    this.message = AppStrings.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: LoadingIndicator(
          size: 48,
          message: message,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

