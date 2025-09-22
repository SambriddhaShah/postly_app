import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/theme.dart';
import 'core/routes/app_router.dart';
import 'core/routes/app_routes.dart';
import 'injection/get_it.dart';
import 'features/posts/data/models/post_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register model adapter AFTER you generated post_model.g.dart
  Hive.registerAdapter(PostModelAdapter());
  Hive.registerAdapter(ReactionsAdapter());


  // Open boxes
  await Hive.openBox('postsBox');
  await Hive.openBox('favoritesBox');

  // configure DI
  await initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Postly',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
