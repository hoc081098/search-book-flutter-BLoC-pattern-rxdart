import 'package:built_collection/built_collection.dart';
import 'package:demo_bloc_pattern/pages/fav_page/fav_books_bloc.dart';
import 'package:demo_bloc_pattern/pages/fav_page/fav_books_state.dart';
import 'package:flutter/material.dart';

class FavoritedBooksPage extends StatefulWidget {
  final FavBooksBloc Function() initBloc;

  const FavoritedBooksPage({Key key, @required this.initBloc})
      : super(key: key);

  @override
  _FavoritedBooksPageState createState() => _FavoritedBooksPageState();
}

class _FavoritedBooksPageState extends State<FavoritedBooksPage> {
  FavBooksBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.initBloc();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorited books'),
      ),
      body: StreamBuilder<FavBooksState>(
        stream: _bloc.state$,
        initialData: _bloc.state$.value,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state.isLoading) {
            return Container(
              constraints: BoxConstraints.expand(),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return FavBooksList(
            items: state.books,
            bloc: _bloc,
          );
        },
      ),
    );
  }
}

class FavBooksList extends StatelessWidget {
  final BuiltList<FavBookItem> items;
  final FavBooksBloc bloc;

  const FavBooksList({
    Key key,
    @required this.items,
    @required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: RefreshIndicator(
        onRefresh: bloc.refresh,
        child: Container(
          constraints: BoxConstraints.expand(),
          child: ListView.builder(
            itemCount: items.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = items[index];
              if (item.isLoading) {
                return ListTile(
                  title: Text('Loading...'),
                  subtitle: Row(
                    children: <Widget>[
                      CircularProgressIndicator(strokeWidth: 2),
                      Spacer(),
                    ],
                  ),
                );
              }

              return Dismissible(
                child: ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.subtitle ?? 'No subtitle'),
                ),
                direction: DismissDirection.horizontal,
                onDismissed: (_) => bloc.removeFavorite(item.id),
                key: ValueKey(item.id),
              );
            },
          ),
        ),
      ),
    );
  }
}
