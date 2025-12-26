import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/media_repository.dart';
import 'discover_state.dart';

class DiscoverCubit extends Cubit<DiscoverState> {
  final MediaRepository repo;

  DiscoverCubit({required this.repo}) : super(DiscoverLoading());

  Future<void> loadSuggestions() async {
    try {
      emit(DiscoverLoading());
      final items = await repo.getSuggestions();
      emit(DiscoverLoaded(items));
    } catch (e) {
      emit(DiscoverError(e.toString()));
    }
  }
}
