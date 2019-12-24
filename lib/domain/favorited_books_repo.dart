import 'package:rxdart/rxdart.dart';
import 'package:built_collection/built_collection.dart';
import 'package:search_book/domain/toggle_fav_result.dart';

abstract class FavoritedBooksRepo {
  Future<ToggleFavResult> toggleFavorited(String bookId);

  ValueStream<BuiltSet<String>> get favoritedIds$;
}
