import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:disposebag/disposebag.dart';
import 'package:search_book/domain/book.dart';
import 'package:search_book/domain/book_repo.dart';
import 'package:search_book/pages/home_page/home_state.dart';
import 'package:search_book/shared_pref.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import 'package:distinct_value_connectable_observable/distinct_value_connectable_observable.dart';

// ignore_for_file: close_sinks

///
/// Home Bloc
///
class HomeBloc implements BaseBloc {
  ///
  /// Input [Function]s
  ///
  final void Function(String) changeQuery;
  final void Function() loadNextPage;
  final void Function() retryNextPage;
  final void Function() retryFirstPage;
  final void Function(String) toggleFavorited;

  ///
  /// Ouput [Stream]s
  ///
  final ValueObservable<HomePageState> state$;
  final ValueObservable<int> favoriteCount$;

  ///
  /// Subscribe to this stream to show message like snackbar, toast, ...
  ///
  final Stream<HomePageMessage> message$;

  ///
  /// Clean up resouce
  ///
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

    ///
    /// Stream controllers, receive input intents
    ///
    final queryController = PublishSubject<String>();
    final loadNextPageController = PublishSubject<void>();
    final retryNextPageController = PublishSubject<void>();
    final retryFirstPageController = PublishSubject<void>();
    final toggleFavoritedController = PublishSubject<String>();

    ///
    /// Debounce query stream
    ///
    final searchString$ = queryController
        .debounceTime(const Duration(milliseconds: 500))
        .distinct()
        .map((s) => s.trim());

    ///
    /// Search intent
    ///
    final searchIntent$ = searchString$.mergeWith([
      retryFirstPageController.withLatestFrom(
        searchString$,
        (_, String query) => query,
      )
    ]).map((s) => HomeIntent.searchIntent(search: s));

    ///
    /// Forward declare to [loadNextPageIntent] can access latest state via [DistinctValueConnectableObservable.value] getter
    ///
    DistinctValueConnectableObservable<HomePageState> stateDistinctConnectable$;

    ///
    /// Load next page intent
    ///
    final loadAndRetryNextPageIntent$ = Observable.merge([
      loadNextPageController
          .map((_) => stateDistinctConnectable$.value)
          .where((currentState) {
        ///
        /// Can load next page?
        ///
        return currentState.books.isNotEmpty &&
            currentState.loadFirstPageError == null &&
            currentState.loadNextPageError == null;
      }),
      retryNextPageController
          .map((_) => stateDistinctConnectable$.value)
          .where((currentState) {
        ///
        /// Can retry?
        ///
        return currentState.loadFirstPageError != null ||
            currentState.loadNextPageError != null;
      })
    ])
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

    ///
    /// State stream
    ///
    final state$ = Observable.combineLatest2(
      Observable.merge(
              [searchIntent$, loadAndRetryNextPageIntent$]) // All intent
          .doOnData((intent) => print('[INTENT] $intent'))
          .switchMap((intent) => _processIntent$(intent, bookRepo))
          .doOnData((change) => print('[CHANGE] $change'))
          .scan(_reduce, HomePageState.initial()),
      sharedPref.favoritedIds$,
      (HomePageState state, BuiltSet<String> ids) => state.rebuild(
        (b) => b.books.map(
          (book) => book.rebuild((b) => b.isFavorited = ids.contains(b.id)),
        ),
      ),
    );

    ///
    /// Final state stream
    ///
    stateDistinctConnectable$ =
        publishValueSeededDistinct(state$, seedValue: HomePageState.initial());

    final message$ = toggleFavoritedController
        .groupBy((id) => id)
        .map((group$) => group$.throttleTime(Duration(milliseconds: 600)))
        .flatMap((group$) => group$)
        .concatMap((id) => Stream.fromFuture(sharedPref.toggleFavorite(id)))
        .withLatestFrom(
          stateDistinctConnectable$,
          (result, HomePageState item) => HomePageMessage.fromResult(
            result,
            item.books.firstWhere(
              (book) => book.id == result.id,
              orElse: () => null,
            ),
          ),
        )
        .publish();

    final favoriteCount$ = publishValueSeededDistinct(
      sharedPref.favoritedIds$.map((ids) => ids.length),
      seedValue: 0,
    );

    ///
    ///
    ///
    final bag = DisposeBag(
      [
        queryController,
        loadNextPageController,
        retryNextPageController,
        retryFirstPageController,
        toggleFavoritedController,
        //
        message$.listen((message) => print('[MESSAGE] $message')),
        favoriteCount$.listen((count) => print('[FAV_COUNT] $count')),
        stateDistinctConnectable$.listen((state) => print('[STATE] $state')),
        //
        stateDistinctConnectable$.connect(),
        message$.connect(),
        favoriteCount$.connect(),
      ],
    );

    return HomeBloc._(
      queryController.add,
      () => loadNextPageController.add(null),
      stateDistinctConnectable$,
      bag.dispose,
      () => retryNextPageController.add(null),
      () => retryFirstPageController.add(null),
      toggleFavoritedController.add,
      message$,
      favoriteCount$,
    );
  }

  ///
  /// Process [intent], convert [intent] to [Stream] of [PartialStateChange]s
  ///
  static Stream<PartialStateChange> _processIntent$(
    HomeIntent intent,
    BookRepo bookRepo,
  ) {
    perform<RESULT, PARTIAL_CHANGE>(
      Stream<RESULT> streamFactory(),
      PARTIAL_CHANGE map(RESULT a),
      PARTIAL_CHANGE loading,
      PARTIAL_CHANGE onError(dynamic e),
    ) {
      return Observable.defer(streamFactory)
          .map(map)
          .startWith(loading)
          .doOnError((e, s) => print(s))
          .onErrorReturnWith(onError);
    }

    searchIntentToPartialChange$(SearchIntent intent) =>
        perform<BuiltList<Book>, PartialStateChange>(
          () {
            if (intent.search.isEmpty) {
              return Observable.just(BuiltList<Book>.of([]));
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

  ///
  /// Pure function, produce new state from previous state [state] and partial state change [partialChange]
  ///
  static HomePageState _reduce(
    HomePageState state,
    PartialStateChange partialChange,
    int _,
  ) {
    return partialChange.join<HomePageState>(
      (LoadingFirstPage change) {
        return state.rebuild((b) => b..isFirstPageLoading = true);
      },
      (LoadFirstPageError change) {
        return state.rebuild((b) => b
          ..resultText = "Search for '${change.textQuery}', error occurred"
          ..isFirstPageLoading = false
          ..loadFirstPageError = change.error
          ..isNextPageLoading = false
          ..loadNextPageError = null
          ..books = ListBuilder<BookItem>());
      },
      (FirstPageLoaded change) {
        return state.rebuild((b) => b
          ..resultText =
              "Search for '${change.textQuery}', have ${change.books.length} books"
          ..books = ListBuilder<BookItem>(change.books)
          ..isFirstPageLoading = false
          ..isNextPageLoading = false
          ..loadFirstPageError = null
          ..loadNextPageError = null);
      },
      (LoadingNextPage change) {
        return state.rebuild((b) => b..isNextPageLoading = true);
      },
      (NextPageLoaded change) {
        return state.rebuild((b) {
          var newListBuilder = b.books..addAll(change.books);
          return b
            ..books = newListBuilder
            ..resultText =
                "Search for '${change.textQuery}', have ${newListBuilder.length} books"
            ..isNextPageLoading = false
            ..loadNextPageError = null;
        });
      },
      (LoadNextPageError change) {
        return state.rebuild((b) => b
          ..resultText =
              "Search for '${change.textQuery}', have ${state.books.length} books"
          ..isNextPageLoading = false
          ..loadNextPageError = change.error);
      },
    );
  }
}
