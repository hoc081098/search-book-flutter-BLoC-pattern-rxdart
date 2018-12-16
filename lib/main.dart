import 'package:demo_bloc_pattern/api/book_api.dart';
import 'package:demo_bloc_pattern/bloc/book_bloc.dart';
import 'package:demo_bloc_pattern/bloc/book_bloc_provider.dart';
import 'package:demo_bloc_pattern/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  await SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search book bloc pattern',
      theme: ThemeData(
        fontFamily: 'NunitoSans',
        brightness: Brightness.dark,
      ),
      home: BookBlocProvider(
        child: MyHomePage(),
        bloc: BookBloc(const BookApi()),
      ),
    );
  }
}
