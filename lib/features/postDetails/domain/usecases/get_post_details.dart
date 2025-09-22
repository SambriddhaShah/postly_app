import 'package:postly_application/features/posts/domain/entities/post.dart';
import 'package:postly_application/features/posts/domain/repositaries/post_reprositary.dart';

class GetPostDetail {
  final PostRepository repository;
  GetPostDetail(this.repository);

  Future<Post> call(int id) async {
    return repository.getPostDetail(id);
  }
}
