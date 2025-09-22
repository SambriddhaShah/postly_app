import 'package:dio/dio.dart';
import 'package:postly_application/core/errors/failures.dart';
import '../../../../core/network/api_urls.dart';
import '../../../../core/network/dio_client.dart';
import '../models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> fetchPosts({int limit = 10, int skip = 0});
  Future<List<PostModel>> searchPosts(String q);
  Future<PostModel> getPostDetail(int id);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final DioClient client;
  PostRemoteDataSourceImpl(this.client);

  @override
  Future<List<PostModel>> fetchPosts({int limit = 10, int skip = 0}) async {
    try {
      final resp = await client
          .get(ApiUrls.posts, query: {'limit': limit, 'skip': skip});
      final data = resp.data as Map<String, dynamic>;
      print('the data that came here is ${data}');
      final list =
          (data['posts'] as List<dynamic>).cast<Map<String, dynamic>>();
      return list.map((e) => PostModel.fromJson(e)).toList();
    } catch (e) {
      throw UnknownFailure("Something went wrong");
    }
  }

  @override
  Future<List<PostModel>> searchPosts(String q) async {
    try {
      final resp = await client.get(ApiUrls.searchPosts, query: {'q': q});
      final data = resp.data as Map<String, dynamic>;
      final list =
          (data['posts'] as List<dynamic>).cast<Map<String, dynamic>>();
      return list.map((e) => PostModel.fromJson(e)).toList();
    } catch (e) {
      throw UnknownFailure("Something went wrong");
    }
  }

  @override
  Future<PostModel> getPostDetail(int id) async {
    final resp = await client.get(ApiUrls.postDetail(id));
    final data = resp.data as Map<String, dynamic>;
    return PostModel.fromJson(data);
  }
}
