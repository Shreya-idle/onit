
class Testimonial {
  final String name;
  final String role;
  final String content;

  const Testimonial({
    required this.name,
    required this.role,
    required this.content,
  });

  factory Testimonial.fromJson(Map<String, dynamic> json) {
    return Testimonial(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      content: json['content'] ?? '',
    );
  }
}

