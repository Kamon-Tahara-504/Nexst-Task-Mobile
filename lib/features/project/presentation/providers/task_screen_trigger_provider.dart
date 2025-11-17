import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A lightweight trigger to request opening the TaskBoard screen
///
/// We use a counter so each increment emits a new value that listeners can react to.
final openTaskScreenTriggerProvider = StateProvider<int>((ref) => 0);

/// Helper to request opening the TaskBoard screen from anywhere with access to [WidgetRef].
void requestOpenTaskScreen(WidgetRef ref) {
  final notifier = ref.read(openTaskScreenTriggerProvider.notifier);
  notifier.state = notifier.state + 1;
}


