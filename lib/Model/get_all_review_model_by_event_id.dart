class AllReviewModelByEventId {
  final String id;
  final String eventId;
  final String reviewerName;
  final String reviewerId;
  final double rating;
  final String reviewText;
  final DateTime createdAt;

  AllReviewModelByEventId({
    required this.id,
    required this.eventId,
    required this.reviewerName,
    required this.reviewerId,
    required this.rating,
    required this.reviewText,
    required this.createdAt,
  });

  factory AllReviewModelByEventId.fromJson(Map<String, dynamic> json) {
    return AllReviewModelByEventId(
      id: json['_id'] ?? '',
      eventId: json['eventId'] ?? '',
      reviewerName: json['reviewer']['name'] ?? 'Anonymous',
      reviewerId: json['reviewer']['_id'] ?? '',
      rating: (json['rating'] as num).toDouble(),
      reviewText: json['review'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}