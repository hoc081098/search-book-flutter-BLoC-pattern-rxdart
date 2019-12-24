import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:search_book/data/favorited_books_repo_impl.dart';
import 'package:search_book/domain/toggle_fav_result.dart';
import 'package:mockito/mockito.dart';

class MockRxPrefs extends Mock implements RxSharedPreferences {}

main() {
  WidgetsFlutterBinding.ensureInitialized();

  group('Test $FavoritedBooksRepoImpl', () {
    const kTestValues = <String, dynamic>{
      'flutter.${FavoritedBooksRepoImpl.favoritedIdsKey}': <String>[],
    };
    FavoritedBooksRepoImpl favBooksRepo;
    MockRxPrefs mockRxPrefs;

    setUp(() async {
      mockRxPrefs = MockRxPrefs();

      when(mockRxPrefs
              .getStringListStream(FavoritedBooksRepoImpl.favoritedIdsKey))
          .thenAnswer((_) => Stream.value(<String>[]));
      when(mockRxPrefs.getStringList(FavoritedBooksRepoImpl.favoritedIdsKey))
          .thenAnswer((_) => Future.value(<String>[]));
      when(mockRxPrefs.setStringList(
              FavoritedBooksRepoImpl.favoritedIdsKey, any))
          .thenAnswer((_) => Future.value(true));

      favBooksRepo = FavoritedBooksRepoImpl(mockRxPrefs);
    });

    tearDown(() async {});

    test('Emit initial value', () async {
      await expectLater(favBooksRepo.favoritedIds$, emits(<String>[]));
    });

    test('Add or remove id', () async {
      when(mockRxPrefs.getStringList(FavoritedBooksRepoImpl.favoritedIdsKey))
          .thenAnswer((_) => Future.value(<String>[]));

      const id = 'hoc081098';
      final result1 = ToggleFavResult(
        (b) => b
          ..id = id
          ..added = true
          ..error = null
          ..result = true,
      );
      expect(await favBooksRepo.toggleFavorited(id), result1);

      when(mockRxPrefs.getStringList(FavoritedBooksRepoImpl.favoritedIdsKey))
          .thenAnswer((_) => Future.value([id]));

      final result2 = ToggleFavResult(
        (b) => b
          ..id = id
          ..added = false
          ..error = null
          ..result = true,
      );
      expect(await favBooksRepo.toggleFavorited(id), result2);
    });

    test('Stream emit value after add or remove id', () async {


      const id = 'hoc081098';
      const expected = <List<String>>[
        <String>[],
        <String>[id],
        <String>[],
        <String>[id],
      ];

      mockRxPrefs = MockRxPrefs();
      when(mockRxPrefs
          .getStringListStream(FavoritedBooksRepoImpl.favoritedIdsKey))
          .thenAnswer((_) => Stream<List<String>>.fromIterable(expected));
      favBooksRepo = FavoritedBooksRepoImpl(mockRxPrefs);

      await expectLater(
        favBooksRepo.favoritedIds$,
        emitsInOrder(expected),
      );
    });
  });
}
