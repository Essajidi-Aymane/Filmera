import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/media_item.dart';
import '../cubits/details_cubit.dart';
import '../cubits/details_state.dart';
import '../cubits/favorites_cubit.dart';

class DetailsScreen extends StatelessWidget {
  final MediaItem item;

  const DetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: BlocBuilder<DetailsCubit, DetailsState>(
        builder: (context, state) {
          if (state is DetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DetailsLoaded) {
            final media = state.item;
            final favoritesCubit = context.watch<FavoritesCubit>();
            final isFav = favoritesCubit.isFavorite(media);

            final tmdbUrl = media.isMovie
                ? 'https://www.themoviedb.org/movie/${media.id}'
                : 'https://www.themoviedb.org/tv/${media.id}';

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (media.posterUrl != null)
                    CachedNetworkImage(imageUrl: media.posterUrl!),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(media.overview),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Note TMDb : ${media.voteAverage.toStringAsFixed(1)}',
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border),
                        onPressed: () =>
                            context.read<FavoritesCubit>().toggleFavorite(media),
                      ),
                      const Text('Ajouter aux favoris'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Page TMDb'),
                    subtitle: Text(tmdbUrl),
                    onTap: () async {
                      final uri = Uri.parse(tmdbUrl);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                    },
                  ),
                  // plus tard : liens “où regarder” via une 2e API
                ],
              ),
            );
          } else if (state is DetailsError) {
            return Center(child: Text('Erreur : ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
