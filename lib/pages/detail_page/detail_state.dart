import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'detail_state.g.dart';

abstract class BookDetailState
    implements Built<BookDetailState, BookDetailStateBuilder> {
  String get id;
  String get title;
  String get subtitle;
  BuiltList<String> get authors;
  String get largeImage;
  String get thumbnail;
  bool get isFavorited;

  BookDetailState._();

  factory BookDetailState([updates(BookDetailStateBuilder b)]) =
      _$BookDetailState;
}
