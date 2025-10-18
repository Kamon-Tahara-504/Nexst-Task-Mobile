/// アプリケーション全体で使用するサイズ定数
class AppSizes {
  AppSizes._(); // プライベートコンストラクタ

  // ==================== パディング ====================
  /// パディング: 極小（4px）
  static const double paddingXs = 4.0;

  /// パディング: 小（8px）
  static const double paddingSm = 8.0;

  /// パディング: 中（12px）
  static const double paddingMd = 12.0;

  /// パディング: 通常（16px）
  static const double padding = 16.0;

  /// パディング: 大（20px）
  static const double paddingLg = 20.0;

  /// パディング: 特大（24px）
  static const double paddingXl = 24.0;

  /// パディング: 超特大（32px）
  static const double paddingXxl = 32.0;

  // ==================== マージン ====================
  /// マージン: 極小（4px）
  static const double marginXs = 4.0;

  /// マージン: 小（8px）
  static const double marginSm = 8.0;

  /// マージン: 中（12px）
  static const double marginMd = 12.0;

  /// マージン: 通常（16px）
  static const double margin = 16.0;

  /// マージン: 大（20px）
  static const double marginLg = 20.0;

  /// マージン: 特大（24px）
  static const double marginXl = 24.0;

  /// マージン: 超特大（32px）
  static const double marginXxl = 32.0;

  // ==================== ボーダー半径（角丸） ====================
  /// ボーダー半径: 小（8px）
  static const double radiusSm = 8.0;

  /// ボーダー半径: 中（12px）
  static const double radiusMd = 12.0;

  /// ボーダー半径: 通常（16px）
  static const double radius = 16.0;

  /// ボーダー半径: 大（20px）
  static const double radiusLg = 20.0;

  /// ボーダー半径: 特大（24px）
  static const double radiusXl = 24.0;

  /// ボーダー半径: リキッドグラスデフォルト（20px）
  static const double radiusLiquidGlass = 20.0;

  /// ボーダー半径: 円形（9999px）
  static const double radiusCircle = 9999.0;

  // ==================== アイコンサイズ ====================
  /// アイコン: 極小（16px）
  static const double iconXs = 16.0;

  /// アイコン: 小（20px）
  static const double iconSm = 20.0;

  /// アイコン: 通常（24px）
  static const double icon = 24.0;

  /// アイコン: 大（32px）
  static const double iconLg = 32.0;

  /// アイコン: 特大（48px）
  static const double iconXl = 48.0;

  // ==================== ボタンサイズ ====================
  /// ボタン高さ: 小（32px）
  static const double buttonHeightSm = 32.0;

  /// ボタン高さ: 通常（48px）
  static const double buttonHeight = 48.0;

  /// ボタン高さ: 大（56px）
  static const double buttonHeightLg = 56.0;

  /// ボタン幅: 最小（80px）
  static const double buttonMinWidth = 80.0;

  // ==================== カードサイズ ====================
  /// カード: 最小幅（280px）
  static const double cardMinWidth = 280.0;

  /// カード: 最大幅（400px）
  static const double cardMaxWidth = 400.0;

  /// カード内パディング（16px）
  static const double cardPadding = 16.0;

  /// タスクカード高さ: 最小（120px）
  static const double taskCardMinHeight = 120.0;

  // ==================== アプリバーサイズ ====================
  /// アプリバー高さ（56px）
  static const double appBarHeight = 56.0;

  /// アプリバーパディング（16px）
  static const double appBarPadding = 16.0;

  // ==================== リキッドグラスコンテナ ====================
  /// リキッドグラス: ボーダー幅（1.5px）
  static const double glassBorderWidth = 1.5;

  /// リキッドグラス: ブラー値（10px）
  static const double glassBlurSigma = 10.0;

  /// リキッドグラス: シャドウブラー（20px）
  static const double glassShadowBlur = 20.0;

  // ==================== スペーシング ====================
  /// スペース: 極小（4px）
  static const double spaceXs = 4.0;

  /// スペース: 小（8px）
  static const double spaceSm = 8.0;

  /// スペース: 中（12px）
  static const double spaceMd = 12.0;

  /// スペース: 通常（16px）
  static const double space = 16.0;

  /// スペース: 大（20px）
  static const double spaceLg = 20.0;

  /// スペース: 特大（24px）
  static const double spaceXl = 24.0;

  /// スペース: 超特大（32px）
  static const double spaceXxl = 32.0;

  // ==================== タスクボードカラムサイズ ====================
  /// カラム間のギャップ（16px）
  static const double columnGap = 16.0;

  /// カラム内タスクの間隔（12px）
  static const double taskSpacing = 12.0;

  /// カラム内パディング（16px）
  static const double columnPadding = 16.0;

  // ==================== フォントサイズ ====================
  /// フォント: 極小（10px）
  static const double fontXs = 10.0;

  /// フォント: 小（12px）
  static const double fontSm = 12.0;

  /// フォント: 通常（14px）
  static const double font = 14.0;

  /// フォント: 中（16px）
  static const double fontMd = 16.0;

  /// フォント: 大（18px）
  static const double fontLg = 18.0;

  /// フォント: 特大（20px）
  static const double fontXl = 20.0;

  /// フォント: タイトル小（24px）
  static const double fontTitleSm = 24.0;

  /// フォント: タイトル（28px）
  static const double fontTitle = 28.0;

  /// フォント: タイトル大（32px）
  static const double fontTitleLg = 32.0;

  // ==================== エレベーション（影の高さ） ====================
  /// エレベーション: 低（2.0）
  static const double elevationLow = 2.0;

  /// エレベーション: 中（4.0）
  static const double elevation = 4.0;

  /// エレベーション: 高（8.0）
  static const double elevationHigh = 8.0;

  /// エレベーション: 最高（16.0）
  static const double elevationXHigh = 16.0;
}

