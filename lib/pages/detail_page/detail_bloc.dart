import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:disposebag/disposebag.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search_book/domain/book.dart';
import 'package:search_book/domain/book_repo.dart';
import 'package:search_book/pages/detail_page/detail_state.dart';
import 'package:search_book/domain/favorited_books_repo.dart';

// ignore_for_file: close_sinks

class DetailBloc implements BaseBloc {
  /// Outputs
  final ValueStream<BookDetailState> bookDetail$;
  final Stream<Object> error$;

  /// Inputs
  final Future<void> Function() refresh;
  final void Function() toggleFavorited;

  /// Clean up resource
  final void Function() _dispose;

  DetailBloc._(
    this.bookDetail$,
    this.error$,
    this.refresh,
    this.toggleFavorited,
    this._dispose,
  );

  factory DetailBloc(
    final BookRepo bookRepo,
    final FavoritedBooksRepo favBooksRepo,
    final Book initial,
  ) {
    assert(bookRepo != null);
    assert(favBooksRepo != null);
    assert(initial != null);

    /// Controllers
    final refreshController = PublishSubject<Completer>();
    final errorController = PublishSubject<Object>();
    final toggleController = PublishSubject<void>();

    final book$ = refreshController.exhaustMap(
      (completer) async* {
        try {
          yield* bookRepo.getBookBy(id: initial.id);
        } catch (e) {
          errorController.add(e);
        } finally {
          completer.complete();
        }
      },
    ).startWith(initial);

    final state$ = Rx.combineLatest2(
      book$,
      favBooksRepo.favoritedIds$,
      (Book book, BuiltSet<String> ids) {
        return BookDetailState.fromDomain(
          book,
          ids.contains(book.id),
        );
      },
    ).publishValueSeededDistinct(
        seedValue: BookDetailState.fromDomain(initial));

    /// DisposeBag
    final bag = DisposeBag(
      [
        toggleController
            .throttleTime(const Duration(milliseconds: 600))
            .listen((_) => favBooksRepo.toggleFavorited(initial.id)),
        state$.listen((book) => print('[DETAIL] book=$book')),
        //
        state$.connect(),
        //
        refreshController,
        errorController,
        toggleController,
      ],
    );

    print('[DETAIL] new id=${initial.id}');

    return DetailBloc._(
      state$,
      errorController,
      () {
        final completer = Completer<void>();
        refreshController.add(completer);
        return completer.future;
      },
      () => toggleController.add(null),
      () =>
          bag.dispose().then((_) => print('[DETAIL] dispose id=${initial.id}')),
    );
  }

  @override
  void dispose() => _dispose();
}
