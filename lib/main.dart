import 'package:built_value/built_value.dart';
import 'package:demo_bloc_pattern/api/book_api.dart';
import 'package:demo_bloc_pattern/dependency_injector.dart';
import 'package:demo_bloc_pattern/pages/home_page/home_bloc.dart';
import 'package:demo_bloc_pattern/pages/home_page/home_page.dart';
import 'package:demo_bloc_pattern/shared_pref.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomBuiltValueToStringHelper implements BuiltValueToStringHelper {
  StringBuffer _result = new StringBuffer();
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
    DependencyInjector(
      child: const MyApp(),
      bookApi: bookApi,
      sharedPref: sharedPref,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search book bloc pattern',
      theme: ThemeData(
        fontFamily: 'NunitoSans',
        brightness: Brightness.dark,
      ),
      home: BlocProvider<HomeBloc>(
        child: MyHomePage(),
        initBloc: () {
          final dependencyInjector = DependencyInjector.of(context);
          return HomeBloc(
            dependencyInjector.bookApi,
            dependencyInjector.sharedPref,
          );
        },
      ),
    );
  }
}
