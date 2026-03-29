
class Performer {
  final String name;
  final String role;
  final double rating;
  final String description;

  const Performer({
    required this.name,
    required this.role,
    required this.rating,
    required this.description,
  });

  factory Performer.fromJson(Map<String, dynamic> json) {
    return Performer(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
    );
  }
}

