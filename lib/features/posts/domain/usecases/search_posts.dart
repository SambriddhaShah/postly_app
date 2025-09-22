import 'package:postly_application/features/posts/domain/repositaries/post_reprositary.dart';

import '../entities/post.dart';

class SearchPosts {
  final PostRepository repository;
  SearchPosts(this.repository);

  Future<List<Post>> call(String query) {
    return repository.searchPosts(query);
  }
}
