import 'package:flutter_bloc/flutter_bloc.dart';
import 'posts_event.dart';
import 'posts_state.dart';
import '../../domain/usecases/get_posts.dart';
import '../../domain/usecases/search_posts.dart';
import '../../domain/entities/post.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetPosts _getPosts;
  final SearchPosts _searchPosts;

  final int _limit = 10;
  int _skip = 0;
  final List<Post> _posts = [];
  int get skip => _skip;

  PostsBloc({required GetPosts getPosts, required SearchPosts searchPosts})
      : _getPosts = getPosts,
        _searchPosts = searchPosts,
        super(PostsInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<SearchPostsEvent>(_onSearchPosts);
  }

  Future<void> _onFetchPosts(FetchPosts event, Emitter<PostsState> emit) async {
    try {
      // If refreshing, clear the list
      if (event.refresh) {
        _skip = 0;
        _posts.clear();
        emit(PostsLoading()); // full-screen loader on refresh
      }

      final fetched = await _getPosts.call(limit: _limit, skip: _skip);

      if (fetched.isEmpty) {
        emit(PostsLoaded(posts: List.from(_posts), hasReachedMax: true));
        return;
      }

      _skip += fetched.length;
      _posts.addAll(fetched);

      emit(PostsLoaded(
        posts: List.from(_posts),
        hasReachedMax: fetched.length < _limit,
      ));
    } catch (e) {
      emit(PostsError(e is Exception ? e.toString() : 'Unknown error'));
    }
  }

  Future<void> _onSearchPosts(
      SearchPostsEvent event, Emitter<PostsState> emit) async {
    try {
      emit(PostsLoading());
      final res = await _searchPosts.call(event.query);
      emit(PostsLoaded(posts: res, hasReachedMax: true));
    } catch (e) {
      emit(PostsError(e is Exception ? e.toString() : 'Unknown error'));
    }
  }
}
