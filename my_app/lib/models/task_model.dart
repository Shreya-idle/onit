class TaskModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final double budget;
  final String status;
  final String deadline;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.budget,
    required this.status,
    required this.deadline,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      budget: (json['budget'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'open',
      deadline: json['deadline'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'budget': budget,
      'status': status,
      'deadline': deadline,
    };
  }
}
