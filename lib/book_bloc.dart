import 'dart:async';

import 'book_api.dart';
import 'book_model.dart';
import 'package:rxdart/rxdart.dart';

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
        .switchMap(_seachBook);
    _searchTextStreamController = _booksListStreamController.withLatestFrom(
      _queryStreamController,
      (list, queryStr) => "Search for $queryStr, has ${list.length}",
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
    return Observable.switchLatest(Stream.fromFuture(api.searchBook(value)));
  }
}
