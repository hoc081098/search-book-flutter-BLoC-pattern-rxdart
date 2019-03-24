import 'package:demo_bloc_pattern/api/book_api.dart';
import 'package:demo_bloc_pattern/shared_pref.dart';
import 'package:flutter/material.dart';

class DependencyInjector extends InheritedWidget {
  final BookApi bookApi;
  final SharedPref sharedPref;

  const DependencyInjector({
    Key key,
    Widget child,
    @required this.bookApi,
    @required this.sharedPref,
  }) : super(key: key, child: child);

  static DependencyInjector of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(DependencyInjector)
        as DependencyInjector);
  }

  @override
  bool updateShouldNotify(DependencyInjector oldWidget) {
    return bookApi != oldWidget.bookApi && sharedPref != oldWidget.sharedPref;
  }
}
