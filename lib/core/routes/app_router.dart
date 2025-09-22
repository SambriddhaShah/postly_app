import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:postly_application/features/favourites/presentation/cubit/favourate_cubit.dart';
import 'package:postly_application/features/favourites/presentation/pages/favourate_page.dart';
import 'package:postly_application/features/postDetails/presentation/cubit/post_details_cubit.dart';
import 'package:postly_application/features/postDetails/presentation/pages/post_details_page.dart';
import 'package:postly_application/features/posts/presentation/bloc/posts_event.dart';
import 'package:postly_application/presentation/pages/splash_page.dart';
import '../../features/posts/presentation/pages/posts_page.dart';
import '../../features/posts/presentation/bloc/posts_bloc.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case AppRoutes.posts:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => GetIt.I<PostsBloc>()..add(FetchPosts()),
            child: const PostsPage(),
          ),
        );

      case AppRoutes.postDetail:
        final postId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => GetIt.I<PostDetailCubit>(),
            child: PostDetailPage(postId: postId),
          ),
        );

      case AppRoutes.favorites:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => GetIt.I<FavoritesCubit>(),
            child: const FavoritesPage(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Unknown route'))),
        );
    }
  }
}
