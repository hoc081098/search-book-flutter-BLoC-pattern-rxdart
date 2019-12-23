import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:disposebag/disposebag.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search_book/domain/book.dart';
import 'package:search_book/domain/book_repo.dart';
import 'package:search_book/pages/home_page/home_state.dart';
import 'package:search_book/data/local/shared_pref.dart';
import 'package:tuple/tuple.dart';

// ignore_for_file: close_sinks

/// Home Bloc
class HomeBloc implements BaseBloc {
  /// Input [Function]s
  final void Function(String) changeQuery;
  final void Function() loadNextPage;
  final void Function() retryNextPage;
  final void Function() retryFirstPage;
  final void Function(String) toggleFavorited;

  /// Ouput [Stream]s
  final ValueStream<HomePageState> state$;
  final ValueStream<int> favoriteCount$;

  /// Subscribe to this stream to show message like snackbar, toast, ...
  final Stream<HomePageMessage> message$;

  /// Clean up resouce
  final void Function() _dispose;

  HomeBloc._(
    this.changeQuery,
    this.loadNextPage,
    this.state$,
    this._dispose,
    this.retryNextPage,
    this.retryFirstPage,
    this.toggleFavorited,
    this.message$,
    this.favoriteCount$,
  );

  @override
  void dispose() => _dispose();

  factory HomeBloc(
    final BookRepo bookRepo,
    final SharedPref sharedPref,
  ) {
    assert(bookRepo != null);
    assert(sharedPref != null);

    /// Stream controllers, receive input intents
    final queryController = PublishSubject<String>();
    final loadNextPageController = PublishSubject<void>();
    final retryNextPageController = PublishSubject<void>();
    final retryFirstPageController = PublishSubject<void>();
    final toggleFavoritedController = PublishSubject<String>();
    final controllers = [
      queryController,
      loadNextPageController,
      retryNextPageController,
      retryFirstPageController,
      toggleFavoritedController,
    ];

    /// Debounce query stream
    final searchString$ = queryController
        .debounceTime(const Duration(milliseconds: 500))
        .distinct()
        .map((s) => s.trim());

    /// Search intent
    final searchIntent$ = searchString$.mergeWith([
      retryFirstPageController.withLatestFrom(
        searchString$,
        (_, String query) => query,
      )
    ]).map((s) => HomeIntent.searchIntent(search: s));

    /// Forward declare to [loadNextPageIntent] can access latest state via [DistinctValueConnectableStream.value] getter
    DistinctValueConnectableStream<HomePageState> state$;

    /// Load next page intent
    final loadAndRetryNextPageIntent$ = Rx.merge(
      [
        loadNextPageController.map((_) => state$.value).where((currentState) {
          /// Can load next page?
          return currentState.books.isNotEmpty &&
              currentState.loadFirstPageError == null &&
              currentState.loadNextPageError == null;
        }),
        retryNextPageController.map((_) => state$.value).where((currentState) {
          /// Can retry?
          return currentState.loadFirstPageError != null ||
              currentState.loadNextPageError != null;
        })
      ],
    )
        .withLatestFrom(
          searchString$,
          (currentState, String query) =>
              Tuple2(currentState.books.length, query),
        )
        .map(
          (tuple2) => HomeIntent.loadNextPageIntent(
            search: tuple2.item2,
            startIndex: tuple2.item1,
          ),
        );

    /// State stream
    state$ = Rx.combineLatest2(
      Rx.merge([searchIntent$, loadAndRetryNextPageIntent$]) // All intent
          .doOnData((intent) => print('[INTENT] $intent'))
          .switchMap((intent) => _processIntent$(intent, bookRepo))
          .doOnData((change) => print('[CHANGE] $change'))
          .scan(
            (state, action, _) => action.reduce(state),
            HomePageState.initial(),
          ),
      sharedPref.favoritedIds$,
      (HomePageState state, BuiltSet<String> ids) => state.rebuild(
        (b) => b.books.map(
          (book) => book.rebuild((b) => b.isFavorited = ids.contains(b.id)),
        ),
      ),
    ).publishValueSeededDistinct(seedValue: HomePageState.initial());

    final message$ =
        _getMessage$(toggleFavoritedController, sharedPref, state$);

    final favoriteCount$ = sharedPref.favoritedIds$
        .map((ids) => ids.length)
        .publishValueSeededDistinct(seedValue: 0);

    return HomeBloc._(
      queryController.add,
      () => loadNextPageController.add(null),
      state$,
      DisposeBag([
        ...controllers,
        message$.listen((message) => print('[MESSAGE] $message')),
        favoriteCount$.listen((count) => print('[FAV_COUNT] $count')),
        state$.listen((state) => print('[STATE] $state')),
        state$.connect(),
        message$.connect(),
        favoriteCount$.connect(),
      ]).dispose,
      () => retryNextPageController.add(null),
      () => retryFirstPageController.add(null),
      toggleFavoritedController.add,
      message$,
      favoriteCount$,
    );
  }
}

ConnectableStream<HomePageMessage> _getMessage$(
  PublishSubject<String> toggleFavoritedController,
  SharedPref sharedPref,
  DistinctValueConnectableStream<HomePageState> state$,
) {
  return toggleFavoritedController
      .groupBy((id) => id)
      .map((group$) => group$.throttleTime(Duration(milliseconds: 600)))
      .flatMap((group$) => group$)
      .asyncExpand((id) => Stream.fromFuture(sharedPref.toggleFavorite(id)))
      .withLatestFrom(
        state$,
        (result, HomePageState item) => HomePageMessage.fromResult(
          result,
          item.books.firstWhere(
            (book) => book.id == result.id,
            orElse: () => null,
          ),
        ),
      )
      .publish();
}

/// Process [intent], convert [intent] to [Stream] of [PartialStateChange]s
Stream<PartialStateChange> _processIntent$(
  HomeIntent intent,
  BookRepo bookRepo,
) {
  perform<RESULT, PARTIAL_CHANGE>(
    Stream<RESULT> streamFactory(),
    PARTIAL_CHANGE map(RESULT a),
    PARTIAL_CHANGE loading,
    PARTIAL_CHANGE onError(dynamic e),
  ) {
    return Rx.defer(streamFactory)
        .map(map)
        .startWith(loading)
        .doOnError((e, s) => print(s))
        .onErrorReturnWith(onError);
  }

  searchIntentToPartialChange$(SearchIntent intent) =>
      perform<BuiltList<Book>, PartialStateChange>(
        () {
          if (intent.search.isEmpty) {
            return Stream.value(BuiltList<Book>.of([]));
          }
          return Stream.fromFuture(bookRepo.searchBook(query: intent.search));
        },
        (list) {
          final bookItems =
              list.map((book) => BookItem.fromDomain(book)).toList();
          return PartialStateChange.firstPageLoaded(
            books: bookItems,
            textQuery: intent.search,
          );
        },
        PartialStateChange.firstPageLoading(),
        (e) {
          return PartialStateChange.firstPageError(
            error: e,
            textQuery: intent.search,
          );
        },
      );

  loadNextPageIntentToPartialChange$(LoadNextPageIntent intent) =>
      perform<BuiltList<Book>, PartialStateChange>(
        () {
          return Stream.fromFuture(
            bookRepo.searchBook(
              query: intent.search,
              startIndex: intent.startIndex,
            ),
          );
        },
        (list) {
          final bookItems =
              list.map((book) => BookItem.fromDomain(book)).toList();
          return PartialStateChange.nextPageLoaded(
            books: bookItems,
            textQuery: intent.search,
          );
        },
        PartialStateChange.nextPageLoading(),
        (e) {
          return PartialStateChange.nextPageError(
            error: e,
            textQuery: intent.search,
          );
        },
      );

  return intent.join(
    searchIntentToPartialChange$,
    loadNextPageIntentToPartialChange$,
  );
}
