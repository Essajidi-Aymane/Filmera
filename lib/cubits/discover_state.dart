import 'package:equatable/equatable.dart';
import '../models/media_item.dart';

abstract class DiscoverState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DiscoverLoading extends DiscoverState {}

class DiscoverLoaded extends DiscoverState {
  final List<MediaItem> items;
  DiscoverLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class DiscoverError extends DiscoverState {
  final String message;
  DiscoverError(this.message);

  @override
  List<Object?> get props => [message];
}
