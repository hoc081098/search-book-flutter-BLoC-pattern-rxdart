import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'book_api.dart';
import 'book_bloc.dart';
import 'book_bloc_provider.dart';
import 'book_model.dart';

void main() {
  const api = BookApi();
  final bloc = BookBloc(api);
  runApp(MyApp(bloc));
}

class MyApp extends StatelessWidget {
  final BookBloc bloc;

  const MyApp(this.bloc, {Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BookBlocProvider(
      bloc: bloc,
      child: MaterialApp(
        title: 'Demo bloc pattern',
        theme: ThemeData(
          fontFamily: 'NunitoSans',
          brightness: Brightness.dark,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    final bloc = BookBlocProvider.of(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: 8.0,
          top: MediaQuery
              .of(context)
              .padding
              .top,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Colors.teal.withOpacity(0.8),
              Colors.deepPurple.withOpacity(0.6),
            ],
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            stops: <double>[0.3, 0.7],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildSearchTextField(bloc),
            _buildResultText(bloc),
            _buildLoadingIndicator(bloc),
            _buildBookListView(bloc)
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(BookBloc bloc) {
    return StreamBuilder<bool>(
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return (snapshot.data ?? false)
            ? Padding(
          padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
          child: CircularProgressIndicator(),
        )
            : Container();
      },
      stream: bloc.isLoading,
    );
  }

  Widget _buildSearchTextField(BookBloc bloc) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Search book...',
          contentPadding: EdgeInsets.all(8.0),
          filled: true,
          prefixIcon: Icon(Icons.book),
        ),
        maxLines: 1,
        onChanged: bloc.query.add,
      ),
    );
  }

  Widget _buildBookItem(Book book, BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    final caption = textTheme.caption.copyWith(color: Colors.black54);

    final listTile = ListTile(
      title: Text(
        book.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: textTheme.subhead.copyWith(color: Color(0xFF212121)),
      ),
      subtitle: Text(
        book.subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: caption,
      ),
    );

    final authors = <Widget>[Text('Authors: ', style: caption)]
      ..addAll(
        book.authors.map<Widget>(
              (author) =>
              Text(
                author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: caption,
              ),
        ),
      );

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: 4.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FadeInImage.assetNetwork(
              image: book.thumbnail,
              width: 64.0,
              height: 96.0,
              fit: BoxFit.cover,
              placeholder: 'assets/no_image.png',
            ),
            Expanded(
              child: ExpansionTile(
                title: listTile,
                children: authors,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultText(BookBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.resultText,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        final resultText = snapshot.data ?? '';
        return Text(
          resultText,
          maxLines: 1,
          textScaleFactor: 0.8,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }

  Widget _buildBookListView(BookBloc bloc) {
    return Expanded(
      child: StreamBuilder<List<Book>>(
        stream: bloc.books,
        builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
          final body1Style = Theme
              .of(context)
              .textTheme
              .body1;
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Center(
              child: Text(
                error is HttpException ? error.message : 'An error occurred',
                style: body1Style,
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Center(
              child: Text(
                'No book found!',
                style: body1Style,
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            padding: EdgeInsets.all(0.0),
            itemBuilder: (context, index) =>
                _buildBookItem(snapshot.data[index], context),
          );
        },
      ),
    );
  }
}
