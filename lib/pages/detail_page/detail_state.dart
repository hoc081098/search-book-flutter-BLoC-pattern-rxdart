import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'detail_state.g.dart';

abstract class BookDetailState
    implements Built<BookDetailState, BookDetailStateBuilder> {
  @nullable
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
}
