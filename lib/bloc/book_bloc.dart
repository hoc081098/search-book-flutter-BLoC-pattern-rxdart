import 'dart:async';

import 'package:demo_bloc_pattern/api/book_api.dart';
import 'package:demo_bloc_pattern/model/book_model.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

///
/// Home Page State
///

@immutable
class HomePageState {
  final String resultText;
  final bool isLoading;
  final List<Book> books;
  final Object error;

  HomePageState._({
    @required this.resultText,
    @required this.isLoading,
    @required this.books,
    @required this.error,
  });

  factory HomePageState.intial() => HomePageState._(
        books: <Book>[],
        isLoading: false,
        resultText: '',
        error: null,
      );

  copyWith(
      {bool isLoading, String resultText, List<Book> books, Object error}) {
    return HomePageState._(
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
      resultText: resultText ?? this.resultText,
      error: error,
    );
  }
}

///
/// Home Page Partial Change
///

@immutable
abstract class PartialStateChange {}

class Loading extends PartialStateChange {}

class BookListItems extends PartialStateChange {
  final List<Book> books;
  final String textQuery;

  BookListItems({@required this.books, @required this.textQuery});
}

class Error extends PartialStateChange {
  final Object error;
  final String textQuery;

  Error({@required this.error, @required this.textQuery});
}

///
/// Book Bloc
///

class BookBloc {
  final BookApi _bookApi;

  Stream<HomePageState> get homePageState => _homePageStateController.stream;
  final _homePageStateController =
      BehaviorSubject<HomePageState>(seedValue: HomePageState.intial());

  Sink<String> get query => _queryController.sink;
  final _queryController = PublishSubject<String>(sync: true);

  BookBloc(this._bookApi) : assert(_bookApi != null) {
    _queryController
        .debounce(Duration(milliseconds: 400))
        .distinct()
        .map((s) => s.trim())
        .switchMap(_searchBook)
        .scan(_reduce, HomePageState.intial())
        .distinct()
        .pipe(_homePageStateController);
  }

  Stream<PartialStateChange> _searchBook(String value) async* {
    yield Loading();
    try {
      final list = await _bookApi.searchBook(value);
      yield BookListItems(
        books: list,
        textQuery: value,
      );
    } catch (e) {
      yield Error(
        error: e,
        textQuery: value,
      );
    }
  }

  dispose() {
    _homePageStateController.close();
  }

  HomePageState _reduce(
      HomePageState accumulated, PartialStateChange partialChange, _) {
    if (partialChange is Error) {
      return accumulated.copyWith(
        isLoading: false,
        error: partialChange.error,
        resultText: "Search for '${partialChange.textQuery}', error occurred",
      );
    }
    if (partialChange is BookListItems) {
      return accumulated.copyWith(
        isLoading: false,
        books: partialChange.books,
        resultText: "Search for '${partialChange.textQuery}', have ${partialChange.books.length} books",
        error: null,
      );
    }
    if (partialChange is Loading) {
      return accumulated.copyWith(isLoading: true);
    }
    return null;
  }
}
