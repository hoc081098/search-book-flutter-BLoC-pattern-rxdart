import 'package:built_collection/built_collection.dart';
import 'package:search_book/data/api/book_api.dart';
import 'package:search_book/data/api/book_response.dart';
import 'package:search_book/data/mappers.dart';
import 'package:search_book/domain/book.dart';
import 'package:search_book/domain/book_repo.dart';
import 'package:search_book/domain/cache_policy.dart';
import 'package:tuple/tuple.dart';

class BookRepoImpl implements BookRepo {
  static const _timeoutInMilliseconds = 120000; // 2 minutes
  final Map<String, Tuple2<int, BookResponse>> _cached = {};

  ///
  final BookApi _api;
  final Mappers _mappers;

  BookRepoImpl(this._api, this._mappers);

  Stream<BookResponse> _getBookByIdWithCached$(
    String id,
    CachePolicy cachePolicy,
  ) async* {
    ///
    ///
    ///
    final cachedBook = _cached[id];

    if (cachedBook?.item2 != null) {
      yield cachedBook.item2;
    }

    ///
    ///
    ///

    if (cachePolicy == CachePolicy.networkOnly) {
      final book = await _api.getBookById(id);
      _cached[book.id] = Tuple2(
        DateTime.now().millisecondsSinceEpoch,
        book,
      );
      yield book;
      return;
    }

    ///
    ///
    ///
    if (cachePolicy == CachePolicy.localFirst) {
      final shouldFetch = (cachedBook?.item2 == null || // not in cached
          DateTime.now().millisecondsSinceEpoch - cachedBook.item1 >=
              _timeoutInMilliseconds); // in cached but timeout

      if (shouldFetch) {
        final book = await _api.getBookById(id);
        _cached[book.id] = Tuple2(DateTime.now().millisecondsSinceEpoch, book);
        yield book;
      }
      return;
    }

    ///
    ///
    ///
  }

  @override
  Stream<Book> getBookBy({
    String id,
    CachePolicy cachePolicy = CachePolicy.networkOnly,
  }) {
    assert(id != null);
    return _getBookByIdWithCached$(id, cachePolicy)
        .map(_mappers.bookResponseToDomain);
  }

  @override
  Future<BuiltList<Book>> searchBook({
    String query,
    int startIndex = 0,
  }) async {
    assert(query != null);
    final booksResponse = await _api.searchBook(
      query: query,
      startIndex: startIndex,
    );
    final book = booksResponse.map(_mappers.bookResponseToDomain);
    return BuiltList<Book>.of(book);
  }
}
