import 'package:equatable/equatable.dart';

abstract class PostsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPosts extends PostsEvent {
  final bool refresh;
  FetchPosts({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

class SearchPostsEvent extends PostsEvent {
  final String query;
  SearchPostsEvent(this.query);

  @override
  List<Object?> get props => [query];
}
