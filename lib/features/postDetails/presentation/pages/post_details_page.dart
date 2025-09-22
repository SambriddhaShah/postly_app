import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:postly_application/features/postDetails/presentation/cubit/post_details_cubit.dart';
import 'package:postly_application/presentation/widgets/offline_banner.dart';
import '../../../../core/theme/styles.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../features/posts/domain/entities/post.dart';

class PostDetailPage extends StatefulWidget {
  final int postId;
  const PostDetailPage({required this.postId, super.key});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  bool showFullBody = false;

  @override
  void initState() {
    super.initState();
    context.read<PostDetailCubit>().loadPost(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primary,
        title: const Text('Post Details'),
      ),
      body: BlocBuilder<PostDetailCubit, PostDetailState>(
        builder: (context, state) {
          if (state is PostDetailLoading || state is PostDetailInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostDetailError) {
            return Center(child: Text(state.message, style: Styles.postBody));
          } else if (state is PostDetailLoaded) {
            final post = state.post;
            final snippet = showFullBody || post.body.length <= 200
                ? post.body
                : '${post.body.substring(0, 200)}...';

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? width * 0.1 : 16,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const OfflineBanner(),
                  // Post Title
                  Text(
                    post.title,
                    style: Styles.postTitle.copyWith(
                      fontSize: isTablet ? 28 : 22,
                      color: CustomColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Main Post Card
                  Card(
                    elevation: 3,
                    color: CustomColors.cardBackground,
                    shadowColor: CustomColors.shadow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snippet,
                              style: Styles.postBody.copyWith(
                                color: CustomColors.textSecondary,
                              )),
                          if (post.body.length > 200)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: CustomColors.primary,
                                ),
                                onPressed: () => setState(
                                  () => showFullBody = !showFullBody,
                                ),
                                child: Text(
                                  showFullBody ? 'See Less' : 'See More',
                                ),
                              ),
                            ),
                          const SizedBox(height: 12),

                          // Tags
                          Wrap(
                            spacing: 6,
                            children: post.tags
                                .map(
                                  (t) => Chip(
                                    backgroundColor:
                                        CustomColors.primary.withOpacity(0.1),
                                    label: Text(t, style: Styles.tagText),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 16),

                          // Reactions + Favorite
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.thumb_up,
                                      color: Colors.green.shade700, size: 20),
                                  const SizedBox(width: 4),
                                  Text('${post.likes}',
                                      style: Styles.reactionText),
                                  const SizedBox(width: 24),
                                  Icon(Icons.thumb_down,
                                      color: Colors.red.shade700, size: 20),
                                  const SizedBox(width: 4),
                                  Text('${post.dislikes}',
                                      style: Styles.reactionText),
                                ],
                              ),
                              BlocBuilder<PostDetailCubit, PostDetailState>(
                                builder: (context, state) {
                                  return GestureDetector(
                                    onTap: () => context
                                        .read<PostDetailCubit>()
                                        .toggleFavorite(post),
                                    child: Row(
                                      children: [
                                        Icon(
                                          state is PostDetailLoaded &&
                                                  state.isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: state is PostDetailLoaded &&
                                                  state.isFavorite
                                              ? CustomColors.primary
                                              : Colors.grey.shade400,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          state is PostDetailLoaded &&
                                                  state.isFavorite
                                              ? 'Favorite'
                                              : 'Add to Favorite',
                                          style: Styles.favoriteText,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // More Posts Section
                  Text(
                    'More Posts',
                    style: Styles.subtitle.copyWith(
                      color: CustomColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 180,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: state.morePosts
                          .where((p) => p.id != post.id)
                          .map(
                            (p) => GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(
                                context,
                                '/post_detail',
                                arguments: p.id,
                              ),
                              child: Container(
                                width: isTablet ? 300 : 240,
                                margin: const EdgeInsets.only(right: 12),
                                child: Card(
                                  elevation: 3,
                                  color: CustomColors.cardBackground,
                                  shadowColor: CustomColors.shadow,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Styles.body.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: CustomColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          p.body.length > 80
                                              ? '${p.body.substring(0, 80)}...'
                                              : p.body,
                                          style: Styles.body.copyWith(
                                            fontSize: 14,
                                            color: CustomColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
