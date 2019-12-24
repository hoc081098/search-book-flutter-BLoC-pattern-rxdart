import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:meta/meta.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search_book/domain/toggle_fav_result.dart';
import 'package:search_book/domain/favorited_books_repo.dart';

class FavoritedBooksRepoImpl implements FavoritedBooksRepo {
  @visibleForTesting
  static const favoritedIdsKey =
      'com.hoc.search_book_api_search_book_rxdart.favorited_ids';

  final RxSharedPreferences _rxPrefs;

  @override
  final ValueStream<BuiltSet<String>> favoritedIds$;

  FavoritedBooksRepoImpl(this._rxPrefs)
      : favoritedIds$ = _rxPrefs
            .getStringListStream(favoritedIdsKey)
            .map((ids) => BuiltSet.of(ids ?? <String>[]))
            .publishValueDistinct()
              ..listen((ids) => print('[FAV_IDS] ids=$ids'))
              ..connect();

  @override
  Future<ToggleFavResult> toggleFavorited(String bookId) async {
    final ids = (await _rxPrefs.getStringList(favoritedIdsKey)) ?? <String>[];

    bool added;
    List<String> newIds;
    if (ids.contains(bookId)) {
      newIds = ids.where((id) => id != bookId).toList();
      added = false;
    } else {
      newIds = [...ids, bookId];
      added = true;
    }

    try {
      final bool result = await _rxPrefs.setStringList(favoritedIdsKey, newIds);
      return ToggleFavResult(
        (b) => b
          ..added = added
          ..error = null
          ..result = result
          ..id = bookId,
      );
    } catch (e) {
      return ToggleFavResult(
        (b) => b
          ..added = added
          ..error = e
          ..result = false
          ..id = bookId,
      );
    }
  }
}
