import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:demo_bloc_pattern/api/book_api.dart';
import 'package:demo_bloc_pattern/pages/detail_page/detail_bloc.dart';
import 'package:demo_bloc_pattern/pages/detail_page/detail_page.dart';
import 'package:demo_bloc_pattern/pages/fav_page/fav_books_bloc.dart';
import 'package:demo_bloc_pattern/pages/fav_page/fav_books_page.dart';
import 'package:demo_bloc_pattern/pages/home_page/home_bloc.dart';
import 'package:demo_bloc_pattern/pages/home_page/home_state.dart';
import 'package:demo_bloc_pattern/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_provider/flutter_provider.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeBloc>(context);

    final searchTextField = Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Search book...',
          contentPadding: EdgeInsets.all(12.0),
          filled: true,
          prefixIcon: Icon(Icons.book),
        ),
        maxLines: 1,
        onChanged: bloc.changeQuery,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
      ),
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Consumer2<SharedPref, BookApi>(
                  builder: (context, sharedPref, api) {
                    return FavoritedBooksPage(
                      initBloc: () =>
                          FavBooksBloc(FavBooksInteractor(api, sharedPref)),
                    );
                  },
                );
              },
            ),
          );
        },
        child: Icon(Icons.favorite),
      ),
      body: Container(
        padding: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: 8.0,
          top: MediaQuery.of(context).padding.top,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Colors.teal.withOpacity(0.8),
              Colors.deepPurpleAccent.withOpacity(0.6),
            ],
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            stops: <double>[0.3, 0.7],
          ),
        ),
        child: Column(
          children: <Widget>[
            searchTextField,
            Expanded(
              child: StreamBuilder<HomePageState>(
                stream: bloc.state$,
                initialData: bloc.state$.value,
                builder: (context, snapshot) {
                  final HomePageState data = snapshot.data;

                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        data.resultText ?? '',
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      data.isFirstPageLoading
                          ? Padding(
                              padding: const EdgeInsets.only(
                                bottom: 16.0,
                                top: 8.0,
                              ),
                              child: CircularProgressIndicator(),
                            )
                          : Container(),
                      Expanded(child: HomeListViewWidget(state: data))
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeListViewWidget extends StatelessWidget {
  final HomePageState state;

  const HomeListViewWidget({Key key, @required this.state})
      : assert(state != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {

    final bloc = BlocProvider.of<HomeBloc>(context);

    if (state.loadFirstPageError != null) {
      final error = state.loadFirstPageError;

      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              error is HttpException
                  ? error.message
                  : 'An error occurred $error',
              textAlign: TextAlign.center,
              maxLines: 2,
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 15),
            ),
            SizedBox(height: 16),
            RaisedButton(
              elevation: 4,
              child: Text(
                'Retry',
                style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16),
              ),
              padding: EdgeInsets.all(16.0),
              onPressed: bloc.retryFirstPage,
            ),
          ],
        ),
      );
    }

    final BuiltList<BookItem> items = state.books;

    if (items.isEmpty) {
      return Container(
        constraints: BoxConstraints.expand(),
        child: Center(
          child: Text(
            'Empty search result. Try other?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.body1.copyWith(fontSize: 15),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: items.length + 1,
      padding: EdgeInsets.all(0.0),
      itemBuilder: (context, index) {
        if (index < items.length) {
          return HomeBookItemWidget(book: items[index]);
        }

        if (state.loadNextPageError != null) {
          final Object error = state.loadNextPageError;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  error is HttpException
                      ? error.message
                      : 'An error occurred $error',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style:
                      Theme.of(context).textTheme.body1.copyWith(fontSize: 15),
                ),
                SizedBox(height: 8),
                RaisedButton(
                  onPressed: bloc.retryNextPage,
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Retry',
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(fontSize: 16),
                  ),
                  elevation: 4.0,
                ),
              ],
            ),
          );
        }

        if (state.isNextPageLoading) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            ),
          );
        }

        if (items.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: RaisedButton(
              onPressed: bloc.loadNextPage,
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Load next page',
                style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16),
              ),
              elevation: 4.0,
            ),
          );
        }

        return Container();
      },
    );
  }
}

class HomeBookItemWidget extends StatelessWidget {
  final BookItem book;

  const HomeBookItemWidget({Key key, @required this.book})
      : assert(book != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    print('[HOME_PAGE] Book item build $book');

    final bloc = BlocProvider.of<HomeBloc>(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.teal,
            offset: Offset(5.0, 5.0),
            blurRadius: 10.0,
          )
        ],
      ),
      margin: const EdgeInsets.all(4.0),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return Consumer2<SharedPref, BookApi>(
                    builder: (context, sharedPref, bookApi) {
                      return DetailPage(
                        initBloc: () {
                          return DetailBloc(
                            bookApi,
                            sharedPref,
                            book.toBookModel(),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    topLeft: Radius.circular(8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(5.0, 5.0),
                      blurRadius: 10.0,
                    )
                  ],
                ),
                child: Hero(
                  tag: book.id,
                  child: FadeInImage.assetNetwork(
                    image: book.thumbnail,
                    width: 64.0 * 1.5,
                    height: 96.0 * 1.5,
                    fit: BoxFit.cover,
                    placeholder: 'assets/no_image.png',
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.subhead.copyWith(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        book.subtitle.isEmpty
                            ? 'No subtitle...'
                            : book.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.caption.copyWith(
                          color: Colors.black54,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 8),
                      book.isFavorited == null
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () => bloc.toggleFavorited(book.id),
                              child: Padding(
                                child: book.isFavorited
                                    ? Icon(
                                        Icons.favorite,
                                        color: Theme.of(context).accentColor,
                                      )
                                    : Icon(
                                        Icons.favorite_border,
                                        color: Theme.of(context).accentColor,
                                      ),
                                padding: const EdgeInsets.all(16),
                              ),
                            ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
