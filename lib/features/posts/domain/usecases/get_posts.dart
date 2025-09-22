import 'package:postly_application/features/posts/domain/repositaries/post_reprositary.dart';

import '../entities/post.dart';

class GetPosts {
  final PostRepository repository;
  GetPosts(this.repository);

  Future<List<Post>> call({int limit = 10, int skip = 0}) {
    return repository.getPosts(limit: limit, skip: skip);
  }
}
