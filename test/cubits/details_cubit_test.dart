import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:filmera/cubits/details_cubit.dart';
import 'package:filmera/cubits/details_state.dart';
import 'package:filmera/models/media_item.dart';
import 'package:filmera/repositories/media_repository.dart';

// Mock du repository
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
  late MediaItem testItem;

  setUp(() {
    mockRepo = MockMediaRepository();
    testItem = MediaItem(
      id: 1,
      title: 'Test',
      posterPath: null,
      isMovie: true,
      voteAverage: 8.0,
      overview: 'Un film de test',
    );
  });

  group('DetailsCubit', () {
    blocTest<DetailsCubit, DetailsState>(
      'émet DetailsLoaded quand getDetails réussit',
      build: () {
        when(
          () => mockRepo.getDetails(any()),
        ).thenAnswer((_) async => testItem);
        return DetailsCubit(repo: mockRepo);
      },
      act: (cubit) => cubit.loadDetails(testItem),
      expect: () => [isA<DetailsLoading>(), isA<DetailsLoaded>()],
    );

    blocTest<DetailsCubit, DetailsState>(
      'émet DetailsError quand getDetails échoue',
      build: () {
        when(() => mockRepo.getDetails(any())).thenThrow(Exception('Erreur'));
        return DetailsCubit(repo: mockRepo);
      },
      act: (cubit) => cubit.loadDetails(testItem),
      expect: () => [isA<DetailsLoading>(), isA<DetailsError>()],
    );
  });
}
