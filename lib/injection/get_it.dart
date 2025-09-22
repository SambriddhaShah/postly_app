import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:postly_application/features/favourites/domain/usecases/get_favourates.dart';
import 'package:postly_application/features/favourites/domain/usecases/remove_favourate.dart';
import 'package:postly_application/features/favourites/presentation/cubit/favourate_cubit.dart';
import 'package:postly_application/features/postDetails/domain/usecases/get_more_posts.dart';
import 'package:postly_application/features/postDetails/domain/usecases/get_post_details.dart';
import 'package:postly_application/features/postDetails/presentation/cubit/post_details_cubit.dart';
import 'package:postly_application/features/posts/data/repositaries/post_repository_impl.dart';
import 'package:postly_application/features/posts/domain/repositaries/post_reprositary.dart';
import '../core/network/dio_client.dart';
import '../core/network/api_urls.dart';
import '../features/posts/data/datasources/post_local_data_source.dart';
import '../features/posts/data/datasources/post_remote_data_source.dart';
import '../features/posts/domain/usecases/get_posts.dart';
import '../features/posts/domain/usecases/search_posts.dart';
import '../features/posts/presentation/bloc/posts_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Dio
  final dio = Dio(BaseOptions(baseUrl: ApiUrls.baseUrl));
  getIt.registerSingleton<Dio>(dio);
  getIt.registerSingleton<DioClient>(DioClient(dio));

  // Hive boxes (assumes opened already in main)
  final postsBox = Hive.box('postsBox');
  final favoritesBox = Hive.box('favoritesBox');
  getIt.registerSingleton<Box>(postsBox, instanceName: 'postsBox');
  getIt.registerSingleton<Box>(favoritesBox, instanceName: 'favoritesBox');

  // Data sources
  getIt.registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl(getIt<DioClient>()));
  getIt
      .registerLazySingleton<PostLocalDataSource>(() => PostLocalDataSourceImpl(
            getIt<Box>(instanceName: 'postsBox'),
            getIt<Box>(instanceName: 'favoritesBox'),
          ));

  // Repository
  getIt.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      remote: getIt<PostRemoteDataSource>(),
      local: getIt<PostLocalDataSource>(),
    ),
  );

  // Usecases
  getIt.registerLazySingleton(() => GetPosts(getIt<PostRepository>()));
  getIt.registerLazySingleton(() => SearchPosts(getIt<PostRepository>()));
  getIt.registerLazySingleton(() => GetPostDetail(getIt<PostRepository>()));
  getIt.registerLazySingleton(() => GetMorePosts(getIt<PostRepository>()));
  getIt.registerLazySingleton(() => GetFavorites(getIt<PostRepository>()));
  getIt.registerLazySingleton(() => RemoveFavorite(getIt<PostRepository>()));

  // Bloc & cubit
  getIt.registerFactory(() => PostsBloc(
        getPosts: getIt<GetPosts>(),
        searchPosts: getIt<SearchPosts>(),
      ));
  getIt.registerFactory(() => PostDetailCubit(
        getPostDetail: getIt<GetPostDetail>(),
        getMorePosts: getIt<GetMorePosts>(),
        repository: getIt<PostRepository>(),
      ));
  getIt.registerFactory(() => FavoritesCubit(
        getFavorites: getIt<GetFavorites>(),
        removeFavoriteUsecase: getIt<RemoveFavorite>(),
      ));
}
