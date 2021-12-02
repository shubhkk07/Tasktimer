class TaskList {
  List<Task>? tasks;
  TaskList({this.tasks});

  factory TaskList.fromJson(List<dynamic> parsedJson) {
    List<Task> tasks = [];
    tasks = parsedJson.map((i) => Task.fromJson(i)).toList();
    return TaskList(tasks: tasks);
  }
}

class Task {
  final int? id;
  final String? title;
  final String? description;
  final String? taskDuration;
  final int? isCompleted;

  Task(
      {this.id,
      this.title,
      this.description,
      this.taskDuration,
      this.isCompleted});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        taskDuration: json['duration'],
        isCompleted: json['status']);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'duration': taskDuration,
      'status': isCompleted
    };
  }
}
