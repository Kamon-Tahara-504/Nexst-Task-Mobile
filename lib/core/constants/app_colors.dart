import 'package:flutter/material.dart';

/// アプリケーション全体で使用するカラー定数
class AppColors {
  AppColors._(); // プライベートコンストラクタ

  // ==================== グラデーション背景 ====================
  /// メイングラデーション（Web版と同一）
  /// #3B62FF → #5B8FFF → #5BFFE4
  static const List<Color> gradientColors = [
    Color(0xFF3B62FF), // 青
    Color(0xFF5B8FFF), // ライトブルー
    Color(0xFF5BFFE4), // シアン
  ];

  static const Gradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: gradientColors,
  );

  // ==================== リキッドグラスデザイン ====================
  /// リキッドグラスのボーダー色
  static const Color glassBorder = Color(0x99FFFFFF); // white with 60% opacity

  /// リキッドグラスの背景色（基本）
  static const Color glassBackground = Color(
    0x4DFFFFFF,
  ); // white with 30% opacity

  /// リキッドグラスの背景色（濃い）
  static const Color glassBackgroundDark = Color(
    0xCCFFFFFF,
  ); // white with 80% opacity

  /// リキッドグラスの影
  static const Color glassShadow = Color(0x1A000000); // black with 10% opacity

  // ==================== 優先度カラー ====================
  /// 優先度: 高（赤）
  static const Color priorityHigh = Color(0xFFEF4444);
  static const Color priorityHighLight = Color(0xFFFEE2E2);
  static const Color priorityHighDark = Color(0xFF991B1B);

  /// 優先度: 中（オレンジ）
  static const Color priorityMedium = Color(0xFFF59E0B);
  static const Color priorityMediumLight = Color(0xFFFED7AA);
  static const Color priorityMediumDark = Color(0xFF9A3412);

  /// 優先度: 低（緑）
  static const Color priorityLow = Color(0xFF10B981);
  static const Color priorityLowLight = Color(0xFFD1FAE5);
  static const Color priorityLowDark = Color(0xFF065F46);

  // ==================== 締切カラー ====================
  /// 締切: 緊急（0-1日）- 赤系
  static const Color deadlineUrgent = Color(0xFFFECDD3); // red-200
  static const Color deadlineUrgentText = Color(0xFF7F1D1D); // red-900
  static const Color deadlineUrgentBorder = Color(0xFFFCA5A5); // red-300

  /// 締切: 注意（2-3日）- 黄系
  static const Color deadlineWarning = Color(0xFFFEF08A); // yellow-200
  static const Color deadlineWarningText = Color(0xFF854D0E); // yellow-800
  static const Color deadlineWarningBorder = Color(0xFFFDE047); // yellow-300

  /// 締切: 安全（4日以上）- 緑系
  static const Color deadlineSafe = Color(0xFFBBF7D0); // green-200
  static const Color deadlineSafeText = Color(0xFF14532D); // green-900
  static const Color deadlineSafeBorder = Color(0xFF86EFAC); // green-300

  /// 締切: 期限切れ - 赤（濃い）
  static const Color deadlineOverdue = Color(0xFFFECDD3); // red-100
  static const Color deadlineOverdueText = Color(0xFF991B1B); // red-800
  static const Color deadlineOverdueBorder = Color(0xFFFCA5A5); // red-400

  // ==================== ステータスカラー ====================
  /// ステータス: 未着手（グレー）
  static const Color statusTodo = Color(0xFFE5E7EB); // gray-200
  static const Color statusTodoText = Color(0xFF1F2937); // gray-800

  /// ステータス: 進行中（青）
  static const Color statusInProgress = Color(0xFFBFDBFE); // blue-200
  static const Color statusInProgressText = Color(0xFF1E3A8A); // blue-800

  /// ステータス: 完了（緑）
  static const Color statusDone = Color(0xFFBBF7D0); // green-200
  static const Color statusDoneText = Color(0xFF14532D); // green-800

  // ==================== カテゴリカラー ====================
  /// カテゴリタグの背景色
  static const Color categoryBackground = Color(
    0x4DFFFFFF,
  ); // white with 30% opacity

  /// カテゴリタグのボーダー色（青）
  static const Color categoryBorder = Color(0xFF2563EB); // blue-600

  /// カテゴリタグのテキスト色（青）
  static const Color categoryText = Color(0xFF2563EB); // blue-600

  // ==================== 基本カラー ====================
  /// プライマリーカラー
  static const Color primary = Color(0xFF3B62FF);

  /// セカンダリーカラー
  static const Color secondary = Color(0xFF5BFFE4);

  /// エラーカラー
  static const Color error = Color(0xFFEF4444);

  /// サクセスカラー
  static const Color success = Color(0xFF10B981);

  /// 警告カラー
  static const Color warning = Color(0xFFF59E0B);

  /// 情報カラー
  static const Color info = Color(0xFF3B82F6);

  // ==================== テキストカラー ====================
  /// テキスト: プライマリ
  static const Color textPrimary = Color(0xFF111827); // gray-900

  /// テキスト: セカンダリ
  static const Color textSecondary = Color(0xFF6B7280); // gray-500

  /// テキスト: ディセーブル
  static const Color textDisabled = Color(0xFF9CA3AF); // gray-400

  /// テキスト: ホワイト
  static const Color textWhite = Color(0xFFFFFFFF);

  // ==================== 背景カラー ====================
  /// 背景: ライト
  static const Color backgroundLight = Color(0xFFF9FAFB); // gray-50

  /// 背景: ホワイト
  static const Color backgroundWhite = Color(0xFFFFFFFF);

  /// 背景: ダーク
  static const Color backgroundDark = Color(0xFF111827); // gray-900
}
