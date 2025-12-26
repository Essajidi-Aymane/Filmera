import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'services/tmdb_api.dart';
import 'repositories/media_repository.dart';
import 'cubits/discover_cubit.dart';
import 'cubits/search_cubit.dart';
import 'cubits/favorites_cubit.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final tmdbApi = TmdbApi();
  final mediaRepo = MediaRepository(api: tmdbApi);

  runApp(MyApp(mediaRepository: mediaRepo));
}

class MyApp extends StatelessWidget {
  final MediaRepository mediaRepository;
  const MyApp({super.key, required this.mediaRepository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: mediaRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                DiscoverCubit(repo: mediaRepository)..loadSuggestions(),
          ),
          BlocProvider(
            create: (_) => SearchCubit(repo: mediaRepository),
          ),
          BlocProvider(
            create: (_) => FavoritesCubit(),
          ),
        ],
        child: MaterialApp(
          title: 'ShowFind',
          theme: ThemeData.dark(),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
