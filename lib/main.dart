import 'package:demo_bloc_pattern/api/book_api.dart';
import 'package:demo_bloc_pattern/pages/home_page/home_bloc.dart';
import 'package:demo_bloc_pattern/pages/home_page/home_page.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() async {
  await SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(const MyApp());
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
        initBloc: () => HomeBloc(BookApi(http.Client())),
      ),
    );
  }
}
