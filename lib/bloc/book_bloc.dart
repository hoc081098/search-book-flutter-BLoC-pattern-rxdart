import 'dart:async';
import 'dart:collection';

import 'package:demo_bloc_pattern/api/book_api.dart';
import 'package:demo_bloc_pattern/model/book_model.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart' show ListEquality;

///
/// Home Page State
///

@immutable
class HomePageState {
  final String resultText;
  final UnmodifiableListView<Book> books;

  final bool isFirstPageLoading;
  final Object loadFirstPageError;

  final bool isNextPageLoading;
  final Object loadNextPageError;

  const HomePageState._({
    @required this.resultText,
    @required this.books,
    @required this.isFirstPageLoading,
    @required this.loadFirstPageError,
    @required this.isNextPageLoading,
    @required this.loadNextPageError,
  });

  factory HomePageState.initial() => HomePageState._(
        resultText: '',
        books: UnmodifiableListView([]),
        isFirstPageLoading: false,
        loadFirstPageError: null,
        isNextPageLoading: false,
        loadNextPageError: null,
      );

  HomePageState copyWith({
    String resultText,
    List<Book> books,
    bool isFirstPageLoading,
    Object loadFirstPageError,
    bool isNextPageLoading,
    Object loadNextPageError,
  }) {
    return HomePageState._(
      resultText: resultText ?? this.resultText,
      books: books != null ? UnmodifiableListView(books) : this.books,
      isFirstPageLoading: isFirstPageLoading ?? this.isFirstPageLoading,
      loadFirstPageError: loadFirstPageError,
      isNextPageLoading: isNextPageLoading ?? this.isNextPageLoading,
      loadNextPageError: loadNextPageError,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HomePageState &&
            runtimeType == other.runtimeType &&
            resultText == other.resultText &&
            const ListEquality().equals(books, other.books) &&
            isFirstPageLoading == other.isFirstPageLoading &&
            loadFirstPageError == other.loadFirstPageError &&
            isNextPageLoading == other.isNextPageLoading &&
            loadNextPageError == other.loadNextPageError;
  }

  @override
  int get hashCode {
    return resultText.hashCode ^
        books.hashCode ^
        isFirstPageLoading.hashCode ^
        loadFirstPageError.hashCode ^
        isNextPageLoading.hashCode ^
        loadNextPageError.hashCode;
  }

  @override
  String toString() =>
      'HomePageState(resultText=$resultText,books=$books,isFirstPageLoading=$isFirstPageLoading,'
      'loadFirstPageError=$loadFirstPageError,isNextPageLoading=$isNextPageLoading,loadNextPageError=$loadNextPageError)';
}

///
/// Home Page Partial Change
///

@immutable
abstract class PartialStateChange {
  const PartialStateChange();
}

class LoadingFirstPage extends PartialStateChange {
  static LoadingFirstPage _instance;

  static LoadingFirstPage get instance =>
      _instance ?? (_instance = LoadingFirstPage._());

  const LoadingFirstPage._();

  @override
  String toString() => 'LoadingFirstPage';
}

class LoadingNextPage extends PartialStateChange {
  static LoadingNextPage _instance;

  static LoadingNextPage get instance =>
      _instance ?? (_instance = LoadingNextPage._());

  const LoadingNextPage._();

  @override
  String toString() => 'LoadingNextPage';
}

class FirstPageLoaded extends PartialStateChange {
  final List<Book> books;
  final String textQuery;

  const FirstPageLoaded({@required this.books, @required this.textQuery});

  @override
  String toString() => 'FirstPageLoaded(books=$books,textQuery=$textQuery)';
}

class NextPageLoaded extends PartialStateChange {
  final List<Book> books;
  final String textQuery;

  const NextPageLoaded({@required this.books, @required this.textQuery});

  @override
  String toString() => 'NextPageLoaded(books=$books,textQuery=$textQuery)';
}

class LoadFirstPageError extends PartialStateChange {
  final Object error;
  final String textQuery;

  const LoadFirstPageError({@required this.error, @required this.textQuery});

  @override
  String toString() => 'LoadFirstPageError(error=$error,textQuery=textQuery)';
}

class LoadNextPageError extends PartialStateChange {
  final Object error;
  final String textQuery;

  const LoadNextPageError({@required this.error, @required this.textQuery});

  @override
  String toString() => 'LoadNextPageError(error=$error,textQuery=$textQuery)';
}

///
/// Home Intent
///

@immutable
abstract class HomeIntent {
  const HomeIntent();
}

class SearchIntent extends HomeIntent {
  final String search;

  const SearchIntent({@required this.search});

  @override
  String toString() => 'SearchIntent(search=$search)';
}

class LoadNextPageIntent extends HomeIntent {
  final String search;
  final int startIndex;

  const LoadNextPageIntent({@required this.search, @required this.startIndex});

  @override
  String toString() =>
      'LoadNextPageIntent(search=$search,startIndex=startIndex)';
}

///
/// Book Bloc
///

class BookBloc {
  final BookApi _bookApi;
  final _queryController = PublishSubject<String>();
  final _loadNextPageController = PublishSubject<void>();
  ValueObservable<HomePageState> _homePageState$;

  Sink<String> get query => _queryController.sink;
  Sink<void> get loadNextPage => _loadNextPageController.sink;
  Stream<HomePageState> get homePageState => _homePageState$;

  BookBloc(this._bookApi) : assert(_bookApi != null) {
    final searchString = _queryController
        .debounce(Duration(milliseconds: 500))
        .distinct()
        .map((s) => s.trim());

    final searchIntent = searchString.map((s) => SearchIntent(search: s));

    final loadNextPageIntent = _loadNextPageController
        .where((_) {
          final state = _homePageState$.value;
          return state.books.isNotEmpty &&
              state.loadFirstPageError == null &&
              state.loadNextPageError == null;
        })
        .withLatestFrom(searchString, (_, String searchString) => searchString)
        .map((searchString) => LoadNextPageIntent(
              search: searchString,
              startIndex: _homePageState$.value.books.length,
            ));

    _homePageState$ =
        Observable.merge(<Stream<HomeIntent>>[searchIntent, loadNextPageIntent])
            .doOnData((intent) => print('##DEBUG intent = $intent'))
            .switchMap(_searchBook)
            .scan(_reduce, HomePageState.initial())
            .doOnData((state) => print('##DEBUG after scan state = $state'))
            .distinct()
            .doOnData((state) => print('##DEBUG final state = $state'))
            .shareValue(seedValue: HomePageState.initial());
  }

  Stream<PartialStateChange> _searchBook(HomeIntent intent) {
    if (intent is SearchIntent) {
      return Observable.fromFuture(_bookApi.searchBook(query: intent.search))
          .map<PartialStateChange>((list) => FirstPageLoaded(
                books: list,
                textQuery: intent.search,
              ))
          .startWith(LoadingFirstPage.instance)
          .onErrorReturnWith((e) => LoadFirstPageError(
                error: e,
                textQuery: intent.search,
              ));
    }
    if (intent is LoadNextPageIntent) {
      return Observable.fromFuture(_bookApi.searchBook(
              query: intent.search, startIndex: intent.startIndex))
          .map<PartialStateChange>((list) => NextPageLoaded(
                books: list,
                textQuery: intent.search,
              ))
          .startWith(LoadingNextPage.instance)
          .onErrorReturnWith((e) => LoadNextPageError(
                error: e,
                textQuery: intent.search,
              ));
    }
    return Observable.error(StateError('Uknown intent $intent'));
  }

  /*
  Stream<PartialStateChange> _searchBook(HomeIntent intent) async* {
    if (intent is SearchIntent) {
      yield LoadingFirstPage.instance;
      try {
        final list = await _bookApi.searchBook(query: intent.search);
        yield FirstPageLoaded(
          books: list,
          textQuery: intent.search,
        );
      } catch (e) {
        yield LoadFirstPageError(
          error: e,
          textQuery: intent.search,
        );
      }
      return;
    }

    if (intent is LoadNextPageIntent) {
      yield LoadingNextPage.instance;
      try {
        final list = await _bookApi.searchBook(
            query: intent.search, startIndex: intent.startIndex);

        debugPrint('##DEBUG LoadNextPageIntent list = $list');
        debugPrint('##DEBUG LoadNextPageIntent list.length = ${list.length}');

        yield NextPageLoaded(
          books: list,
          textQuery: intent.search,
        );
      } catch (e) {
        yield LoadNextPageError(
          error: e,
          textQuery: intent.search,
        );
      }
    }
  }
  */

  Future<void> dispose() {
    return Future.wait([
      _queryController.close(),
      _loadNextPageController.close(),
    ]);
  }

  HomePageState _reduce(
      HomePageState state, PartialStateChange partialChange, int index) {
    if (partialChange is LoadingFirstPage) {
      return state.copyWith(isFirstPageLoading: true);
    }

    if (partialChange is LoadFirstPageError) {
      return state.copyWith(
        resultText: "Search for '${partialChange.textQuery}', error occurred",
        isFirstPageLoading: false,
        loadFirstPageError: partialChange.error,
        isNextPageLoading: false,
        loadNextPageError: null,
      );
    }

    if (partialChange is FirstPageLoaded) {
      return state.copyWith(
        resultText:
            "Search for '${partialChange.textQuery}', have ${partialChange.books.length} books",
        books: partialChange.books,
        isFirstPageLoading: false,
        isNextPageLoading: false,
        loadFirstPageError: null,
        loadNextPageError: null,
      );
    }

    if (partialChange is LoadingNextPage) {
      return state.copyWith(isNextPageLoading: true);
    }

    if (partialChange is LoadNextPageError) {
      return state.copyWith(
        resultText:
            "Search for '${partialChange.textQuery}', have ${state.books.length} books",
        isNextPageLoading: false,
        loadNextPageError: partialChange.error,
      );
    }

    if (partialChange is NextPageLoaded) {
      final books = <Book>[]..addAll(state.books)..addAll(partialChange.books);
      return state.copyWith(
        books: books,
        resultText:
            "Search for '${partialChange.textQuery}', have ${books.length} books",
        isNextPageLoading: false,
        loadNextPageError: null,
      );
    }

    throw StateError('Unknown partial state change $partialChange');
  }
}
