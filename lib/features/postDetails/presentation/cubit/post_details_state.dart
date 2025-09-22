part of 'post_details_cubit.dart';

abstract class PostDetailState {}

class PostDetailInitial extends PostDetailState {}

class PostDetailLoading extends PostDetailState {}

class PostDetailError extends PostDetailState {
  final String message;
  PostDetailError(this.message);
}

class PostDetailLoaded extends PostDetailState {
  final Post post;
  final List<Post> morePosts;
  final bool isFavorite;

  PostDetailLoaded({
    required this.post,
    required this.morePosts,
    this.isFavorite = false,
  });

  PostDetailLoaded copyWith({bool? isFavorite}) {
    return PostDetailLoaded(
      post: post,
      morePosts: morePosts,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
