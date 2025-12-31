import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:filmera/cubits/discover_cubit.dart';
import 'package:filmera/cubits/discover_state.dart';
import 'package:filmera/models/media_item.dart';
import 'package:filmera/repositories/media_repository.dart';

class MockMediaRepository extends Mock implements MediaRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      MediaItem(
        id: 0,
        title: '',
        posterPath: null,
        isMovie: true,
        voteAverage: 0.0,
        overview: '',
      ),
    );
  });

  late MockMediaRepository mockRepo;
  late List<MediaItem> fakeList;

  setUp(() {
    mockRepo = MockMediaRepository();
    fakeList = [
      MediaItem(
        id: 1,
        title: 'Test',
        posterPath: null,
        isMovie: true,
        voteAverage: 7.5,
        overview: 'Un film de test',
      ),
    ];
  });

  group('DiscoverCubit', () {
    blocTest<DiscoverCubit, DiscoverState>(
      'émet DiscoverLoaded quand getSuggestions réussit',
      build: () {
        when(() => mockRepo.getSuggestions()).thenAnswer((_) async => fakeList);
        return DiscoverCubit(repo: mockRepo);
      },
      act: (cubit) => cubit.loadSuggestions(),
      expect: () => [isA<DiscoverLoading>(), isA<DiscoverLoaded>()],
    );

    blocTest<DiscoverCubit, DiscoverState>(
      'émet DiscoverError quand getSuggestions échoue',
      build: () {
        when(() => mockRepo.getSuggestions()).thenThrow(Exception('Erreur'));
        return DiscoverCubit(repo: mockRepo);
      },
      act: (cubit) => cubit.loadSuggestions(),
      expect: () => [isA<DiscoverLoading>(), isA<DiscoverError>()],
    );
  });
}
