class Review {
  final String author;
  final String comment;
  final double rating;

  Review({
    required this.author,
    required this.comment,
    required this.rating,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      author: json['author'] ?? '',
      comment: json['comment'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ClientDetails {
  final String name;
  final String? imageUrl;
  final double rating;
  final String overview;
  final Map<String, dynamic> stats;
  final List<Review> reviews;
  final List<String> categories;

  ClientDetails({
    required this.name,
    this.imageUrl,
    required this.rating,
    required this.overview,
    required this.stats,
    required this.reviews,
    required this.categories,
  });

  factory ClientDetails.fromJson(Map<String, dynamic> json) {
    return ClientDetails(
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      overview: json['overview'] ?? '',
      stats: Map<String, dynamic>.from(json['stats'] ?? {}),
      reviews: (json['reviews'] as List? ?? [])
          .map((v) => Review.fromJson(v))
          .toList(),
      categories: List<String>.from(json['categories'] ?? []),
    );
  }
}
