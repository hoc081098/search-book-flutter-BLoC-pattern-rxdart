import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:search_book/domain/book.dart';

part 'detail_state.g.dart';

abstract class BookDetailState
    implements Built<BookDetailState, BookDetailStateBuilder> {
  String get id;

  @nullable
  String get title;

  @nullable
  String get subtitle;

  @nullable
  BuiltList<String> get authors;

  @nullable
  String get largeImage;

  @nullable
  String get thumbnail;

  @nullable
  bool get isFavorited;

  @nullable
  String get description;

  @nullable
  String get publishedDate;

  BookDetailState._();

  factory BookDetailState([updates(BookDetailStateBuilder b)]) =
      _$BookDetailState;

  factory BookDetailState.fromDomain(Book book, [bool isFavorited]) {
    final authors = book.authors;
    return BookDetailState(
      (b) => b
        ..id = book.id
        ..title = book.title
        ..subtitle = book.subtitle
        ..authors = authors == null ? null : ListBuilder<String>(authors)
        ..largeImage = book.largeImage
        ..thumbnail = book.thumbnail
        ..description = book.description
        ..publishedDate = book.publishedDate
        ..isFavorited = isFavorited,
    );
  }
}
