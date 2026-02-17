import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

/// 表示名（ユーザー名）変更ダイアログ
class DisplayNameDialog extends StatefulWidget {
  const DisplayNameDialog({
    super.key,
    required this.initialName,
    required this.onSave,
  });

  final String initialName;
  final Future<void> Function(String name) onSave;

  /// ダイアログを表示する
  static Future<void> show(
    BuildContext context, {
    required String initialName,
    required Future<void> Function(String name) onSave,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => DisplayNameDialog(
        initialName: initialName,
        onSave: onSave,
      ),
    );
  }

  @override
  State<DisplayNameDialog> createState() => _DisplayNameDialogState();
}

class _DisplayNameDialogState extends State<DisplayNameDialog> {
  late TextEditingController _controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    setState(() => _isSaving = true);
    try {
      await widget.onSave(name);
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('表示名を変更'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: AppStrings.userName,
          hintText: 'プロジェクト内で表示される名前',
          border: OutlineInputBorder(),
        ),
        autofocus: true,
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text(AppStrings.cancel),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _submit,
          child: Text(_isSaving ? '保存中...' : '保存'),
        ),
      ],
    );
  }
}
