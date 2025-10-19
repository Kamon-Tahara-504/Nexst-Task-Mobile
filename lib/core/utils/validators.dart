import '../constants/app_strings.dart';

/// バリデーション関連のユーティリティクラス
class Validators {
  Validators._(); // プライベートコンストラクタ

  /// メールアドレスの正規表現パターン
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// URLの正規表現パターン
  static final RegExp _urlRegex = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
  );

  /// メールアドレスのバリデーション
  ///
  /// 戻り値: エラーメッセージ（正常な場合はnull）
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return AppStrings.validationEmailRequired;
    }

    if (!_emailRegex.hasMatch(email)) {
      return AppStrings.errorInvalidEmail;
    }

    return null; // バリデーション成功
  }

  /// パスワードのバリデーション
  ///
  /// 最小文字数: 8文字
  /// 戻り値: エラーメッセージ（正常な場合はnull）
  static String? validatePassword(String? password, {int minLength = 8}) {
    if (password == null || password.isEmpty) {
      return AppStrings.validationPasswordRequired;
    }

    if (password.length < minLength) {
      return AppStrings.errorPasswordTooShort;
    }

    return null; // バリデーション成功
  }

  /// ユーザー名のバリデーション
  ///
  /// 最小文字数: 2文字
  /// 戻り値: エラーメッセージ（正常な場合はnull）
  static String? validateUserName(String? userName, {int minLength = 2}) {
    if (userName == null || userName.isEmpty) {
      return AppStrings.validationUserNameRequired;
    }

    if (userName.trim().length < minLength) {
      return 'ユーザー名は${minLength}文字以上で入力してください';
    }

    return null; // バリデーション成功
  }

  /// タスクタイトルのバリデーション
  ///
  /// 最小文字数: 1文字
  /// 戻り値: エラーメッセージ（正常な場合はnull）
  static String? validateTaskTitle(String? title) {
    if (title == null || title.trim().isEmpty) {
      return AppStrings.validationTaskTitleRequired;
    }

    return null; // バリデーション成功
  }

  /// 必須フィールドのバリデーション
  ///
  /// 戻り値: エラーメッセージ（正常な場合はnull）
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '$fieldNameを入力してください'
          : AppStrings.errorRequiredField;
    }

    return null; // バリデーション成功
  }

  /// URLのバリデーション（任意項目）
  ///
  /// 空の場合はエラーなし
  /// 戻り値: エラーメッセージ（正常な場合はnull）
  static String? validateUrl(String? url) {
    // 空の場合は任意項目なのでOK
    if (url == null || url.trim().isEmpty) {
      return null;
    }

    if (!_urlRegex.hasMatch(url)) {
      return 'URLの形式が正しくありません';
    }

    return null; // バリデーション成功
  }

  /// プロジェクトコードのバリデーション
  ///
  /// 最小文字数: 4文字
  /// 最大文字数: 20文字
  /// 戻り値: エラーメッセージ（正常な場合はnull）
  static String? validateProjectCode(
    String? code, {
    int minLength = 4,
    int maxLength = 20,
  }) {
    if (code == null || code.trim().isEmpty) {
      return 'プロジェクトコードを入力してください';
    }

    final trimmedCode = code.trim();

    if (trimmedCode.length < minLength) {
      return 'プロジェクトコードは${minLength}文字以上で入力してください';
    }

    if (trimmedCode.length > maxLength) {
      return 'プロジェクトコードは${maxLength}文字以内で入力してください';
    }

    // 英数字とハイフン、アンダースコアのみ許可
    final codeRegex = RegExp(r'^[a-zA-Z0-9_-]+$');
    if (!codeRegex.hasMatch(trimmedCode)) {
      return 'プロジェクトコードは英数字、ハイフン、アンダースコアのみ使用できます';
    }

    return null; // バリデーション成功
  }

  /// プロジェクト名のバリデーション
  ///
  /// 最小文字数: 2文字
  /// 最大文字数: 50文字
  /// 戻り値: エラーメッセージ（正常な場合はnull）
  static String? validateProjectName(
    String? name, {
    int minLength = 2,
    int maxLength = 50,
  }) {
    if (name == null || name.trim().isEmpty) {
      return 'プロジェクト名を入力してください';
    }

    final trimmedName = name.trim();

    if (trimmedName.length < minLength) {
      return 'プロジェクト名は${minLength}文字以上で入力してください';
    }

    if (trimmedName.length > maxLength) {
      return 'プロジェクト名は${maxLength}文字以内で入力してください';
    }

    return null; // バリデーション成功
  }

  /// 日付のバリデーション（未来の日付のみ許可）
  ///
  /// 戻り値: エラーメッセージ（正常な場合はnull）
  static String? validateFutureDate(DateTime? date) {
    if (date == null) {
      return AppStrings.validationDeadlineRequired;
    }

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate.isBefore(todayDate)) {
      return '過去の日付は選択できません';
    }

    return null; // バリデーション成功
  }

  /// 文字列が空白のみで構成されているかチェック
  static bool isBlank(String? value) {
    return value == null || value.trim().isEmpty;
  }

  /// 文字列が有効な値を持っているかチェック
  static bool isNotBlank(String? value) {
    return !isBlank(value);
  }

  /// 最小文字数のバリデーション
  static String? validateMinLength(
    String? value,
    int minLength, {
    String? fieldName,
  }) {
    if (value == null || value.isEmpty) {
      return null; // 空の場合は他のバリデーターに任せる
    }

    if (value.length < minLength) {
      final field = fieldName ?? 'この項目';
      return '$fieldは${minLength}文字以上で入力してください';
    }

    return null;
  }

  /// 最大文字数のバリデーション
  static String? validateMaxLength(
    String? value,
    int maxLength, {
    String? fieldName,
  }) {
    if (value == null || value.isEmpty) {
      return null; // 空の場合は他のバリデーターに任せる
    }

    if (value.length > maxLength) {
      final field = fieldName ?? 'この項目';
      return '$fieldは${maxLength}文字以内で入力してください';
    }

    return null;
  }

  /// 数値のバリデーション
  static String? validateNumeric(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null; // 空の場合は他のバリデーターに任せる
    }

    if (int.tryParse(value) == null && double.tryParse(value) == null) {
      final field = fieldName ?? 'この項目';
      return '$fieldは数値で入力してください';
    }

    return null;
  }
}
