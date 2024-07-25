import 'package:taskmanagementapp/models/user.dart';

class Task {
  final int? id;
  final String? title;
  final String? description;
  final DateTime? dueDate;
  final String? priority;
  final String? status;
  final User? assignedUser;

  Task({
    this.id,
    this.title,
    this.description,
    this.dueDate,
    this.priority,
    this.status,
    this.assignedUser,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      priority: json['priority'],
      status: json['status'],
      assignedUser: json['assignedUser'] != null ? User.fromJson(json['assignedUser']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority,
      'status': status,
      'assignedUser': assignedUser?.toJson(),
    };
  }
}
