/// アプリケーション全体で使用する文字列定数
class AppStrings {
  AppStrings._(); // プライベートコンストラクタ

  // ==================== アプリ情報 ====================
  static const String appName = 'Nexst Task';
  static const String appTagline = '毎日を everyday に.';
  static const String copyright = '© 2025 Nexst Task. 毎日を everyday に.';

  // ==================== 認証関連 ====================
  static const String login = 'ログイン';
  static const String logout = 'ログアウト';
  static const String register = '新規登録';
  static const String email = 'メールアドレス';
  static const String password = 'パスワード';
  static const String userName = 'ユーザー名';
  static const String loginButton = 'ログイン';
  static const String registerButton = '新規登録はこちら';
  static const String loggingIn = 'ログイン中...';
  static const String registering = '登録中...';

  // ==================== プロジェクト関連 ====================
  static const String projectSelection = 'プロジェクト選択';
  static const String projectName = 'プロジェクト名';
  static const String projectCode = 'プロジェクトコード';
  static const String createProject = 'プロジェクト作成';
  static const String joinProject = 'プロジェクトに参加';
  static const String selectProject = 'プロジェクトを選択してください';
  static const String noProjects = 'プロジェクトがありません';
  static const String changeProject = 'プロジェクト変更';

  // ==================== タスク関連 ====================
  static const String task = 'タスク';
  static const String tasks = 'タスク一覧';
  static const String taskTitle = 'タスク名';
  static const String taskStatus = 'ステータス';
  static const String taskPriority = '優先度';
  static const String taskCategory = 'カテゴリ';
  static const String taskDeadline = '締切';
  static const String taskCreatedBy = '作成者';
  static const String taskAssignedTo = '担当者';
  static const String taskOneLine = '一行メモ';
  static const String taskMemo = '詳細メモ';
  static const String taskRelatedUrl = '関連URL';
  static const String taskIcon = 'アイコン';
  static const String createTask = 'タスク作成';
  static const String editTask = 'タスク編集';
  static const String deleteTask = 'タスク削除';
  static const String taskCreated = '作成日';
  static const String noTasks = 'タスクなし';

  // ==================== タスクステータス ====================
  static const String statusTodo = '未着手';
  static const String statusInProgress = '進行中';
  static const String statusDone = '完了';

  // ==================== タスク優先度 ====================
  static const String priorityHigh = '高';
  static const String priorityMedium = '中';
  static const String priorityLow = '低';

  // ==================== タスクカテゴリ ====================
  static const String categorySolo = 'Solo Task';
  static const String categoryTeam = 'Team Task';
  static const String categoryFront = 'Front';
  static const String categoryBack = 'Back';
  static const String categorySetting = 'Setting';

  // ==================== 締切関連 ====================
  static const String deadlineUrgent = '緊急';
  static const String deadlineWarning = '注意';
  static const String deadlineSafe = '安全';
  static const String deadlineOverdue = '期限切れ';
  static const String daysRemaining = '残り%d日';
  static const String today = '今日';
  static const String tomorrow = '明日';

  // ==================== ナビゲーション ====================
  static const String soloTask = 'Solo Task';
  static const String groupTask = 'Group Task';
  static const String teamTask = 'Team Task';
  static const String admin = '管理者';
  static const String adminPage = '管理者ページ';
  static const String front = 'Front';
  static const String back = 'Back';
  static const String setting = 'Setting';

  // ==================== 管理者機能 ====================
  static const String userManagement = 'ユーザー管理';
  static const String projectManagement = 'プロジェクト管理';
  static const String memberManagement = 'メンバー管理';
  static const String upcomingTasks = '締切が近いタスク';
  static const String activeUsers = 'アクティブユーザー';
  static const String inactiveUsers = '非アクティブユーザー';

  // ==================== ボタン・アクション ====================
  static const String save = '保存';
  static const String cancel = 'キャンセル';
  static const String delete = '削除';
  static const String edit = '編集';
  static const String create = '作成';
  static const String search = '検索';
  static const String filter = 'フィルター';
  static const String close = '閉じる';
  static const String ok = 'OK';
  static const String yes = 'はい';
  static const String no = 'いいえ';
  static const String confirm = '確認';
  static const String backButton = '戻る';

  // ==================== メッセージ ====================
  static const String loading = '読み込み中...';
  static const String noData = 'データがありません';
  static const String error = 'エラーが発生しました';
  static const String success = '成功しました';
  static const String saveSuccess = '保存しました';
  static const String deleteSuccess = '削除しました';
  static const String createSuccess = '作成しました';
  static const String updateSuccess = '更新しました';

  // ==================== エラーメッセージ ====================
  static const String errorInvalidEmail = 'メールアドレスの形式が正しくありません';
  static const String errorPasswordTooShort = 'パスワードは8文字以上で入力してください';
  static const String errorRequiredField = 'この項目は必須です';
  static const String errorLoginFailed = 'ログインに失敗しました';
  static const String errorRegisterFailed = '登録に失敗しました';
  static const String errorNetworkConnection = 'ネットワーク接続を確認してください';
  static const String errorUnknown = '不明なエラーが発生しました';

  // ==================== 確認メッセージ ====================
  static const String confirmDelete = '本当に削除しますか？';
  static const String confirmLogout = 'ログアウトしますか？';
  static const String confirmStatusChange = 'ステータスを変更しますか？';

  // ==================== プレースホルダー ====================
  static const String placeholderEmail = 'example@email.com';
  static const String placeholderPassword = 'パスワードを入力';
  static const String placeholderUserName = 'ユーザー名を入力';
  static const String placeholderTaskTitle = 'タスク名を入力';
  static const String placeholderOneLine = '簡単な説明を入力';
  static const String placeholderMemo = '詳細な説明を入力';
  static const String placeholderUrl = 'https://example.com';
  static const String placeholderProjectName = 'プロジェクト名を入力';
  static const String placeholderProjectCode = 'プロジェクトコードを入力';

  // ==================== バリデーションメッセージ ====================
  static const String validationEmailRequired = 'メールアドレスを入力してください';
  static const String validationPasswordRequired = 'パスワードを入力してください';
  static const String validationUserNameRequired = 'ユーザー名を入力してください';
  static const String validationTaskTitleRequired = 'タスク名を入力してください';
  static const String validationDeadlineRequired = '締切を選択してください';
  static const String validationAssignedToRequired = '担当者を選択してください';
}
