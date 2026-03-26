/// Model representing a task template category.
class TaskTemplate {
  final String title;
  final String subtitle;
  final String? imageUrl;

  const TaskTemplate({
    required this.title,
    required this.subtitle,
    this.imageUrl,
  });
}
