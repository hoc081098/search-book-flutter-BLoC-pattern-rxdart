import 'package:built_collection/built_collection.dart';
import 'package:demo_bloc_pattern/pages/fav_page/fav_books_bloc.dart';
import 'package:demo_bloc_pattern/pages/fav_page/fav_books_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';

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
          return Provider<FavBooksBloc>(
            value: _bloc,
            child: FavBooksList(items: state.books),
          );
        },
      ),
    );
  }
}

class FavBooksList extends StatelessWidget {
  final BuiltList<FavBookItem> items;

  const FavBooksList({Key key, @required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FavBooksBloc>(
      builder: (context, bloc) {
        return RefreshIndicator(
          onRefresh: bloc.refresh,
          child: Container(
            constraints: BoxConstraints.expand(),
            child: ListView.builder(
              itemCount: items.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) =>
                  FavBookItemWidget(item: items[index]),
            ),
          ),
        );
      },
    );
  }
}

class FavBookItemWidget extends StatelessWidget {
  final FavBookItem item;

  const FavBookItemWidget({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    return Consumer<FavBooksBloc>(
      builder: (context, bloc) {
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
    );
  }
}
