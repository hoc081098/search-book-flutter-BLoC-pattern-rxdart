import 'package:demo_bloc_pattern/model/book_model.dart';
import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:sealed_unions/sealed_unions.dart';

part 'home_state.g.dart';

abstract class HomePageState
    implements Built<HomePageState, HomePageStateBuilder> {
  String get resultText;
  BuiltList<Book> get books;

  bool get isFirstPageLoading;
  @nullable
  Object get loadFirstPageError;

  bool get isNextPageLoading;
  @nullable
  Object get loadNextPageError;

  HomePageState._();

  factory HomePageState([updates(HomePageStateBuilder b)]) = _$HomePageState;

  factory HomePageState.initial() {
    return HomePageState((b) => b
      ..resultText = ''
      ..books = ListBuilder<Book>()
      ..isFirstPageLoading = false
      ..loadFirstPageError = null
      ..isNextPageLoading = false
      ..loadNextPageError = null);
  }
}

///
/// Home Page Partial Change
///
class PartialStateChange extends Union6Impl<
    LoadingFirstPage,
    LoadFirstPageError,
    FirstPageLoaded,
    LoadingNextPage,
    NextPageLoaded,
    LoadNextPageError> {
  static const Sextet<LoadingFirstPage, LoadFirstPageError, FirstPageLoaded,
          LoadingNextPage, NextPageLoaded, LoadNextPageError> _factory =
      Sextet<LoadingFirstPage, LoadFirstPageError, FirstPageLoaded,
          LoadingNextPage, NextPageLoaded, LoadNextPageError>();

  PartialStateChange._(
      Union6<LoadingFirstPage, LoadFirstPageError, FirstPageLoaded,
              LoadingNextPage, NextPageLoaded, LoadNextPageError>
          union)
      : super(union);

  factory PartialStateChange.firstPageLoading() {
    return PartialStateChange._(_factory.first(const LoadingFirstPage()));
  }

  factory PartialStateChange.firstPageError({
    @required Object error,
    @required String textQuery,
  }) {
    return PartialStateChange._(
      _factory.second(
        LoadFirstPageError(
          error: error,
          textQuery: textQuery,
        ),
      ),
    );
  }

  factory PartialStateChange.firstPageLoaded({
    @required List<Book> books,
    @required String textQuery,
  }) {
    return PartialStateChange._(_factory.third(
      FirstPageLoaded(
        books: books,
        textQuery: textQuery,
      ),
    ));
  }

  factory PartialStateChange.nextPageLoading() {
    return PartialStateChange._(_factory.fourth(const LoadingNextPage()));
  }

  factory PartialStateChange.nextPageLoaded({
    @required List<Book> books,
    @required String textQuery,
  }) {
    return PartialStateChange._(
      _factory.fifth(
        NextPageLoaded(
          textQuery: textQuery,
          books: books,
        ),
      ),
    );
  }

  factory PartialStateChange.nextPageError({
    @required Object error,
    @required String textQuery,
  }) {
    return PartialStateChange._(
      _factory.sixth(
        LoadNextPageError(
          textQuery: textQuery,
          error: error,
        ),
      ),
    );
  }
}

class LoadingFirstPage {
  const LoadingFirstPage();

  @override
  String toString() => 'LoadingFirstPage';
}

class LoadFirstPageError {
  final Object error;
  final String textQuery;

  const LoadFirstPageError({@required this.error, @required this.textQuery});

  @override
  String toString() => 'LoadFirstPageError(error=$error,textQuery=textQuery)';
}

class FirstPageLoaded {
  final List<Book> books;
  final String textQuery;

  const FirstPageLoaded({@required this.books, @required this.textQuery});

  @override
  String toString() => 'FirstPageLoaded(books=$books,textQuery=$textQuery)';
}

class LoadingNextPage {
  const LoadingNextPage();

  @override
  String toString() => 'LoadingNextPage';
}

class NextPageLoaded {
  final List<Book> books;
  final String textQuery;

  const NextPageLoaded({@required this.books, @required this.textQuery});

  @override
  String toString() => 'NextPageLoaded(books=$books,textQuery=$textQuery)';
}

class LoadNextPageError {
  final Object error;
  final String textQuery;

  const LoadNextPageError({@required this.error, @required this.textQuery});

  @override
  String toString() => 'LoadNextPageError(error=$error,textQuery=$textQuery)';
}

///
/// Home Intent (Action)
///
class HomeIntent extends Union2Impl<SearchIntent, LoadNextPageIntent> {
  static const Doublet<SearchIntent, LoadNextPageIntent> _factory =
      Doublet<SearchIntent, LoadNextPageIntent>();

  HomeIntent._(Union2<SearchIntent, LoadNextPageIntent> union) : super(union);

  factory HomeIntent.searchIntent({@required String search}) {
    return HomeIntent._(_factory.first(SearchIntent(search: search)));
  }

  factory HomeIntent.loadNextPageIntent({
    @required String search,
    @required int startIndex,
  }) {
    return HomeIntent._(
      _factory.second(
        LoadNextPageIntent(
          search: search,
          startIndex: startIndex,
        ),
      ),
    );
  }
}

class SearchIntent {
  final String search;

  const SearchIntent({@required this.search});

  @override
  String toString() => 'SearchIntent(search=$search)';
}

class LoadNextPageIntent {
  final String search;
  final int startIndex;

  const LoadNextPageIntent({@required this.search, @required this.startIndex});

  @override
  String toString() =>
      'LoadNextPageIntent(search=$search,startIndex=startIndex)';
}
