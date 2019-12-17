import 'package:built_value/built_value.dart';
import 'package:search_book/data/api/book_api.dart';
import 'package:search_book/data/book_repo_impl.dart';
import 'package:search_book/data/mappers.dart';
import 'package:search_book/domain/book_repo.dart';
import 'package:search_book/pages/home_page/home_bloc.dart';
import 'package:search_book/pages/home_page/home_page.dart';
import 'package:search_book/shared_pref.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomBuiltValueToStringHelper implements BuiltValueToStringHelper {
  StringBuffer _result = StringBuffer();
  bool _previousField = false;

  CustomBuiltValueToStringHelper(String className) {
    _result..write(className)..write(' {');
  }

  @override
  void add(String field, Object value) {
    if (value != null) {
      if (_previousField) _result.write(',');
      _result
        ..write(field + (value is Iterable ? '.length' : ''))
        ..write('=')
        ..write(value is Iterable ? value.length : value);
      _previousField = true;
    }
  }

  @override
  String toString() {
    _result..write('}');
    final stringResult = _result.toString();
    _result = null;
    return stringResult;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  newBuiltValueToStringHelper =
      (className) => CustomBuiltValueToStringHelper(className);

  await SystemChrome.setEnabledSystemUIOverlays([]);

  final bookApi = BookApi(http.Client());
  final sharedPref = SharedPref(SharedPreferences.getInstance());
  final mappers = Mappers();
  final BookRepo bookRepo = BookRepoImpl(bookApi, mappers);

  runApp(
    Providers(
      providers: <Provider>[
        Provider<BookRepo>(value: bookRepo),
        Provider<SharedPref>(value: sharedPref)
      ],
      child: const MyApp(),
    ),
  );
}

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
      home: Consumer2<SharedPref, BookRepo>(
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
