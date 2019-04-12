import 'package:built_collection/built_collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:distinct_value_connectable_observable/distinct_value_connectable_observable.dart';

class SharedPref {
  static const _favoritedIdsKey =
      'com.hoc.search_book_api_demo_bloc_pattern_rxdart.favorited_ids';

  final void Function(String) toggleFavorite;
  final ValueObservable<BuiltSet<String>> favoritedIds$;

  SharedPref._(this.toggleFavorite, this.favoritedIds$);

  factory SharedPref(final Future<SharedPreferences> sharedPrefFuture) {
    //ignore: close_sinks
    final addOrRemoveFavoriteController = PublishSubject<String>();

    final favoritedIds$ =
        addOrRemoveFavoriteController.concatMap((bookId) async* {
      final sharedPref = await sharedPrefFuture;
      final ids =
          List.of(sharedPref.getStringList(_favoritedIdsKey) ?? <String>[]);

      if (bookId == null) {
        yield BuiltSet<String>(ids);
        return;
      }

      if (ids.contains(bookId)) {
        ids.remove(bookId);
      } else {
        ids.add(bookId);
      }

      if (await sharedPref.setStringList(_favoritedIdsKey, ids)) {
        yield BuiltSet<String>(ids);
      }
    });

    final favoritedIdsDistinctConnectable$ = publishValueDistinct(favoritedIds$)
        .autoConnect()
        ..listen((ids) => print('[FAV_IDS] $ids'));

    addOrRemoveFavoriteController.add(null);

    return SharedPref._(
      addOrRemoveFavoriteController.add,
      favoritedIdsDistinctConnectable$,
    );
  }
}
