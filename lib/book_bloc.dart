import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'book_api.dart';
import 'book_model.dart';

class BookBloc {
  final BookApi _api;
  final _queryController = PublishSubject<String>();
  final _loadingController = BehaviorSubject<bool>(seedValue: false);
  Observable<List<Book>> _booksListObservable;
  Stream<String> _resultTextStream;

  Sink<String> get query => _queryController;

  Stream<List<Book>> get books => _booksListObservable;

  Stream<String> get resultText => _resultTextStream;

  Stream<bool> get isLoading => _loadingController;

  BookBloc(this._api) : assert(_api != null) {
    _booksListObservable = _queryController
        .debounce(Duration(microseconds: 400))
        .distinct()
        .map((s) => s.trim())
        .switchMap(_searchBook)
        .asBroadcastStream();
    _resultTextStream = _booksListObservable
        .withLatestFrom<String, String>(
          _queryController,
          (bookList, queryString) =>
              'Search for $queryString, has ${bookList.length} books',
        )
        .asBroadcastStream();
  }

  Stream<List<Book>> _searchBook(String value) {
    if (value.isEmpty) return Stream.fromIterable([]);
    return Observable
        .fromFuture(_api.searchBook(value))
        .doOnListen(() => _loadingController.add(true))
        .doOnError(() => _loadingController.add(false))
        .doOnDone(() => _loadingController.add(false));
  }

  dispose() {
    _queryController.close();
    _loadingController.close();
  }
}
