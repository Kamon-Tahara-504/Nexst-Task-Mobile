import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../providers/admin_provider.dart';
import '../widgets/user_list.dart';
import '../widgets/upcoming_tasks_list.dart';
import '../widgets/admin_stats_dashboard.dart';

/// 管理者画面
class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).value;

    // 管理者権限チェック
    if (currentUser == null || !currentUser.isAdmin) {
      return _buildUnauthorizedView();
    }

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              // 統計ダッシュボード
              const AdminStatsDashboard(),
              // タブバー
              _buildTabBar(),
              // タブビュー
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    UserList(),
                    UpcomingTasksList(),
                    UpcomingTasksList(isOverdue: true),
                    UpcomingTasksList(isHighPriority: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 未認証画面を構築
  Widget _buildUnauthorizedView() {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            '管理者画面',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.admin_panel_settings, size: 80, color: Colors.white),
              SizedBox(height: AppSizes.spaceXl),
              Text(
                '管理者権限が必要です',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: AppSizes.space),
              Text(
                'この画面にアクセスするには管理者権限が必要です',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// AppBarを構築
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        '管理者画面',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () {
            // 全Providerをリフレッシュ
            ref.invalidate(allUsersProvider);
            ref.invalidate(activeUsersProvider);
            ref.invalidate(allProjectsProvider);
            ref.invalidate(adminUpcomingTasksProvider);
            ref.invalidate(overdueTasksProvider);
            ref.invalidate(adminHighPriorityTasksProvider);
            ref.invalidate(projectTaskStatsProvider);
            ref.invalidate(userTaskStatsProvider);

            context.showSuccessSnackbar('データを更新しました');
          },
        ),
      ],
    );
  }

  /// タブバーを構築
  Widget _buildTabBar() {
    return LiquidGlassContainer(
      margin: const EdgeInsets.all(AppSizes.padding),
      padding: const EdgeInsets.all(AppSizes.paddingXs),
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.6),
        indicator: BoxDecoration(
          color: AppColors.primary.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
        isScrollable: true,
        tabs: const [
          Tab(icon: Icon(Icons.people), text: 'ユーザー管理'),
          Tab(icon: Icon(Icons.schedule), text: '今週の締切'),
          Tab(icon: Icon(Icons.warning), text: '期限切れ'),
          Tab(icon: Icon(Icons.flag), text: '高優先度'),
        ],
      ),
    );
  }
}
