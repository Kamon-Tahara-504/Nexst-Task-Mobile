import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/gradient_background.dart';
import '../../../../shared/widgets/app_drawer.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';

/// プロジェクト未選択時の全画面サイドメニュー画面
class NoProjectScreen extends ConsumerWidget {
  const NoProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: AppDrawer(projectName: null, userName: currentUser?.userName),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              // 画面表示時に自動的にDrawerを開く
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Scaffold.of(context).openDrawer();
              });
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
