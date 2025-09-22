class ApiUrls {
  static const String baseUrl = "https://dummyjson.com";
  static const String posts = "$baseUrl/posts";
  static const String searchPosts = "$baseUrl/posts/search";
  static String postDetail(int id) => "/posts/$id";
}
