import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/media_item.dart';

class FavoritesCubit extends Cubit<List<MediaItem>> {
  void clearFavorites() {
    emit([]);
  }

  FavoritesCubit() : super([]);

  void toggleFavorite(MediaItem item) {
    final current = List<MediaItem>.from(state);
    final index = current.indexWhere(
      (e) => e.id == item.id && e.isMovie == item.isMovie,
    );
    if (index >= 0) {
      current.removeAt(index);
    } else {
      current.add(item);
    }
    emit(current);
  }

  bool isFavorite(MediaItem item) {
    return state.any((e) => e.id == item.id && e.isMovie == item.isMovie);
  }
}
