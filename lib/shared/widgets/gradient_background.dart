import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// グラデーション背景Widget
/// 
/// Web版と同じグラデーション (#3B62FF → #5B8FFF → #5BFFE4) を提供
class GradientBackground extends StatelessWidget {
  /// 子Widget
  final Widget child;

  /// グラデーションの色（デフォルト: AppColors.gradientColors）
  final List<Color>? colors;

  /// グラデーションの開始位置（デフォルト: topLeft）
  final AlignmentGeometry begin;

  /// グラデーションの終了位置（デフォルト: bottomRight）
  final AlignmentGeometry end;

  const GradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors ?? AppColors.gradientColors,
        ),
      ),
      child: child,
    );
  }
}

/// グラデーション背景付きScaffold
/// 
/// Scaffoldのbodyにグラデーション背景を適用
class GradientScaffold extends StatelessWidget {
  /// AppBarのタイトル
  final String? title;

  /// AppBar
  final PreferredSizeWidget? appBar;

  /// Body Widget
  final Widget body;

  /// FloatingActionButton
  final Widget? floatingActionButton;

  /// FloatingActionButtonの位置
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Drawer
  final Widget? drawer;

  /// BottomNavigationBar
  final Widget? bottomNavigationBar;

  /// 背景のグラデーション色
  final List<Color>? gradientColors;

  const GradientScaffold({
    super.key,
    this.title,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.bottomNavigationBar,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ??
          (title != null
              ? AppBar(
                  title: Text(title!),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                )
              : null),
      body: GradientBackground(
        colors: gradientColors,
        child: body,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
    );
  }
}

