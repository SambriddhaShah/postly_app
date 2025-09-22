import 'package:postly_application/features/posts/domain/entities/post.dart';
import 'package:postly_application/features/posts/domain/repositaries/post_reprositary.dart';

class GetMorePosts {
  final PostRepository repository;
  GetMorePosts(this.repository);

  Future<List<Post>> call({int limit = 10, int excludeId = 0}) async {
    final posts = await repository.getPosts(limit: limit, skip: 0);
    return posts.where((p) => p.id != excludeId).toList();
  }
}
