import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:search_book/domain/book.dart';
import 'package:search_book/domain/cache_policy.dart';

abstract class BookRepo {
  Future<BuiltList<Book>> searchBook({
    @required String query,
    int startIndex: 0,
  });

  Stream<Book> getBookBy({
    @required String id,
    CachePolicy cachePolicy: CachePolicy.networkOnly,
  });
}
