import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:postly_application/features/favourites/presentation/cubit/favourate_cubit.dart';
import 'package:postly_application/presentation/widgets/offline_banner.dart';
import '../../../../core/theme/styles.dart';
import '../../../../core/theme/custom_colors.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading || state is FavoritesInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoritesError) {
            return Center(child: Text(state.message, style: Styles.postBody));
          } else if (state is FavoritesLoaded) {
            final favorites = state.favorites;

            if (favorites.isEmpty) {
              return const Center(child: Text('No favorites yet'));
            }

            return Stack(children: [
              const OfflineBanner(),
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? width * 0.1 : 16, vertical: 30),
                child: Column(
                  children: favorites
                      .map((post) => InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/post_detail',
                                  arguments: post.id);
                            },
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(post.title,
                                        style: Styles.postTitle.copyWith(
                                            fontSize: isTablet ? 22 : 18)),
                                    const SizedBox(height: 8),
                                    Text(
                                      post.body.length > 100
                                          ? '${post.body.substring(0, 100)}...'
                                          : post.body,
                                      style: Styles.postBody,
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 6,
                                      children: post.tags
                                          .map((t) => Chip(
                                                backgroundColor: CustomColors
                                                    .primary
                                                    .withOpacity(0.1),
                                                label: Text(t,
                                                    style: Styles.tagText),
                                              ))
                                          .toList(),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.thumb_up,
                                                color: Colors.green.shade700,
                                                size: 20),
                                            const SizedBox(width: 4),
                                            Text('${post.likes}',
                                                style: Styles.reactionText),
                                            const SizedBox(width: 24),
                                            Icon(Icons.thumb_down,
                                                color: Colors.red.shade700,
                                                size: 20),
                                            const SizedBox(width: 4),
                                            Text('${post.dislikes}',
                                                style: Styles.reactionText),
                                          ],
                                        ),
                                        TextButton.icon(
                                          onPressed: () => context
                                              .read<FavoritesCubit>()
                                              .removeFavorite(post),
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          label: const Text('Remove',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ]);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
