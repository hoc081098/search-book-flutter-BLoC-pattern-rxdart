import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'book_api.dart';
import 'book_model.dart';

class BookBloc {
  final BookApi api;
  final PublishSubject<String> _queryStreamController = new PublishSubject();
  Observable<List<Book>> _booksListStreamController;
  Stream<String> _searchTextStreamController;

  Sink<String> get query => _queryStreamController.sink;

  Stream<List<Book>> get books => _booksListStreamController;

  Stream<String> get searchText => _searchTextStreamController;

  BookBloc(this.api) {
    _booksListStreamController = _queryStreamController.stream
        .debounce(Duration(microseconds: 400))
        .distinct()
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .switchMap(_seachBook);
    _searchTextStreamController = _booksListStreamController.withLatestFrom(
      _queryStreamController,
      (list, queryStr) => "Search for $queryStr, has ${list.length} books",
    );
  }

  dispose() {
    _queryStreamController.close();
  }

  Stream<List<Book>> _seachBook(String value) {
    // Stream<List<Book>> stream = await api.searchBook(value);
    // await for (var list in stream) {
    //   yield list;
    // }
    return Stream.fromFuture(api.searchBook(value));
  }
}
