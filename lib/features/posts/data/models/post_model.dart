import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/post.dart';

part 'post_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class PostModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String body;
  @HiveField(3)
  final List<String> tags;
  @HiveField(4)
  final Map<String, int> reactions; // store likes & dislikes as map
  @HiveField(5)
  final int userId;

  PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.reactions,
    required this.userId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  factory PostModel.fromEntity(Post post) => PostModel(
        id: post.id,
        title: post.title,
        body: post.body,
        tags: post.tags,
        reactions: {'likes': post.likes, 'dislikes': post.dislikes},
        userId: post.userId,
      );

  Post toEntity() => Post(
        id: id,
        title: title,
        body: body,
        tags: tags,
        reactions: reactions, // directly pass the map
        userId: userId,
      );
}

@HiveType(typeId: 1)
@JsonSerializable()
class Reactions {
  @HiveField(0)
  final int likes;
  @HiveField(1)
  final int dislikes;

  Reactions({required this.likes, required this.dislikes});

  factory Reactions.fromJson(Map<String, dynamic> json) =>
      _$ReactionsFromJson(json);
  Map<String, dynamic> toJson() => _$ReactionsToJson(this);
}
