# Nexst Task Mobile

## 📱 プロジェクト概要

本アプリは、既存のReact Webアプリ「Nexst Task」のモバイル版として開発されたタスク管理アプリケーションです！
個人・グループ・チーム単位でのタスク管理を行い、**リキッドグラス（グラスモーフィズム）デザイン**を採用した美しく直感的なUIを提供します！

## 🤝 MOBILE版プロジェクト体制

- **開発メンバー**: 1人
- **開発者**: Kamon-Tahara-504
- **MOBILE版開発開始日**: 2025/ 10/18
- **リリース予定**: 未定


## 🤝 WEB版プロジェクト体制

- **開発メンバー**: 2人
- **開発者**: Hirotaka-Tambo, Kamon-Tahara-504
- **WEB開発開始日**: 2025/ 9/21
- **GitHub-Pagesデプロイ**: 2025/ 10/19
- **リリース予定**: 未定



### Web版との違い
- **モバイルファースト**: タッチ操作に最適化されたUI/UX
- **リキッドグラスデザイン**: 透過効果とブラー効果による現代的なデザイン
- **ネイティブパフォーマンス**: Flutterによる高速な動作
- **オフライン対応**: ローカルキャッシュによる快適な操作

## 🛠️ 技術スタック

### フレームワーク・言語
- **Flutter**: 3.9.2+
- **Dart**: 3.9.2+

### 主要パッケージ
- **状態管理**: `riverpod` (v2.x) + `flutter_riverpod`
- **バックエンド**: `supabase_flutter` (v2.x)
- **ルーティング**: `go_router` (v14.x)
- **ローカルストレージ**: `shared_preferences`
- **UI強化**: `flutter_svg`, `cached_network_image`
- **日付処理**: `intl`
- **アニメーション**: `flutter_animate`
- **環境変数**: `flutter_dotenv`

### バックエンド
- **Supabase**: PostgreSQL + Auth + Real-time
  - 認証管理
  - データベース（RLS対応）
  - リアルタイム更新

### アーキテクチャ
- **クリーンアーキテクチャ**: Data / Domain / Presentation層の分離
- **Riverpod**: 宣言的な状態管理とDI
- **Repository パターン**: データソースの抽象化

## 📂 ディレクトリ構成

本プロジェクトは **Feature-based（機能ベース）アーキテクチャ** を採用しています。  
各機能が独立したモジュールとして存在し、保守性とスケーラビリティが向上しています。

```
lib/
├── main.dart                               # アプリエントリーポイント
│
├── core/                                   # アプリ全体の基盤・設定
│   ├── constants/
│   │   ├── app_colors.dart                 # カラー定義（リキッドグラスデザイン）
│   │   ├── app_sizes.dart                  # サイズ・パディング定数
│   │   └── app_strings.dart                # 文字列定数
│   ├── theme/
│   │   └── app_theme.dart                  # Material3テーマ + リキッドグラス設定
│   ├── router/
│   │   └── app_router.dart                 # go_routerによるルート定義
│   ├── utils/
│   │   ├── date_utils.dart                 # 日付フォーマット・計算
│   │   └── validators.dart                 # 入力バリデーション関数
│   └── config/
│       └── supabase_config.dart            # Supabase初期化設定
│
├── features/                               # 機能ごとに分離
│   │
│   ├── auth/                               # 🔐 認証機能
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_model.dart         # ユーザーモデル
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart    # 認証リポジトリ
│   │   │   └── providers/
│   │   │       └── supabase_provider.dart  # Supabaseクライアント
│   │   ├── domain/
│   │   │   └── enums/
│   │   │       └── user_role.dart          # ユーザー権限Enum
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── login_screen.dart       # ログイン画面
│   │       │   └── register_screen.dart    # 新規登録画面
│   │       ├── widgets/
│   │       │   ├── login_form.dart         # ログインフォーム
│   │       │   └── register_form.dart      # 登録フォーム
│   │       └── providers/
│   │           └── auth_state_provider.dart # 認証状態管理
│   │
│   ├── project/                            # 📁 プロジェクト機能
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── project_model.dart      # プロジェクトモデル
│   │   │   │   └── project_member_model.dart # メンバーモデル
│   │   │   └── repositories/
│   │   │       └── project_repository.dart # プロジェクトリポジトリ
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── project_selection_screen.dart # プロジェクト選択画面
│   │       ├── widgets/
│   │       │   ├── project_card.dart       # プロジェクトカード
│   │       │   └── project_creation_modal.dart # プロジェクト作成モーダル
│   │       └── providers/
│   │           └── project_provider.dart   # プロジェクト状態管理
│   │
│   ├── task/                               # ✅ タスク機能
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── task_model.dart         # タスクモデル
│   │   │   └── repositories/
│   │   │       └── task_repository.dart    # タスクリポジトリ
│   │   ├── domain/
│   │   │   └── enums/
│   │   │       ├── task_status.dart        # タスクステータス
│   │   │       ├── task_category.dart      # タスクカテゴリ
│   │   │       └── priority.dart           # 優先度
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── task_board_screen.dart  # タスクボード（メイン画面）
│   │       │   ├── task_detail_screen.dart # タスク詳細・編集画面
│   │       │   └── task_create_screen.dart # タスク作成画面
│   │       ├── widgets/
│   │       │   ├── task_card.dart          # タスクカード
│   │       │   ├── task_board.dart         # カンバンボード
│   │       │   ├── priority_badge.dart     # 優先度バッジ
│   │       │   ├── deadline_tag.dart       # 締切タグ
│   │       │   └── task_form.dart          # タスク入力フォーム
│   │       └── providers/
│   │           ├── task_provider.dart      # タスク状態管理
│   │           └── task_filter_provider.dart # フィルタ管理
│   │
│   └── admin/                              # 👑 管理者機能
│       ├── data/
│       │   └── repositories/
│       │       └── admin_repository.dart   # 管理者リポジトリ
│       └── presentation/
│           ├── screens/
│           │   └── admin_screen.dart       # 管理者画面
│           └── widgets/
│               ├── user_list.dart          # ユーザー一覧
│               └── upcoming_tasks_list.dart # 締切が近いタスク一覧
│
├── shared/                                 # 機能横断的な共通要素
│   ├── widgets/
│   │   ├── liquid_glass_container.dart     # リキッドグラス共通Widget
│   │   ├── gradient_background.dart        # グラデーション背景
│   │   ├── loading_indicator.dart          # ローディング表示
│   │   ├── app_drawer.dart                 # サイドバー（Drawer）
│   │   └── icon_selector.dart              # アイコン選択Widget
│   ├── extensions/
│   │   └── context_extensions.dart         # BuildContext拡張メソッド
│   └── models/
│       └── (共通で使うモデルがあれば)
│
└── assets/                                 # 静的リソース
    └── icons/                              # 技術スタックアイコン（43種類）
        ├── angular.svg
        ├── react.svg
        ├── flutter.svg
        └── ...
```

### アーキテクチャの特徴

#### 📦 Feature-based Architecture
各機能（auth, project, task, admin）が独立したモジュールとして存在し、以下の3層構造を持ちます：

- **data/**: データソース、モデル、リポジトリ
- **domain/**: ビジネスロジック、Enum定義
- **presentation/**: UI（Screen、Widget、Provider）

#### 🎯 メリット
1. **保守性向上**: 機能ごとにコードが分離され、変更の影響範囲が明確
2. **スケーラビリティ**: 新機能の追加が容易
3. **チーム開発**: 機能ごとに担当を分けやすい
4. **テスト**: 機能単位でのテストが書きやすい
5. **削除が簡単**: 不要な機能をフォルダごと削除可能

## 🎨 デザインシステム

### リキッドグラス（グラスモーフィズム）デザイン

本アプリの特徴的なデザイン要素：

1. **半透明の背景**: `Colors.white.withOpacity(0.3 ~ 0.8)`
2. **ブラー効果**: `BackdropFilter` with `ImageFilter.blur`
3. **白いボーダー**: `border: Border.all(color: Colors.white.withOpacity(0.6))`
4. **ソフトシャドウ**: `BoxShadow` with blur and low opacity

### カラーパレット

```dart
// グラデーション背景（Web版と同一）
LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF3B62FF),  // 青
    Color(0xFF5B8FFF),  // ライトブルー
    Color(0xFF5BFFE4),  // シアン
  ],
)

// 優先度による色分け
Priority.high:   Color(0xFFEF4444)  // 赤
Priority.medium: Color(0xFFF59E0B)  // オレンジ
Priority.low:    Color(0xFF10B981)  // 緑

// 締切による色分け
0-1日:  赤系（bg-red-200, text-red-800）
2-3日:  黄系（bg-yellow-200, text-yellow-800）
4日以上: 緑系（bg-green-100, text-green-800）
```

## 🗄️ データベース設計（Supabase）

### テーブル構成

#### users テーブル
| カラム名      | 型          | 説明                   |
|-------------|-------------|------------------------|
| id          | uuid (PK)   | ユーザーID             |
| user_name   | text        | ユーザー名             |
| email       | text        | メールアドレス         |
| project_id  | uuid        | 所属プロジェクトID     |
| role        | text        | 権限（admin/member）   |
| is_active   | boolean     | アクティブ状態         |
| created_at  | timestamptz | 作成日時               |
| updated_at  | timestamptz | 更新日時               |

#### project テーブル
| カラム名      | 型          | 説明                   |
|-------------|-------------|------------------------|
| id          | uuid (PK)   | プロジェクトID         |
| name        | text        | プロジェクト名         |
| code        | text        | プロジェクトコード     |
| created_at  | timestamptz | 作成日時               |
| updated_at  | timestamptz | 更新日時               |

#### project_members テーブル
| カラム名      | 型          | 説明                   |
|-------------|-------------|------------------------|
| id          | uuid (PK)   | メンバーシップID       |
| project_id  | uuid        | プロジェクトID         |
| user_id     | uuid        | ユーザーID             |
| role        | text        | プロジェクト内での役割 |
| is_active   | boolean     | アクティブ状態         |
| created_at  | timestamptz | 作成日時               |
| updated_at  | timestamptz | 更新日時               |

#### task テーブル
| カラム名        | 型          | 説明                   |
|----------------|-------------|------------------------|
| id             | uuid (PK)   | タスクID               |
| title          | text        | タスク名               |
| task_status    | text        | ステータス             |
| priority       | int4        | 優先順位               |
| task_category  | text[]      | カテゴリ（配列）       |
| icon           | text        | アイコン               |
| created_by     | uuid        | 作成者ID               |
| assigned_to    | uuid        | 担当者ID               |
| deadline       | timestamptz | 締切日時               |
| one_line       | text        | 一行説明               |
| memo           | text        | 詳細メモ               |
| related_url    | text        | 関連URL                |
| project_id     | uuid        | プロジェクトID         |
| created_at     | timestamptz | 作成日時               |
| updated_at     | timestamptz | 更新日時               |

## 🚀 セットアップ手順

### 前提条件
- Flutter SDK 3.9.2+
- Dart SDK 3.9.2+
- Xcode（iOS開発の場合）
- Android Studio（Android開発の場合）
- Supabaseプロジェクト

### 1. リポジトリのクローン
```bash
git clone <repository-url>
cd Nexst-Task-Mobile
```

### 2. 依存パッケージのインストール
```bash
flutter pub get
```

### 3. 環境変数の設定
プロジェクトルートに `.env` ファイルを作成：

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

### 4. アイコンのコピー
Web版の `public/icons/` から SVG アイコンをコピー：

```bash
cp -r ../Engineer-Task-APP1/public/icons/*.svg assets/icons/
```

### 5. アプリの起動
```bash
# iOS シミュレーターで起動
flutter run -d ios

# Android エミュレーターで起動
flutter run -d android

```

## 📱 機能一覧

### 認証機能
-  メールアドレス・パスワードでログイン
-  新規ユーザー登録
-  自動ログイン（セッション永続化）
-  ログアウト
-  デフォルトプロジェクトへの自動割り当て

### プロジェクト管理
-  プロジェクト選択
-  プロジェクト作成（管理者）
-  プロジェクトコードでの参加
-  SharedPreferencesで選択状態永続化

### タスク管理
-  タスク一覧表示（カンバン形式：未着手/進行中/完了）
-  タスク作成（タイトル、優先度、締切、言語アイコン、担当者）
-  タスク編集（詳細画面）
-  タスク削除（確認ダイアログ付き）
-  タスクステータス変更（カードのボタンで切替）
-  カテゴリフィルタリング（Solo/Team/Front/Back/Setting）
-  締切による色分け表示
  - 🔴 赤: 0-1日または期限切れ
  - 🟡 黄: 2-3日
  - 🟢 緑: 4日以上
-  リアルタイム更新（Supabase Realtime）

### 管理者機能
-  ユーザー一覧表示
-  ユーザーのアクティブ状態切替
-  プロジェクトメンバー管理
-  締切が近いタスクの一覧表示

## 開発規約

### コーディングスタイル
- Dart公式スタイルガイドに準拠
- `flutter analyze` で警告がないこと
- `dart format` でフォーマット

### 命名規則
- **ファイル名**: `snake_case.dart`
- **クラス名**: `PascalCase`
- **変数・関数名**: `camelCase`
- **定数**: `lowerCamelCase`
- **プライベート変数**: `_leadingUnderscore`

### コミットメッセージ
```
- feat：新機能追加
- fix：バグ修正
- hotfix：クリティカルなバグ修正
- add：新規（ファイル）機能追加
- update：機能修正（バグではない）
- change：仕様変更
- clean：整理（リファクタリング等）
- disable：無効化（コメントアウト等）
- remove：削除（ファイル）
- upgrade：バージョンアップ
- revert：変更取り消し
- docs：ドキュメント修正（README、コメント等）
- tyle：コードフォーマット修正（インデント、スペース等）
- perf：パフォーマンス改善
- test：テストコード追加・修正
- ci：CI/CD 設定変更（GitHub Actions 等）
- build：ビルド関連変更（依存関係、ビルドツール設定等）
- chore：雑務的変更（ユーザーに直接影響なし）
```

### Provider命名規則
```dart
// State Provider
final xxxStateProvider = StateProvider<T>((ref) => ...);

// Future Provider
final xxxProvider = FutureProvider<T>((ref) async => ...);

// Stream Provider
final xxxStreamProvider = StreamProvider<T>((ref) => ...);

// StateNotifier Provider
final xxxNotifierProvider = StateNotifierProvider<Notifier, State>((ref) => ...);
```

## 🧪 テスト

```bash
# 単体テスト実行
flutter test

# カバレッジ付きテスト
flutter test --coverage

# 統合テスト実行
flutter test integration_test/
```

## 📦 ビルド

### Android APK
```bash
flutter build apk --release
```

### iOS IPA
```bash
flutter build ios --release
```

## 📄 ライセンス

© 2025 Nexst Task. 毎日を everyday に.
