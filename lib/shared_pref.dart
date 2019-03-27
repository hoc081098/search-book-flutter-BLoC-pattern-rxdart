import 'package:built_collection/built_collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:distinct_value_connectable_observable/distinct_value_connectable_observable.dart';

class SharedPref {
  final void Function(String) toggleFavorite;
  final ValueObservable<BuiltSet<String>> favoritedIds$;

  SharedPref._(this.toggleFavorite, this.favoritedIds$);

  factory SharedPref(final Future<SharedPreferences> sharedPrefFuture) {
    //ignore: close_sinks
    final addOrRemoveFavoriteController = PublishSubject<String>();

    final favoritedIds$ = DistinctValueConnectableObservable(
      addOrRemoveFavoriteController.concatMap((bookId) async* {
        final sharedPref = await sharedPrefFuture;
        final ids = List.of(sharedPref.getStringList('KEY') ?? <String>[]);

        if (bookId == null) {
          yield SetBuilder<String>(ids).build();
          return;
        }

        if (ids.contains(bookId)) {
          ids.remove(bookId);
        } else {
          ids.add(bookId);
        }

        if (await sharedPref.setStringList('KEY', ids)) {
          yield SetBuilder<String>(ids).build();
        }
      }),
    ).autoConnect();

    favoritedIds$.listen((ids) => print('[] $ids'));
    addOrRemoveFavoriteController.add(null);

    return SharedPref._(
      addOrRemoveFavoriteController.add,
      favoritedIds$,
    );
  }
}
