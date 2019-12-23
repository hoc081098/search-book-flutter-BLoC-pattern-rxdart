import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:kernel/text/serializer_combinators.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_pref.g.dart';

abstract class ToggleFavResult
    implements Built<ToggleFavResult, ToggleFavResultBuilder> {
  String get id;

  bool get added;

  @nullable
  bool get result;

  @nullable
  Object get error;

  ToggleFavResult._();

  factory ToggleFavResult([void Function(ToggleFavResultBuilder) updates]) =
      _$ToggleFavResult;
}

class SharedPref {
  @visibleForTesting
  static const favoritedIdsKey =
      'com.hoc.search_book_api_search_book_rxdart.favorited_ids';

  final Future<ToggleFavResult> Function(String) toggleFavorite;

  final ValueStream<BuiltSet<String>> favoritedIds$;

  SharedPref._(
    this.toggleFavorite,
    this.favoritedIds$,
  );

  factory SharedPref(final Future<SharedPreferences> sharedPrefFuture) {
    //ignore: close_sinks
    final addOrRemoveFavoriteS =
        PublishSubject<Tuple2<String, Completer<ToggleFavResult>>>();

    final favoritedIds$ = addOrRemoveFavoriteS
        .startWith(null)
        .asyncExpand((tuple2) => _addOrRemoveId(tuple2, sharedPrefFuture))
        .publishValueDistinct()
          ..listen((ids) => print('[FAV_IDS] ids=$ids'))
          ..connect();

    return SharedPref._(
      (id) {
        final completer = Completer<ToggleFavResult>();
        addOrRemoveFavoriteS.add(Tuple2(id, completer));
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
        List.of(sharedPref.getStringList(favoritedIdsKey) ?? <String>[]);

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
      final bool result = await sharedPref.setStringList(favoritedIdsKey, ids);
      if (result) {
        yield BuiltSet<String>(ids);
      }
      completer.complete(
        ToggleFavResult(
          (b) => b
            ..added = added
            ..error = null
            ..result = result
            ..id = id,
        ),
      );
    } catch (e) {
      completer.complete(
        ToggleFavResult(
          (b) => b
            ..added = added
            ..error = e
            ..result = false
            ..id = id,
        ),
      );
    }
  }
}
