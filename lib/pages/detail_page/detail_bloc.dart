import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:search_book/api/book_api.dart';
import 'package:search_book/model/book_model.dart';
import 'package:search_book/pages/detail_page/detail_state.dart';
import 'package:search_book/shared_pref.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:distinct_value_connectable_observable/distinct_value_connectable_observable.dart';

// ignore_for_file: close_sinks

class DetailBloc implements BaseBloc {
  ///
  ///
  ///
  final ValueObservable<BookDetailState> bookDetail$;
  final Stream<Object> error$;

  ///
  ///
  ///
  final Future<void> Function() refresh;
  final void Function() toggleFavorited;

  ///
  /// Clean up resource
  ///
  final void Function() _dispose;

  DetailBloc._(
    this.bookDetail$,
    this.error$,
    this.refresh,
    this.toggleFavorited,
    this._dispose,
  );

  factory DetailBloc(
    final BookApi api,
    final SharedPref sharedPref,
    final Book initial,
  ) {
    assert(api != null);
    assert(sharedPref != null);
    assert(initial != null);

    final refreshController = PublishSubject<Completer>();
    final errorController = PublishSubject<Object>();
    final toggleController = PublishSubject<void>();

    final state$ = Observable.combineLatest2(
      refreshController.exhaustMap((completer) async* {
        try {
          yield await api.getBookById(initial.id);
        } catch (e) {
          errorController.add(e);
        } finally {
          completer.complete();
        }
      }).startWith(initial),
      sharedPref.favoritedIds$,
      (Book book, BuiltSet<String> ids) {
        return BookDetailState((b) {
          final authors = book.authors;
          return b
            ..id = book.id
            ..title = book.title
            ..subtitle = book.subtitle
            ..authors = authors == null ? null : ListBuilder<String>(authors)
            ..largeImage = book.largeImage
            ..isFavorited = ids.contains(book.id)
            ..thumbnail = book.thumbnail
            ..description = book.description
            ..publishedDate = book.publishedDate;
        });
      },
    );

    final bookDetail$ = publishValueSeededDistinct(
      state$,
      seedValue: BookDetailState((b) {
        final authors = initial.authors;
        return b
          ..id = initial.id
          ..title = initial.title
          ..subtitle = initial.subtitle
          ..authors = authors == null ? null : ListBuilder<String>(authors)
          ..largeImage = initial.largeImage
          ..thumbnail = initial.thumbnail
          ..description = initial.description
          ..publishedDate = initial.publishedDate;
      }),
    );

    final subscriptions = <StreamSubscription>[
      toggleController
          .throttle(Duration(milliseconds: 600))
          .listen((_) => sharedPref.toggleFavorite(initial.id)),
      bookDetail$.listen((book) => print('[DETAIL] book=$book')),
      bookDetail$.connect(),
    ];
    final controllers = <StreamController>[
      refreshController,
      errorController,
    ];

    print('[DETAIL] new id=${initial.id}');

    return DetailBloc._(
      bookDetail$,
      errorController,
      () {
        final completer = Completer<void>();
        refreshController.add(completer);
        return completer.future;
      },
      () => toggleController.add(null),
      () async {
        await Future.wait(subscriptions.map((s) => s.cancel()));
        await Future.wait(controllers.map((c) => c.close()));
        print('[DETAIL] dispose id=${initial.id}');
      },
    );
  }

  @override
  void dispose() => _dispose();
}
