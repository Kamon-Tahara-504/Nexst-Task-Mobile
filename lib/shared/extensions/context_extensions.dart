import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// BuildContextの拡張メソッド
extension ContextExtensions on BuildContext {
  // ==================== Theme ====================

  /// テーマデータを取得
  ThemeData get theme => Theme.of(this);

  /// テキストテーマを取得
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// カラースキームを取得
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// プライマリーカラーを取得
  Color get primaryColor => Theme.of(this).colorScheme.primary;

  /// セカンダリーカラーを取得
  Color get secondaryColor => Theme.of(this).colorScheme.secondary;

  /// エラーカラーを取得
  Color get errorColor => Theme.of(this).colorScheme.error;

  /// 背景色を取得
  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;

  // ==================== MediaQuery ====================

  /// メディアクエリデータを取得
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// 画面サイズを取得
  Size get screenSize => MediaQuery.of(this).size;

  /// 画面幅を取得
  double get screenWidth => MediaQuery.of(this).size.width;

  /// 画面高さを取得
  double get screenHeight => MediaQuery.of(this).size.height;

  /// 画面の向き（縦/横）を取得
  Orientation get orientation => MediaQuery.of(this).orientation;

  /// 縦向きかどうか
  bool get isPortrait => orientation == Orientation.portrait;

  /// 横向きかどうか
  bool get isLandscape => orientation == Orientation.landscape;

  /// パディング（SafeArea用）を取得
  EdgeInsets get padding => MediaQuery.of(this).padding;

  /// ViewInsetsを取得（キーボード表示時の高さなど）
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  /// キーボードが表示されているかどうか
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;

  // ==================== Screen Size Helpers ====================

  /// スモールスクリーン（幅 < 600px）かどうか
  bool get isSmallScreen => screenWidth < 600;

  /// ミディアムスクリーン（600px <= 幅 < 900px）かどうか
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 900;

  /// ラージスクリーン（幅 >= 900px）かどうか
  bool get isLargeScreen => screenWidth >= 900;

  /// タブレットサイズかどうか
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;

  /// デスクトップサイズかどうか
  bool get isDesktop => screenWidth >= 1200;

  // ==================== Navigation ====================

  /// ページを遷移（go_router）
  void goNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    GoRouter.of(this).goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// ページを push（go_router）
  void pushNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    GoRouter.of(this).pushNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// 戻る
  void pop<T>([T? result]) {
    if (canPop()) {
      GoRouter.of(this).pop(result);
    }
  }

  /// 戻れるかどうか
  bool canPop() => GoRouter.of(this).canPop();

  // ==================== Snackbar ====================

  /// Snackbarを表示
  void showSnackbar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor ?? Colors.white),
        ),
        duration: duration,
        backgroundColor: backgroundColor,
        action: action,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// エラーSnackbarを表示
  void showErrorSnackbar(String message) {
    showSnackbar(message, backgroundColor: errorColor, textColor: Colors.white);
  }

  /// 成功Snackbarを表示
  void showSuccessSnackbar(String message) {
    showSnackbar(
      message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  // ==================== Dialog ====================

  /// ダイアログを表示
  Future<T?> showAppDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
    );
  }

  /// 確認ダイアログを表示
  Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'はい',
    String cancelText = 'いいえ',
  }) async {
    final result = await showAppDialog<bool>(
      child: AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => pop(false), child: Text(cancelText)),
          ElevatedButton(onPressed: () => pop(true), child: Text(confirmText)),
        ],
      ),
    );
    return result ?? false;
  }

  // ==================== Modal Bottom Sheet ====================

  /// モーダルボトムシートを表示
  Future<T?> showAppBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => child,
    );
  }

  // ==================== Focus ====================

  /// フォーカスを外す（キーボードを閉じる）
  void unfocus() {
    FocusScope.of(this).unfocus();
  }

  /// キーボードを閉じる（unfocusのエイリアス）
  void hideKeyboard() {
    unfocus();
  }
}
