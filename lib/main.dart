import 'package:built_value/built_value.dart';
import 'package:search_book/api/book_api.dart';
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
  newBuiltValueToStringHelper =
      (className) => CustomBuiltValueToStringHelper(className);

  await SystemChrome.setEnabledSystemUIOverlays([]);

  final bookApi = BookApi(http.Client());
  final sharedPref = SharedPref(SharedPreferences.getInstance());

  runApp(
    Providers(
      providers: <Provider>[
        Provider<BookApi>(value: bookApi),
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
      home: Consumer2<SharedPref, BookApi>(
        builder: (context, sharedPref, bookApi) {
          return BlocProvider<HomeBloc>(
            child: MyHomePage(),
            initBloc: () => HomeBloc(bookApi, sharedPref),
          );
        },
      ),
    );
  }
}
