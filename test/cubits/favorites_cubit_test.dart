import 'package:flutter_test/flutter_test.dart';
import 'package:filmera/cubits/favorites_cubit.dart';
import 'package:filmera/models/media_item.dart';

void main() {
  late FavoritesCubit cubit;
  late MediaItem item;

  setUp(() {
    cubit = FavoritesCubit();
    item = MediaItem(
      id: 1,
      title: 'Test',
      posterPath: null,
      isMovie: true,
      voteAverage: 7.0,
      overview: 'Un film de test',
    );
  });

  test('état initial est une liste vide', () {
    expect(cubit.state, isEmpty);
  });

  test('toggleFavorite ajoute un favori', () {
    cubit.toggleFavorite(item);
    expect(cubit.state, contains(item));
    expect(cubit.isFavorite(item), isTrue);
  });

  test('toggleFavorite retire un favori déjà présent', () {
    cubit.toggleFavorite(item);
    cubit.toggleFavorite(item);
    expect(cubit.state, isEmpty);
    expect(cubit.isFavorite(item), isFalse);
  });

  test('clearFavorites vide la liste', () {
    cubit.toggleFavorite(item);
    cubit.clearFavorites();
    expect(cubit.state, isEmpty);
  });
}
