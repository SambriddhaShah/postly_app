// lib/features/posts/domain/repositories/post_repository.dart
import '../entities/post.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts({int limit = 10, int skip = 0});
  Future<List<Post>> searchPosts(String q);
  Future<Post> getPostDetail(int id);
  Future<void> cachePosts(List<Post> posts);
  Future<List<Post>> getCachedPosts();
  Future<void> toggleFavorite(Post post);
  Future<List<Post>> getFavorites();
}
