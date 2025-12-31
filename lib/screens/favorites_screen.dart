import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../cubits/favorites_cubit.dart';
import '../models/media_item.dart';
import 'details_screen.dart';
import '../cubits/details_cubit.dart';
import '../repositories/media_repository.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesCubit>().state;
    final repo = context.read<MediaRepository>();
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final orientation = MediaQuery.of(context).orientation;

    int crossAxisCount = 2;
    if (width > 900) {
      crossAxisCount = 5;
    } else if (width > 600) {
      crossAxisCount = 4;
    } else if (orientation == Orientation.landscape) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mes Favoris')),
      body: favorites.isEmpty
          ? const Center(child: Text('Aucun favori pour le moment.'))
          : GridView.builder(
              padding: EdgeInsets.all(width * 0.02),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.6,
                crossAxisSpacing: width * 0.02,
                mainAxisSpacing: width * 0.02,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) =>
                                DetailsCubit(repo: repo)..loadDetails(item),
                            child: DetailsScreen(item: item),
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFF232526),
                                      Color(0xFF414345),
                                    ],
                                  ),
                                ),
                              ),
                              if (item.posterUrl != null)
                                CachedNetworkImage(
                                  imageUrl: item.posterUrl!,
                                  fit: BoxFit.cover,
                                )
                              else
                                const ColoredBox(color: Colors.grey),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  context.read<FavoritesCubit>().toggleFavorite(
                                    item,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: favorites.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Vider les favoris ?'),
                    content: const Text(
                      'Cette action supprimera tous vos favoris.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<FavoritesCubit>().clearFavorites();
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Vider'),
                      ),
                    ],
                  ),
                );
              },
              tooltip: 'Vider les favoris',
              child: const Icon(Icons.delete),
            )
          : null,
    );
  }
}
