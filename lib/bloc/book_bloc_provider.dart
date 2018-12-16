import 'package:flutter/material.dart';

import 'book_bloc.dart';

class BookBlocProvider extends StatefulWidget {
  final BookBloc bloc;
  final Widget child;

  const BookBlocProvider({
    Key key,
    @required this.bloc,
    @required this.child,
  }) : super(key: key);

  _BookBlocProviderState createState() => _BookBlocProviderState();

  static BookBloc of(BuildContext context) {
    return _BookBlocProvider.of(context).bloc;
  }
}

class _BookBlocProviderState extends State<BookBlocProvider> {
  @override
  Widget build(BuildContext context) {
    return _BookBlocProvider(
      bloc: widget.bloc,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    debugPrint('##DEBUG BookBloc::dispose');
    widget.bloc.dispose();
    super.dispose();
  }
}

class _BookBlocProvider extends InheritedWidget {
  final BookBloc bloc;

  _BookBlocProvider({
    Key key,
    @required Widget child,
    @required this.bloc,
  }) : super(key: key, child: child);

  static _BookBlocProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_BookBlocProvider)
        as _BookBlocProvider);
  }

  @override
  bool updateShouldNotify(_BookBlocProvider oldWidget) =>
      oldWidget.bloc != bloc;
}
