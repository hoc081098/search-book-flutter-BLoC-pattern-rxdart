import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';

part 'book.g.dart';

abstract class Book implements Built<Book, BookBuilder> {
  String get id;

  @nullable
  String get title;

  @nullable
  String get subtitle;

  @nullable
  BuiltList<String> get authors;

  @nullable
  String get thumbnail;

  @nullable
  String get largeImage;

  @nullable
  String get description;

  @nullable
  String get publishedDate;

  Book._();

  factory Book([updates(BookBuilder b)]) = _$Book;
}
