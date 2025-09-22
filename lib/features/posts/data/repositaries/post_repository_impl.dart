// lib/features/posts/data/repositories/post_repository_impl.dart
import 'package:postly_application/features/posts/data/datasources/post_local_data_source.dart';
import 'package:postly_application/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:postly_application/features/posts/data/models/post_model.dart';
import 'package:postly_application/features/posts/domain/repositaries/post_reprositary.dart';

import '../../domain/entities/post.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remote;
  final PostLocalDataSource local;

  PostRepositoryImpl({required this.remote, required this.local});

  @override
  Future<List<Post>> getPosts({int limit = 10, int skip = 0}) async {
    try {
      final models = await remote.fetchPosts(limit: limit, skip: skip);
      await local.cachePosts(models);
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      print("some error occiured in impl $e");
      final cached = await local.getCachedPosts();
      return cached.map((m) => m.toEntity()).toList();
    }
  }

  @override
  Future<List<Post>> searchPosts(String q) async {
    try {
      final models = await remote.searchPosts(q);
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      final cached = await local.getCachedPosts();
      final filtered = cached
          .where((p) => p.title.contains(q) || p.body.contains(q))
          .toList();
      return filtered.map((m) => m.toEntity()).toList();
    }
  }

  @override
  Future<Post> getPostDetail(int id) async {
    try {
      final model = await remote.getPostDetail(id);
      return model.toEntity();
    } catch (e) {
      final cached = await local.getCachedPosts();
      final found = cached.firstWhere((p) => p.id == id);
      return found.toEntity();
    }
  }

  @override
  Future<void> cachePosts(List<Post> posts) async {
    final models = posts.map((p) => PostModel.fromEntity(p)).toList();
    await local.cachePosts(models);
  }

  @override
  Future<List<Post>> getCachedPosts() async {
    final cached = await local.getCachedPosts();
    return cached.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> toggleFavorite(Post post) async {
    final model = PostModel.fromEntity(post);
    final favs = await local.getFavorites();
    final exists = favs.any((f) => f.id == post.id);
    if (exists) {
      await local.removeFavorite(post.id);
    } else {
      await local.saveFavorite(model);
    }
  }

  @override
  Future<List<Post>> getFavorites() async {
    final favs = await local.getFavorites();
    return favs.map((m) => m.toEntity()).toList();
  }
}
