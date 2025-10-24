import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../domain/enums/priority.dart';

/// 優先度バッジWidget
class PriorityBadge extends StatelessWidget {
  final Priority priority;
  final double? fontSize;

  const PriorityBadge({super.key, required this.priority, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm,
        vertical: AppSizes.paddingXs,
      ),
      decoration: BoxDecoration(
        color: priority.lightColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: priority.color, width: 1.0),
      ),
      child: Text(
        priority.label,
        style: TextStyle(
          fontSize: fontSize ?? AppSizes.fontXs,
          fontWeight: FontWeight.bold,
          color: priority.darkColor,
        ),
      ),
    );
  }
}

/// 優先度選択用のドロップダウン
class PrioritySelector extends StatelessWidget {
  final Priority? selectedPriority;
  final ValueChanged<Priority?> onChanged;
  final bool enabled;

  const PrioritySelector({
    super.key,
    this.selectedPriority,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Priority>(
      value: selectedPriority,
      decoration: const InputDecoration(
        labelText: '優先度',
        prefixIcon: Icon(Icons.flag_outlined),
      ),
      items: Priority.values.map((priority) {
        return DropdownMenuItem<Priority>(
          value: priority,
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: priority.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSizes.spaceSm),
              Text(priority.label),
            ],
          ),
        );
      }).toList(),
      onChanged: enabled ? onChanged : null,
    );
  }
}
