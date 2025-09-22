import '../../../posts/domain/entities/post.dart';
import '../../../posts/domain/repositaries/post_reprositary.dart';

class GetFavorites {
  final PostRepository repository;

  GetFavorites(this.repository);

  Future<List<Post>> call() async {
    return repository.getFavorites();
  }
}
