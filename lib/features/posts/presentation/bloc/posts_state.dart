import 'package:equatable/equatable.dart';
import '../../domain/entities/post.dart';

abstract class PostsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<Post> posts;
  final bool hasReachedMax;
  PostsLoaded({required this.posts, this.hasReachedMax = false});
  @override
  List<Object?> get props => [posts, hasReachedMax];
}

class PostsError extends PostsState {
  final String message;
  PostsError(this.message);
  @override
  List<Object?> get props => [message];
}
