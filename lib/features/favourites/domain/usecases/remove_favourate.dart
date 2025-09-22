import 'package:postly_application/features/posts/domain/repositaries/post_reprositary.dart';
import '../../../posts/domain/entities/post.dart';

class RemoveFavorite {
  final PostRepository repository;

  RemoveFavorite(this.repository);

  Future<void> call(Post post) async {
    await repository.toggleFavorite(post);
  }
}
