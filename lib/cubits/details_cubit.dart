import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/media_repository.dart';
import '../models/media_item.dart';
import 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  final MediaRepository repo;

  DetailsCubit({required this.repo}) : super(DetailsLoading());

  Future<void> loadDetails(MediaItem item) async {
    try {
      emit(DetailsLoading());
      final full = await repo.getDetails(item);
      emit(DetailsLoaded(full));
    } catch (e) {
      emit(DetailsError(e.toString()));
    }
  }
}
