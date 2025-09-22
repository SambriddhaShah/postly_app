// lib/features/posts/data/datasources/post_local_data_source.dart
import 'package:hive/hive.dart';
import '../models/post_model.dart';

abstract class PostLocalDataSource {
  Future<void> cachePosts(List<PostModel> posts);
  Future<List<PostModel>> getCachedPosts();
  Future<void> saveFavorite(PostModel post);
  Future<void> removeFavorite(int postId);
  Future<List<PostModel>> getFavorites();
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final Box _postsBox;
  final Box _favoritesBox;
  static const String cachedKey = 'cached_posts';

  PostLocalDataSourceImpl(this._postsBox, this._favoritesBox);

  @override
  Future<void> cachePosts(List<PostModel> posts) async {
    // store as List<Map> using toJson (keeps compatibility and avoids adapter issues)
    final raw = posts.map((p) => p.toJson()).toList();
    await _postsBox.put(cachedKey, raw);
  }

  @override
  Future<List<PostModel>> getCachedPosts() async {
    final raw = _postsBox.get(cachedKey);
    if (raw == null) return [];
    final list = (raw as List).cast<Map>().map((m) {
      return PostModel.fromJson(Map<String, dynamic>.from(m));
    }).toList();
    return list;
  }

  @override
  Future<void> saveFavorite(PostModel post) async {
    await _favoritesBox.put(post.id.toString(), post.toJson());
  }

  @override
  Future<void> removeFavorite(int postId) async {
    await _favoritesBox.delete(postId.toString());
  }

  @override
  Future<List<PostModel>> getFavorites() async {
    final values = _favoritesBox.values;
    if (values.isEmpty) return [];
    return values
        .map((v) => PostModel.fromJson(Map<String, dynamic>.from(v)))
        .toList();
  }
}
