import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../cubits/discover_cubit.dart';
import '../cubits/discover_state.dart';
import '../cubits/search_cubit.dart';
import '../cubits/favorites_cubit.dart';
import '../models/media_item.dart';
import 'details_screen.dart';
import '../cubits/details_cubit.dart';
import '../repositories/media_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ShowFind'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Rechercher un film ou une série',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                searchCubit.search(value);
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchCubit, DiscoverState>(
              builder: (context, searchState) {
                // si pas de recherche → suggestions
                if (searchState is DiscoverLoaded && searchState.items.isEmpty) {
                  return BlocBuilder<DiscoverCubit, DiscoverState>(
                    builder: (context, discoverState) {
                      if (discoverState is DiscoverLoading) {
                        return const Center(
                            child: CircularProgressIndicator());
                      } else if (discoverState is DiscoverLoaded) {
                        return _MediaGrid(items: discoverState.items);
                      } else if (discoverState is DiscoverError) {
                        return Center(child: Text(discoverState.message));
                      }
                      return const SizedBox.shrink();
                    },
                  );
                }

                // sinon → résultats de recherche
                if (searchState is DiscoverLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (searchState is DiscoverLoaded) {
                  return _MediaGrid(items: searchState.items);
                } else if (searchState is DiscoverError) {
                  return Center(child: Text(searchState.message));
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaGrid extends StatelessWidget {
  final List<MediaItem> items;

  const _MediaGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesCubit>().state;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isFav = favorites
            .any((e) => e.id == item.id && e.isMovie == item.isMovie);

        return GestureDetector(
          onTap: () {
            final repo = context.read<MediaRepository>();
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
                child: item.posterUrl != null
                    ? CachedNetworkImage(imageUrl: item.posterUrl!)
                    : const ColoredBox(color: Colors.grey),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      context.read<FavoritesCubit>().toggleFavorite(item);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
