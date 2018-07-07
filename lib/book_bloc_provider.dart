import 'package:flutter/material.dart';

import 'book_bloc.dart';

class BookBlocProvider extends InheritedWidget {
  final BookBloc bloc;

  const BookBlocProvider({@required this.bloc, Key key, Widget child})
      : assert(bloc != null),
        assert(child != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static BookBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(BookBlocProvider)
              as BookBlocProvider)
          .bloc;
}
