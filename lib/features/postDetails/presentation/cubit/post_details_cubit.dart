import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:postly_application/features/postDetails/domain/usecases/get_more_posts.dart';
import 'package:postly_application/features/postDetails/domain/usecases/get_post_details.dart';
import 'package:postly_application/features/posts/domain/entities/post.dart';
import 'package:postly_application/features/posts/domain/repositaries/post_reprositary.dart';

part 'post_details_state.dart';

class PostDetailCubit extends Cubit<PostDetailState> {
  final GetPostDetail getPostDetail;
  final GetMorePosts getMorePosts;
  final PostRepository repository;

  bool _isFavorite = false;

  PostDetailCubit({
    required this.getPostDetail,
    required this.getMorePosts,
    required this.repository,
  }) : super(PostDetailInitial());

  bool get isFavorite => _isFavorite;

  Future<void> loadPost(int id) async {
    try {
      emit(PostDetailLoading());

      final post = await getPostDetail.call(id);

      // Get favorites from Hive
      final favs = await repository.getFavorites();
      _isFavorite = favs.any((f) => f.id == post.id);

      final morePosts = await getMorePosts.call(limit: 10, excludeId: post.id);

      emit(PostDetailLoaded(
          post: post, morePosts: morePosts, isFavorite: _isFavorite));
    } catch (e) {
      emit(PostDetailError(e.toString()));
    }
  }

  Future<void> toggleFavorite(Post post) async {
    // Toggle locally first for instant UI response
    _isFavorite = !_isFavorite;

    // Persist to Hive
    await repository.toggleFavorite(post);

    // Emit updated state
    if (state is PostDetailLoaded) {
      emit((state as PostDetailLoaded).copyWith(isFavorite: _isFavorite));
    }
  }
}
