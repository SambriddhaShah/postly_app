import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;
  final String title;
  final String body;
  final List<String> tags;
  final Map<String, int> reactions;
  final int userId;

  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.reactions,
    required this.userId,
  });

  int get likes => reactions['likes'] ?? 0;
  int get dislikes => reactions['dislikes'] ?? 0;

  @override
  List<Object?> get props => [id, title, body, tags, reactions, userId];

  static fromJson(json) {}
}
