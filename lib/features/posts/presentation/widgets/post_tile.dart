import 'package:flutter/material.dart';
import '../../domain/entities/post.dart';
import '../../../../core/theme/styles.dart';
import '../../../../core/theme/custom_colors.dart';

class PostTile extends StatelessWidget {
  final Post post;
  final bool isTablet;
  const PostTile({required this.post, this.isTablet = false, super.key});

  @override
  Widget build(BuildContext context) {
    final snippet = post.body.length > 120
        ? '${post.body.substring(0, 120)}...'
        : post.body;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.pushNamed(context, '/post_detail', arguments: post.id);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.title, style: Styles.title),
              const SizedBox(height: 8),
              Text(snippet, style: Styles.body),
              const SizedBox(height: 8),
              Row(
                children: [
                  // Likes
                  const Icon(Icons.thumb_up,
                      size: 16, color: CustomColors.neutralGreen),
                  const SizedBox(width: 4),
                  Text(post.likes.toString(), style: Styles.body),
                  const SizedBox(width: 16),
                  // Dislikes
                  const Icon(Icons.thumb_down,
                      size: 16, color: CustomColors.neutralRed),
                  const SizedBox(width: 4),
                  Text(post.dislikes.toString(), style: Styles.body),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 30,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: post.tags
                            .map(
                              (t) => Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: CustomColors.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  t,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
