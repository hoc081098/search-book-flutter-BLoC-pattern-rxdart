import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:kernel/text/serializer_combinators.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:distinct_value_connectable_observable/distinct_value_connectable_observable.dart';

class ToggleFavResult {
  final String id;
  final bool added;
  final bool result;
  final error;

  const ToggleFavResult({
    @required this.id,
    @required this.added,
    @required this.result,
    @required this.error,
  })  : assert(added != null),
        assert(result != null),
        assert(id != null);

  @override
  String toString() =>
      'ToggleFavResult{id=$id, added=$added, result=$result, error=$error}';
}

class SharedPref {
  static const _favoritedIdsKey =
      'com.hoc.search_book_api_demo_bloc_pattern_rxdart.favorited_ids';

  final Future<ToggleFavResult> Function(String) toggleFavorite;

  final ValueObservable<BuiltSet<String>> favoritedIds$;

  SharedPref._(
    this.toggleFavorite,
    this.favoritedIds$,
  );

  factory SharedPref(final Future<SharedPreferences> sharedPrefFuture) {
    //ignore: close_sinks
    final addOrRemoveFavoriteController =
        PublishSubject<Tuple2<String, Completer<ToggleFavResult>>>();

    final favoritedIds$ = publishValueDistinct(
      addOrRemoveFavoriteController
          .startWith(null)
          .concatMap((tuple2) => _addOrRemoveId(tuple2, sharedPrefFuture)),
    )
      ..listen((ids) => print('[FAV_IDS] ids=$ids'))
      ..connect();

    return SharedPref._(
      (id) {
        final completer = Completer<ToggleFavResult>();
        addOrRemoveFavoriteController.add(Tuple2(id, completer));
        return completer.future;
      },
      favoritedIds$,
    );
  }

  static Stream<BuiltSet<String>> _addOrRemoveId(
    Tuple2<String, Completer<ToggleFavResult>> tuple2,
    Future<SharedPreferences> sharedPrefFuture,
  ) async* {
    final sharedPref = await sharedPrefFuture;
    final ids =
        List.of(sharedPref.getStringList(_favoritedIdsKey) ?? <String>[]);

    if (tuple2 == null) {
      yield BuiltSet<String>(ids);
      return;
    }

    final String id = tuple2.first;
    final Completer<ToggleFavResult> completer = tuple2.second;

    bool added;
    if (ids.contains(id)) {
      ids.remove(id);
      added = false;
    } else {
      ids.add(id);
      added = true;
    }

    try {
      final bool result = await sharedPref.setStringList(_favoritedIdsKey, ids);
      if (result) {
        yield BuiltSet<String>(ids);
      }
      completer.complete(
        ToggleFavResult(
          added: added,
          error: null,
          result: result,
          id: id,
        ),
      );
    } catch (e) {
      completer.complete(
        ToggleFavResult(
          added: added,
          error: e,
          result: false,
          id: id,
        ),
      );
    }
  }
}
