import 'package:built_value/built_value.dart' as built_value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:http/http.dart' as http;
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:search_book/app.dart';
import 'package:search_book/utils/custome_built_value_to_string_helper.dart';
import 'package:search_book/data/api/book_api.dart';
import 'package:search_book/data/book_repo_impl.dart';
import 'package:search_book/data/favorited_books_repo_impl.dart';
import 'package:search_book/data/mappers.dart';
import 'package:search_book/domain/book_repo.dart';
import 'package:search_book/domain/favorited_books_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  built_value.newBuiltValueToStringHelper =
      (className) => CustomBuiltValueToStringHelper(className);

  await SystemChrome.setEnabledSystemUIOverlays([]);

  final bookApi = BookApi(http.Client());
  final favBooksRepo = FavoritedBooksRepoImpl(
    RxSharedPreferences(
      SharedPreferences.getInstance(),
    ),
  );
  final mappers = Mappers();
  final bookRepo = BookRepoImpl(bookApi, mappers);

  runApp(
    Providers(
      providers: <Provider>[
        Provider<BookRepo>(value: bookRepo),
        Provider<FavoritedBooksRepo>(value: favBooksRepo)
      ],
      child: const MyApp(),
    ),
  );
}
