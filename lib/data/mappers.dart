import 'package:built_collection/built_collection.dart';
import 'package:search_book/data/api/book_response.dart';
import 'package:search_book/domain/book.dart';

typedef Mapper<T, R> = R Function(T t);

class Mappers {
  final Mapper<BookResponse, Book> bookResponseToDomain = (book) {
    return Book(
      (b) => b
        ..id = book.id
        ..title = book.title
        ..subtitle = book.subtitle
        ..authors =
            book.authors == null ? null : ListBuilder<String>(book.authors)
        ..thumbnail = book.thumbnail
        ..largeImage = book.largeImage
        ..description = book.description
        ..publishedDate = book.publishedDate,
    );
  };
}
