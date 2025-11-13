import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/app_drawer.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../project/presentation/providers/project_provider.dart';
import '../../../task/presentation/screens/task_board_screen.dart';

/// ホーム画面（プロジェクト選択画面）
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  double _taskScreenOffset = 0.0;
  bool _isTaskScreenVisible = false;
  bool _isDragging = false;

  // スワイプの感度設定（ユーザーが調整可能）
  double _swipeThreshold = 0.3; // 画面幅の30%以上スワイプで遷移
  double _swipeVelocityThreshold = 500.0; // 速度が500以上なら遷移

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedProjectId = ref.watch(selectedProjectIdProvider);
    final currentUser = ref.watch(currentUserProvider).value;
    final screenWidth = MediaQuery.of(context).size.width;

    // プロジェクト選択状態の変更を監視
    ref.listen<String?>(selectedProjectIdProvider, (previous, next) {
      if (next != null && !_isTaskScreenVisible) {
        // プロジェクトが選択されたらタスク画面を自動表示
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showTaskScreen();
          }
        });
      } else if (next == null && _isTaskScreenVisible) {
        // プロジェクト選択が解除されたらタスク画面を非表示
        _hideTaskScreen();
      }
    });

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // ホーム画面（固定、常に表示）
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragStart: (details) {
                // 左端から一定距離内、または画面全体でスワイプを有効化
                // プロジェクト選択済みでタスク画面が非表示の場合のみ
                if (selectedProjectId != null && !_isTaskScreenVisible) {
                  _isDragging = true;
                  _taskScreenOffset = 0;
                }
              },
              onHorizontalDragUpdate: (details) {
                // 右方向のスワイプでタスク画面を表示（プロジェクト選択済みの場合のみ）
                if (selectedProjectId != null &&
                    !_isTaskScreenVisible &&
                    _isDragging &&
                    details.delta.dx > 0) {
                  setState(() {
                    _taskScreenOffset += details.delta.dx;
                    // 画面幅を超えないように制限
                    if (_taskScreenOffset > screenWidth) {
                      _taskScreenOffset = screenWidth;
                    }
                  });
                }
              },
              onHorizontalDragEnd: (details) {
                if (_isDragging) {
                  // スワイプの距離または速度で判定
                  final shouldShow = _shouldShowTaskScreen(
                    _taskScreenOffset,
                    details.velocity.pixelsPerSecond.dx,
                    screenWidth,
                  );

                  if (selectedProjectId != null &&
                      !_isTaskScreenVisible &&
                      shouldShow) {
                    _showTaskScreen();
                  } else {
                    setState(() {
                      _taskScreenOffset = 0;
                    });
                  }
                }
                _isDragging = false;
              },
              child: _buildHomeContent(context, ref, currentUser),
            ),
            // タスクボード画面（右から重ねる）
            if (selectedProjectId != null)
              AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  // タスク画面の位置を計算（左から右へスライドイン）
                  final taskScreenLeft = _isTaskScreenVisible
                      ? screenWidth * (1 - _slideAnimation.value) -
                            _taskScreenOffset
                      : screenWidth;

                  return Positioned(
                    top: 0,
                    left: taskScreenLeft,
                    right: -taskScreenLeft,
                    bottom: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onHorizontalDragStart: (details) {
                        // 左端から一定距離内でのみスワイプを有効化
                        if (details.localPosition.dx < 50) {
                          _isDragging = true;
                          _taskScreenOffset = 0;
                        }
                      },
                      onHorizontalDragUpdate: (details) {
                        // 左方向のスワイプでタスク画面を非表示
                        if (_isDragging && details.delta.dx < 0) {
                          setState(() {
                            _taskScreenOffset -= details.delta.dx;
                            // 画面幅を超えないように制限
                            if (_taskScreenOffset > screenWidth) {
                              _taskScreenOffset = screenWidth;
                            }
                          });
                        }
                      },
                      onHorizontalDragEnd: (details) {
                        if (_isDragging) {
                          // スワイプの距離または速度で判定
                          final shouldHide = _shouldHideTaskScreen(
                            _taskScreenOffset,
                            details.velocity.pixelsPerSecond.dx,
                            screenWidth,
                          );

                          if (shouldHide) {
                            _hideTaskScreen();
                          } else {
                            setState(() {
                              _taskScreenOffset = 0;
                            });
                            _animationController.forward();
                          }
                        }
                        _isDragging = false;
                      },
                      child: TaskBoardScreen(
                        onBack: () {
                          _hideTaskScreen();
                        },
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  /// タスク画面を表示すべきか判定（距離と速度の両方を考慮）
  bool _shouldShowTaskScreen(
    double offset,
    double velocity,
    double screenWidth,
  ) {
    // 距離ベースの判定
    final distanceThreshold = screenWidth * _swipeThreshold;
    final meetsDistance = offset > distanceThreshold;

    // 速度ベースの判定
    final meetsVelocity = velocity > _swipeVelocityThreshold;

    // どちらかの条件を満たせば表示
    return meetsDistance || meetsVelocity;
  }

  /// タスク画面を非表示すべきか判定（距離と速度の両方を考慮）
  bool _shouldHideTaskScreen(
    double offset,
    double velocity,
    double screenWidth,
  ) {
    // 距離ベースの判定
    final distanceThreshold = screenWidth * _swipeThreshold;
    final meetsDistance = offset > distanceThreshold;

    // 速度ベースの判定（左方向の速度）
    final meetsVelocity = velocity < -_swipeVelocityThreshold;

    // どちらかの条件を満たせば非表示
    return meetsDistance || meetsVelocity;
  }

  /// タスク画面を表示
  void _showTaskScreen() {
    setState(() {
      _isTaskScreenVisible = true;
      _taskScreenOffset = 0;
    });
    _animationController.forward();
  }

  /// タスク画面を非表示
  void _hideTaskScreen() {
    _animationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _isTaskScreenVisible = false;
          _taskScreenOffset = 0;
        });
      }
    });
  }

  /// ホーム画面のコンテンツを構築
  Widget _buildHomeContent(
    BuildContext context,
    WidgetRef ref,
    dynamic currentUser,
  ) {
    return SafeArea(
      child: AppDrawer(projectName: null, userName: currentUser?.userName),
    );
  }
}
