import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:disposebag/disposebag.dart';
import 'package:search_book/domain/book_repo.dart';
import 'package:search_book/domain/cache_policy.dart';
import 'package:search_book/pages/fav_page/fav_books_state.dart';
import 'package:search_book/shared_pref.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:distinct_value_connectable_observable/distinct_value_connectable_observable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class FavBooksInteractor {
  final BookRepo _bookRepo;
  final ValueObservable<BuiltSet<String>> favoritedIds$;
  final void Function(String) toggleFavorite;

  FavBooksInteractor(this._bookRepo, SharedPref _sharedPref)
      : assert(_bookRepo != null),
        assert(_sharedPref != null),
        favoritedIds$ = _sharedPref.favoritedIds$,
        toggleFavorite = _sharedPref.toggleFavorite;

  Stream<FavBookPartialChange> partialChanges(
    Iterable<String> ids, [
    bool forceUpdate = false,
    Completer<void> completer,
  ]) {
    return Observable.fromIterable(ids)
        .flatMap((id) {
          final stream = _bookRepo.getBookBy(
            id: id,
            cachePolicy:
                forceUpdate ? CachePolicy.networkOnly : CachePolicy.localFirst,
          );
          return Observable(stream)
              .map<FavBookPartialChange>((book) => LoadedFavBookChange(book))
              .onErrorReturnWith((e) => ErrorFavBookChange(e));
        })
        .startWith(FavIdsListChange(ids.toList(growable: false)))
        .doOnDone(() => completer?.complete());
  }
}

// ignore_for_file: close_sinks

class FavBooksBloc implements BaseBloc {
  ///
  ///
  ///
  final void Function(String) removeFavorite;
  final Future<void> Function() refresh;

  ///
  ///
  ///
  final ValueObservable<FavBooksState> state$;

  ///
  ///
  ///
  final void Function() _dispose;

  FavBooksBloc._(
    this.removeFavorite,
    this.refresh,
    this.state$,
    this._dispose,
  );

  @override
  void dispose() => _dispose();

  factory FavBooksBloc(final FavBooksInteractor interactor) {
    assert(interactor != null, 'interactor cannot be null');

    final removeFavoriteController = PublishSubject<String>();
    final refreshController = PublishSubject<Completer<void>>();

    final state$ = publishValueSeededDistinct(
      Observable.merge(
        [
          interactor.favoritedIds$.switchMap(interactor.partialChanges),
          refreshController
              .withLatestFrom(
                interactor.favoritedIds$,
                (Completer<void> completer, BuiltSet<String> ids) =>
                    Tuple2(completer, ids),
              )
              .exhaustMap((tuple2) =>
                  interactor.partialChanges(tuple2.item2, true, tuple2.item1)),
        ],
      )
          .doOnData((change) => print('[FAV_BOOKS] change=$change'))
          .scan(_reducer, FavBooksState.initial()),
      seedValue: FavBooksState.initial(),
    );

    ///
    ///
    ///

    final bag = DisposeBag(
      [
        refreshController,
        removeFavoriteController,
        //
        state$.listen((state) => print('[FAV_BOOKS] state=$state')),
        removeFavoriteController
            .throttleTime(const Duration(milliseconds: 600))
            .listen(interactor.toggleFavorite),
        //
        state$.connect(),
      ],
    );

    return FavBooksBloc._(
      removeFavoriteController.add,
      () {
        final completer = Completer<void>();
        refreshController.add(completer);
        return completer.future
            .whenComplete(() => print('[FAV_BOOKS] refresh done'));
      },
      state$,
      () => bag.dispose().then((_) => print('[FAV_BOOKS] dispose')),
    );
  }

  static FavBooksState _reducer(
      FavBooksState state, FavBookPartialChange change, _) {
    if (change is FavIdsListChange) {
      final books = ListBuilder<FavBookItem>(
        change.ids.map((id) {
          return FavBookItem((b) => b
            ..id = id
            ..isLoading = true);
        }),
      );

      return state.rebuild((b) => b
        ..books = books
        ..isLoading = false);
    }
    if (change is LoadedFavBookChange) {
      final book = change.book;

      return state.rebuild((b) {
        b.books.map((bookItem) {
          if (bookItem.id == book.id) {
            return bookItem.rebuild((b) => b
              ..isLoading = false
              ..title = book.title
              ..subtitle = book.subtitle
              ..thumbnail = book.thumbnail);
          }
          return bookItem;
        });
      });
    }
    return state;
  }
}
