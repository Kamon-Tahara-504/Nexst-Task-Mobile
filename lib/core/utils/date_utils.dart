import 'package:intl/intl.dart';

/// 日付関連のユーティリティクラス
class AppDateUtils {
  AppDateUtils._(); // プライベートコンストラクタ

  /// 日付フォーマッター: yyyy/MM/dd
  static final DateFormat _dateFormatter = DateFormat('yyyy/MM/dd');

  /// 日付時刻フォーマッター: yyyy/MM/dd HH:mm
  static final DateFormat _dateTimeFormatter = DateFormat('yyyy/MM/dd HH:mm');

  /// 時刻フォーマッター: HH:mm
  static final DateFormat _timeFormatter = DateFormat('HH:mm');

  /// 日付を文字列に変換（yyyy/MM/dd）
  static String formatDate(DateTime date) {
    return _dateFormatter.format(date);
  }

  /// 日付時刻を文字列に変換（yyyy/MM/dd HH:mm）
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormatter.format(dateTime);
  }

  /// 時刻を文字列に変換（HH:mm）
  static String formatTime(DateTime time) {
    return _timeFormatter.format(time);
  }

  /// 締切までの残り日数を計算
  static int getDaysRemaining(DateTime deadline) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final deadlineDate = DateTime(deadline.year, deadline.month, deadline.day);

    final difference = deadlineDate.difference(todayDate);
    return difference.inDays;
  }

  /// 締切ステータスを取得（表示用文字列）
  static String getDeadlineStatus(DateTime deadline) {
    final daysRemaining = getDaysRemaining(deadline);

    if (daysRemaining < 0) {
      return '期限切れ';
    } else if (daysRemaining == 0) {
      return '今日';
    } else if (daysRemaining == 1) {
      return '明日';
    } else {
      return '残り$daysRemaining日';
    }
  }

  /// 締切の緊急度を取得（0: 安全, 1: 注意, 2: 緊急, 3: 期限切れ）
  static int getDeadlineUrgency(DateTime deadline) {
    final daysRemaining = getDaysRemaining(deadline);

    if (daysRemaining < 0) {
      return 3; // 期限切れ
    } else if (daysRemaining <= 1) {
      return 2; // 緊急（0-1日）
    } else if (daysRemaining <= 3) {
      return 1; // 注意（2-3日）
    } else {
      return 0; // 安全（4日以上）
    }
  }

  /// 2つの日付が同じ日かどうかを判定
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// 今日かどうかを判定
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// 明日かどうかを判定
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(date, tomorrow);
  }

  /// 昨日かどうかを判定
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  /// 期限が過ぎているかどうかを判定
  static bool isOverdue(DateTime deadline) {
    return getDaysRemaining(deadline) < 0;
  }

  /// 今週かどうかを判定
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final dateOnly = DateTime(date.year, date.month, date.day);
    final startOnly = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );
    final endOnly = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day);

    return (dateOnly.isAfter(startOnly) ||
            dateOnly.isAtSameMomentAs(startOnly)) &&
        (dateOnly.isBefore(endOnly) || dateOnly.isAtSameMomentAs(endOnly));
  }

  /// 今月かどうかを判定
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  /// 相対的な日付表現を取得（「今日」「明日」「昨日」など）
  static String getRelativeDate(DateTime date) {
    if (isToday(date)) {
      return '今日';
    } else if (isTomorrow(date)) {
      return '明日';
    } else if (isYesterday(date)) {
      return '昨日';
    } else {
      return formatDate(date);
    }
  }

  /// 日付をSupabase用のISO8601文字列に変換
  static String toIso8601String(DateTime date) {
    return date.toUtc().toIso8601String();
  }

  /// ISO8601文字列をDateTimeに変換
  static DateTime fromIso8601String(String dateString) {
    return DateTime.parse(dateString).toLocal();
  }

  /// 現在の日時を取得（ローカルタイム）
  static DateTime now() {
    return DateTime.now();
  }

  /// 今日の日付を取得（時刻は00:00:00）
  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// 明日の日付を取得（時刻は00:00:00）
  static DateTime tomorrow() {
    return today().add(const Duration(days: 1));
  }

  /// 指定した日数後の日付を取得
  static DateTime addDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }

  /// 指定した日数前の日付を取得
  static DateTime subtractDays(DateTime date, int days) {
    return date.subtract(Duration(days: days));
  }
}
