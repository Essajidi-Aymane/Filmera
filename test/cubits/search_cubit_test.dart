import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:filmera/cubits/search_cubit.dart';
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

  group('SearchCubit', () {
    blocTest<SearchCubit, DiscoverState>(
      'émet DiscoverLoaded([]) si la requête est vide',
      build: () => SearchCubit(repo: mockRepo),
      act: (cubit) => cubit.search('   '),
      expect: () => [DiscoverLoaded(const [])],
    );

    blocTest<SearchCubit, DiscoverState>(
      'émet DiscoverLoaded avec résultats quand la recherche réussit',
      build: () {
        when(() => mockRepo.search(any())).thenAnswer((_) async => fakeList);
        return SearchCubit(repo: mockRepo);
      },
      act: (cubit) => cubit.search('test'),
      expect: () => [isA<DiscoverLoading>(), isA<DiscoverLoaded>()],
    );

    blocTest<SearchCubit, DiscoverState>(
      'émet DiscoverError quand la recherche échoue',
      build: () {
        when(() => mockRepo.search(any())).thenThrow(Exception('Erreur'));
        return SearchCubit(repo: mockRepo);
      },
      act: (cubit) => cubit.search('test'),
      expect: () => [isA<DiscoverLoading>(), isA<DiscoverError>()],
    );
  });
}
