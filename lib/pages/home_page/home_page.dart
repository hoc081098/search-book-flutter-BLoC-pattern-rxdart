import 'dart:async';
import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:demo_bloc_pattern/api/book_api.dart';
import 'package:demo_bloc_pattern/fav_count_badge.dart';
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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<HomePageMessage> _subscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _subscription ??=
        BlocProvider.of<HomeBloc>(context).message$.listen((message) {
      if (message is AddToFavoriteSuccess) {
        _showSnackBar('Add `${message.item?.title}` to fav success');
      }
      if (message is AddToFavoriteFailure) {
        _showSnackBar(
            'Add `${message.item?.title}` to fav failure: ${message.error ?? 'Unknown error'}');
      }
      if (message is RemoveFromFavoriteSuccess) {
        _showSnackBar('Remove `${message.item?.title}` from fav success');
      }
      if (message is RemoveFromFavoriteFailure) {
        _showSnackBar(
            'Remove `${message.item?.title}` from fav failure: ${message.error ?? 'Unknown error'}');
      }
    });
  }

  Future<void> _showSnackBar(String msg) => _scaffoldKey.currentState
      ?.showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: const Duration(seconds: 2),
        ),
      )
      ?.closed;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

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
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        heroTag: 'FAV_COUNT',
        tooltip: 'Favorite page',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Consumer2<SharedPref, BookApi>(
                  builder: (context, sharedPref, api) {
                    return BlocProvider<FavBooksBloc>(
                      initBloc: () {
                        return FavBooksBloc(
                          FavBooksInteractor(
                            api,
                            sharedPref,
                          ),
                        );
                      },
                      child: FavoritedBooksPage(),
                    );
                  },
                );
              },
            ),
          );
        },
        child: Stack(
          children: <Widget>[
            Align(
              alignment: AlignmentDirectional.center,
              child: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
            ),
            StreamBuilder<int>(
              stream: bloc.favoriteCount$,
              initialData: bloc.favoriteCount$.value,
              builder: (context, snapshot) {
                return Positioned(
                  top: 0,
                  right: 0,
                  child: FavCountBadge(
                    key: ValueKey(snapshot.data),
                    count: snapshot.data,
                  ),
                );
              },
            ),
          ],
        ),
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
              Colors.teal.withOpacity(0.9),
              Colors.deepPurpleAccent.withOpacity(0.9),
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
                            .copyWith(fontSize: 15),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
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
      padding: const EdgeInsets.all(0),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        if (index < items.length) {
          final item = items[index];
          return HomeBookItemWidget(
            book: item,
            key: Key(item.id),
          );
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onPressed: bloc.retryNextPage,
                  padding: const EdgeInsets.all(16.0),
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
            padding: const EdgeInsets.all(16.0),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
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

class HomeBookItemWidget extends StatefulWidget {
  final BookItem book;

  const HomeBookItemWidget({Key key, @required this.book})
      : assert(book != null),
        super(key: key);

  @override
  _HomeBookItemWidgetState createState() => _HomeBookItemWidgetState();
}

class _HomeBookItemWidgetState extends State<HomeBookItemWidget>
    with SingleTickerProviderStateMixin<HomeBookItemWidget> {
  AnimationController _animController;
  Animation<Offset> _position;
  Animation<double> _scale;
  Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _position = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _scale = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeIn,
      ),
    );
    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeInCubic,
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _book = widget.book;
    final bloc = BlocProvider.of<HomeBloc>(context);
    final textTheme = Theme.of(context).textTheme;

    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _position,
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 8,
                )
              ],
            ),
            margin: const EdgeInsets.all(8.0),
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
                                  _book.toBookModel(),
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
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(5.0, 5.0),
                            blurRadius: 12,
                          )
                        ],
                      ),
                      child: Hero(
                        tag: _book.id,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          clipBehavior: Clip.antiAlias,
                          child: FadeInImage.assetNetwork(
                            image: _book.thumbnail,
                            width: 64.0 * 1.5,
                            height: 96.0 * 1.5,
                            fit: BoxFit.cover,
                            placeholder: 'assets/no_image.png',
                          ),
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
                              _book.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.subhead.copyWith(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              _book.subtitle.isEmpty
                                  ? 'No subtitle...'
                                  : _book.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.caption.copyWith(
                                color: Colors.black54,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 8),
                            _book.isFavorited == null
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : FloatingActionButton(
                                    heroTag: null,
                                    onPressed: () => bloc.toggleFavorited(_book.id),
                                    child: _book.isFavorited
                                        ? Icon(
                                            Icons.favorite,
                                            color: Theme.of(context).accentColor,
                                          )
                                        : Icon(
                                            Icons.favorite_border,
                                            color: Theme.of(context).accentColor,
                                          ),
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    tooltip: _book.isFavorited
                                        ? 'Remove from favorite'
                                        : 'Add to favorite',
                                  ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
