import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/media_repository.dart';
import 'discover_state.dart';

class SearchCubit extends Cubit<DiscoverState> {
  final MediaRepository repo;

  SearchCubit({required this.repo}) : super(DiscoverLoaded(const []));

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(DiscoverLoaded(const []));
      return;
    }
    try {
      emit(DiscoverLoading());
      final items = await repo.search(query);
      emit(DiscoverLoaded(items));
    } catch (e) {
      emit(DiscoverError(e.toString()));
    }
  }
}
