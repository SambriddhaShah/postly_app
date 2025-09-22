import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/bloc/posts_bloc.dart';
import '../../presentation/bloc/posts_event.dart';
import '../../presentation/bloc/posts_state.dart';
import '../widgets/post_tile.dart';
import '../../../../presentation/widgets/offline_banner.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});
  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final _scrollController = ScrollController();
  final _searchCtrl = TextEditingController();
  late PostsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<PostsBloc>(context);
    _bloc.add(FetchPosts());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _bloc.add(FetchPosts());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Postly'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
        child: const Icon(Icons.arrow_upward),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _bloc.add(FetchPosts(refresh: true)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? width * 0.1 : 12, vertical: 8),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Search posts...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchCtrl.clear();
                            _bloc.add(FetchPosts(refresh: true));
                            FocusScope.of(context)
                                .unfocus(); // removes keyboard focus
                          },
                        )
                      : null,
                ),
                onChanged: (v) {
                  setState(() {}); // refresh suffixIcon visibility
                  if (v.isEmpty) {
                    _bloc.add(FetchPosts(refresh: true));
                  } else {
                    _bloc.add(SearchPostsEvent(v));
                  }
                },
              ),
            ),
            const OfflineBanner(),
            Expanded(
              child: BlocBuilder<PostsBloc, PostsState>(
                builder: (context, state) {
                  if (state is PostsLoading && !_blocHasData()) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is PostsError) {
                    return Center(
                        child: Text(state.message,
                            style: const TextStyle(color: Colors.red)));
                  }
                  if (state is PostsLoaded) {
                    if (state.posts.isEmpty) {
                      return const Center(child: Text('No posts found'));
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.posts.length + 1,
                      itemBuilder: (context, idx) {
                        if (idx < state.posts.length) {
                          return PostTile(
                              post: state.posts[idx], isTablet: isTablet);
                        } else {
                          if (state.hasReachedMax) {
                            return const Padding(
                              padding: EdgeInsets.all(12),
                              child: Center(child: Text("No more posts")),
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.all(12),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                        }
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _blocHasData() {
    final state = _bloc.state;
    return state is PostsLoaded && state.posts.isNotEmpty;
  }
}
