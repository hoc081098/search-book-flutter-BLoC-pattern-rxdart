import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:meta/meta.dart';
import 'package:sealed_unions/sealed_unions.dart';
import 'package:search_book/data/api/book_response.dart';
import 'package:search_book/domain/book.dart';
import 'package:search_book/data/local/shared_pref.dart';

part 'home_state.g.dart';

///
/// Represent from book item in list
///
abstract class BookItem implements Built<BookItem, BookItemBuilder> {
  String get id;

  @nullable
  String get title;

  @nullable
  String get subtitle;

  @nullable
  String get thumbnail;

  @nullable
  bool get isFavorited;

  BookItem._();

  factory BookItem([updates(BookItemBuilder b)]) = _$BookItem;

  ///
  /// Create [BookItem] from [BookResponse]
  ///
  factory BookItem.fromDomain(Book book) {
    return BookItem(
      (b) => b
        ..id = book.id
        ..title = book.title
        ..subtitle = book.subtitle
        ..thumbnail = book.thumbnail,
    );
  }

  Book toDomain() {
    return Book(
      (b) => b
        ..id = id
        ..title = title
        ..subtitle = subtitle
        ..thumbnail = thumbnail,
    );
  }
}

String _toString(o) => o.toString();

///
/// Home page state
///
abstract class HomePageState
    implements Built<HomePageState, HomePageStateBuilder> {
  String get resultText;

  BuiltList<BookItem> get books;

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
      ..books = ListBuilder<BookItem>()
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
    @required List<BookItem> books,
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
    @required List<BookItem> books,
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

  /// Pure function, produce new state from previous state [state] and partial state change [partialChange]
  HomePageState reduce(HomePageState state) {
    return join<HomePageState>(
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

  @override
  String toString() => join<String>(
      _toString, _toString, _toString, _toString, _toString, _toString);
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
  String toString() => 'LoadFirstPageError(error=$error,textQuery=$textQuery)';
}

class FirstPageLoaded {
  final List<BookItem> books;
  final String textQuery;

  const FirstPageLoaded({@required this.books, @required this.textQuery});

  @override
  String toString() =>
      'FirstPageLoaded(books.length=${books.length},textQuery=$textQuery)';
}

class LoadingNextPage {
  const LoadingNextPage();

  @override
  String toString() => 'LoadingNextPage';
}

class NextPageLoaded {
  final List<BookItem> books;
  final String textQuery;

  const NextPageLoaded({@required this.books, @required this.textQuery});

  @override
  String toString() =>
      'NextPageLoaded(books.length=${books.length},textQuery=$textQuery)';
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

  @override
  String toString() => join<String>(_toString, _toString);
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
      'LoadNextPageIntent(search=$search,startIndex=$startIndex)';
}

@immutable
abstract class HomePageMessage {
  factory HomePageMessage.fromResult(ToggleFavResult result, BookItem book) {
    if (result.added) {
      if (result.result) {
        return AddToFavoriteSuccess(book);
      } else {
        return AddToFavoriteFailure(book, result.error);
      }
    } else {
      if (result.result) {
        return RemoveFromFavoriteSuccess(book);
      } else {
        return RemoveFromFavoriteFailure(book, result.error);
      }
    }
  }
}

class AddToFavoriteSuccess implements HomePageMessage {
  final BookItem item;

  const AddToFavoriteSuccess(this.item);

  @override
  String toString() => 'AddToFavoriteSuccess{item=$item}';
}

class AddToFavoriteFailure implements HomePageMessage {
  final BookItem item;
  final error;

  const AddToFavoriteFailure(this.item, this.error);

  @override
  String toString() => 'AddToFavoriteFailure{item=$item, error=$error}';
}

class RemoveFromFavoriteSuccess implements HomePageMessage {
  final BookItem item;

  const RemoveFromFavoriteSuccess(this.item);

  @override
  String toString() => 'RemoveFromFavoriteSuccess{item=$item}';
}

class RemoveFromFavoriteFailure implements HomePageMessage {
  final BookItem item;
  final error;

  const RemoveFromFavoriteFailure(this.item, this.error);

  @override
  String toString() => 'RemoveFromFavoriteFailure{item=$item, error=$error}';
}
