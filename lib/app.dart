import 'package:search_book/domain/book_repo.dart';
import 'package:search_book/pages/home_page/home_bloc.dart';
import 'package:search_book/pages/home_page/home_page.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:search_book/domain/favorited_books_repo.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search book BLoC pattern RxDart',
      theme: ThemeData(
        fontFamily: 'NunitoSans',
        brightness: Brightness.dark,
      ),
      home: Consumer2<FavoritedBooksRepo, BookRepo>(
        builder: (context, sharedPref, bookRepo) {
          return BlocProvider<HomeBloc>(
            child: MyHomePage(),
            initBloc: () => HomeBloc(bookRepo, sharedPref),
          );
        },
      ),
    );
  }
}
