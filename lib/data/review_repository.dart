import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'database.dart';

/// Modelo de reseña.
class ReviewModel {
  final String id;
  final String roomId;
  final String roomTitle;
  final String reviewerId;
  final String reviewerName;
  final String reviewerAvatar;
  final double rating;
  final String title;
  final String body;
  final List<String> pros;
  final List<String> cons;
  final DateTime createdAt;
  final int helpfulCount;
  final bool? isHelpful;

  const ReviewModel({
    required this.id,
    required this.roomId,
    required this.roomTitle,
    required this.reviewerId,
    required this.reviewerName,
    required this.reviewerAvatar,
    required this.rating,
    required this.title,
    required this.body,
    this.pros = const [],
    this.cons = const [],
    required this.createdAt,
    this.helpfulCount = 0,
    this.isHelpful,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'roomId': roomId,
        'roomTitle': roomTitle,
        'reviewerId': reviewerId,
        'reviewerName': reviewerName,
        'reviewerAvatar': reviewerAvatar,
        'rating': rating,
        'title': title,
        'body': body,
        'pros': pros,
        'cons': cons,
        'createdAt': createdAt.toIso8601String(),
        'helpfulCount': helpfulCount,
      };

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json['id'] as String? ?? '',
        roomId: json['roomId'] as String? ?? '',
        roomTitle: json['roomTitle'] as String? ?? '',
        reviewerId: json['reviewerId'] as String? ?? '',
        reviewerName: json['reviewerName'] as String? ?? '',
        reviewerAvatar: json['reviewerAvatar'] as String? ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        title: json['title'] as String? ?? '',
        body: json['body'] as String? ?? '',
        pros: List<String>.from(json['pros'] as List? ?? []),
        cons: List<String>.from(json['cons'] as List? ?? []),
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
        helpfulCount: json['helpfulCount'] as int? ?? 0,
      );
}

class ReviewRepository {
  static const _uuid = Uuid();

  static List<ReviewModel> getByRoom(String roomId) {
    return Database.reviewsBox.values.map((v) {
      final map = Map<String, dynamic>.from(jsonDecode(v as String));
      return ReviewModel.fromJson(map);
    }).where((r) => r.roomId == roomId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  static List<ReviewModel> getByReviewer(String reviewerId) {
    return Database.reviewsBox.values.map((v) {
      final map = Map<String, dynamic>.from(jsonDecode(v as String));
      return ReviewModel.fromJson(map);
    }).where((r) => r.reviewerId == reviewerId).toList();
  }

  static Future<ReviewModel> create(ReviewModel review) async {
    final newReview = review.copyWith(id: _uuid.v4());
    await Database.reviewsBox.put(
        newReview.id, jsonEncode(newReview.toJson()));
    return newReview;
  }

  static Future<void> markHelpful(String id, bool helpful) async {
    final raw = Database.reviewsBox.get(id);
    if (raw == null) return;
    final map = Map<String, dynamic>.from(jsonDecode(raw as String));
    final review = ReviewModel.fromJson(map);
    final updated = ReviewModel(
      id: review.id,
      roomId: review.roomId,
      roomTitle: review.roomTitle,
      reviewerId: review.reviewerId,
      reviewerName: review.reviewerName,
      reviewerAvatar: review.reviewerAvatar,
      rating: review.rating,
      title: review.title,
      body: review.body,
      pros: review.pros,
      cons: review.cons,
      createdAt: review.createdAt,
      helpfulCount: helpful ? review.helpfulCount + 1 : review.helpfulCount,
      isHelpful: helpful,
    );
    await Database.reviewsBox.put(id, jsonEncode(updated.toJson()));
  }

  static double getAverageRating(String roomId) {
    final reviews = getByRoom(roomId);
    if (reviews.isEmpty) return 0.0;
    return reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        reviews.length;
  }

  static int getCount(String roomId) => getByRoom(roomId).length;
}

extension on ReviewModel {
  ReviewModel copyWith({String? id}) => ReviewModel(
        id: id ?? this.id,
        roomId: roomId,
        roomTitle: roomTitle,
        reviewerId: reviewerId,
        reviewerName: reviewerName,
        reviewerAvatar: reviewerAvatar,
        rating: rating,
        title: title,
        body: body,
        pros: pros,
        cons: cons,
        createdAt: createdAt,
        helpfulCount: helpfulCount,
        isHelpful: isHelpful,
      );
}
