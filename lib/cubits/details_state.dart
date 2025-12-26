import 'package:equatable/equatable.dart';
import '../models/media_item.dart';

abstract class DetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DetailsLoading extends DetailsState {}

class DetailsLoaded extends DetailsState {
  final MediaItem item;
  DetailsLoaded(this.item);

  @override
  List<Object?> get props => [item];
}

class DetailsError extends DetailsState {
  final String message;
  DetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
