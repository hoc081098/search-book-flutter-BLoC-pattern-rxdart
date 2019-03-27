import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:demo_bloc_pattern/api/book_api.dart';
import 'package:demo_bloc_pattern/pages/home_page/home_state.dart';
import 'package:demo_bloc_pattern/shared_pref.dart';
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
  final void Function() retry;

  ///
  /// Ouput [Stream]s
  ///
  final ValueObservable<HomePageState> state$;

  ///
  /// Clean up resouce
  ///
  final void Function() _dispose;

  HomeBloc._(
    this.changeQuery,
    this.loadNextPage,
    this.state$,
    this._dispose,
    this.retry,
  );

  @override
  void dispose() => _dispose();

  factory HomeBloc(final BookApi bookApi, final SharedPref sharedPref) {
    assert(bookApi != null);

    ///
    /// Stream controllers, receive input intents
    ///
    final queryController = PublishSubject<String>();
    final loadNextPageController = PublishSubject<void>();
    final retryController = PublishSubject<void>();

    ///
    /// Debounce query stream
    ///
    final searchString$ = queryController
        .debounce(Duration(milliseconds: 500))
        .distinct()
        .map((s) => s.trim());

    ///
    /// Search intent
    ///
    final searchIntent$ =
        searchString$.map((s) => HomeIntent.searchIntent(search: s));

    ///
    /// Forward declare to [loadNextPageIntent] access latest state
    ///
    DistinctValueConnectableObservable<HomePageState> state$;

    ///
    /// Load next page intent
    ///
    final loadNextPageAndRetryIntent$ = Observable.merge([
      loadNextPageController.map((_) => state$.value).where((currentState) {
        ///
        /// Can load next page?
        ///
        return currentState.books.isNotEmpty &&
            currentState.loadFirstPageError == null &&
            currentState.loadNextPageError == null;
      }),
      retryController.map((_) => state$.value).where((currentState) {
        ///
        /// Can retry
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

    state$ = DistinctValueConnectableObservable.seeded(
      Observable.combineLatest2(
        Observable.merge(
          [
            searchIntent$,
            loadNextPageAndRetryIntent$,
          ],
        ) // All intent
            .doOnData((intent) => print('[INTENT] $intent'))
            .switchMap((intent) => _processIntent$(intent, bookApi)),
        sharedPref.favoritedIds$,
        (PartialStateChange change, BuiltSet<String> ids) {
          notChange(_) => change;

          mapList(List<BookItem> books) {
            return books
                .map((book) =>
                    book.rebuild((b) => b.isFavorited = ids.contains(b.id)))
                .toList();
          }

          return change.join<PartialStateChange>(
            notChange,
            notChange,
            (FirstPageLoaded change) {
              return PartialStateChange.firstPageLoaded(
                books: mapList(change.books),
                textQuery: change.textQuery,
              );
            },
            notChange,
            (NextPageLoaded change) {
              return PartialStateChange.nextPageLoaded(
                books: mapList(change.books),
                textQuery: change.textQuery,
              );
            },
            notChange,
          );
        },
      )
          .doOnData((change) => print('[CHANGE] $change'))
          .scan(_reduce, HomePageState.initial()),
      seedValue: HomePageState.initial(),
    );

    ///
    ///
    ///
    final controllers = <StreamController>[
      queryController,
      loadNextPageController,
    ];
    final subscriptions = <StreamSubscription>[
      state$.listen((state) => print('[STATE] $state')),
      state$.connect(),
    ];

    return HomeBloc._(
      queryController.add,
      () => loadNextPageController.add(null),
      state$,
      () async {
        await Future.wait(subscriptions.map((s) => s.cancel()));
        await Future.wait(controllers.map((c) => c.close()));
      },
      () => retryController.add(null),
    );
  }

  ///
  /// Process [intent], convert [intent] to [Stream] of [PartialStateChange]s
  ///
  static Stream<PartialStateChange> _processIntent$(
    HomeIntent intent,
    BookApi bookApi,
  ) {
    Stream<PartialStateChange> searchIntentToPartialChange$(
        SearchIntent intent) {
      return Observable.fromFuture(bookApi.searchBook(query: intent.search))
          .map<PartialStateChange>((list) {
            final bookItems =
                list.map((book) => BookItem.fromBookModel(book)).toList();
            return PartialStateChange.firstPageLoaded(
              books: bookItems,
              textQuery: intent.search,
            );
          })
          .startWith(PartialStateChange.firstPageLoading())
          .onErrorReturnWith((e) {
            return PartialStateChange.firstPageError(
              error: e,
              textQuery: intent.search,
            );
          });
    }

    Stream<PartialStateChange> loadNextPageIntentToPartialChange$(
        LoadNextPageIntent intent) {
      return Observable.fromFuture(bookApi.searchBook(
              query: intent.search, startIndex: intent.startIndex))
          .map<PartialStateChange>((list) {
            final bookItems =
                list.map((book) => BookItem.fromBookModel(book)).toList();
            return PartialStateChange.nextPageLoaded(
              books: bookItems,
              textQuery: intent.search,
            );
          })
          .startWith(PartialStateChange.nextPageLoading())
          .onErrorReturnWith((e) {
            return PartialStateChange.nextPageError(
              error: e,
              textQuery: intent.search,
            );
          });
    }

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
          ..loadNextPageError = null);
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
