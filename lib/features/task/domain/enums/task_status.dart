/// タスクのステータスを表すEnum
enum TaskStatus {
  /// 未着手
  todo('todo', '未着手'),

  /// 進行中
  inProgress('in-progress', '進行中'),

  /// 完了
  done('done', '完了');

  const TaskStatus(this.value, this.label);

  /// データベースでの値
  final String value;

  /// 表示用ラベル
  final String label;

  /// 文字列からTaskStatusを取得
  static TaskStatus fromString(String value) {
    return TaskStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TaskStatus.todo,
    );
  }

  /// データベース保存用の文字列に変換
  String toJson() => value;

  /// 次のステータスを取得
  TaskStatus get next {
    switch (this) {
      case TaskStatus.todo:
        return TaskStatus.inProgress;
      case TaskStatus.inProgress:
        return TaskStatus.done;
      case TaskStatus.done:
        return TaskStatus.todo;
    }
  }

  /// 前のステータスを取得
  TaskStatus get previous {
    switch (this) {
      case TaskStatus.todo:
        return TaskStatus.done;
      case TaskStatus.inProgress:
        return TaskStatus.todo;
      case TaskStatus.done:
        return TaskStatus.inProgress;
    }
  }
}
