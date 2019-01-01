import 'dart:io';

import 'package:demo_bloc_pattern/bloc/book_bloc.dart';
import 'package:demo_bloc_pattern/bloc/book_bloc_provider.dart';
import 'package:demo_bloc_pattern/model/book_model.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BookBlocProvider.of(context);

    return Scaffold(
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
            _buildSearchTextField(bloc.query.add),
            Expanded(
              child: StreamBuilder<HomePageState>(
                initialData: HomePageState.initial(),
                stream: bloc.homePageState,
                builder: (BuildContext context,
                    AsyncSnapshot<HomePageState> snapshot) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _buildResultText(snapshot.data?.resultText ?? ''),
                      _buildLoadingIndicator(
                          snapshot.data?.isFirstPageLoading ?? false),
                      Expanded(
                        child: _buildBookListView(
                          snapshot,
                          context,
                          bloc.loadNextPage.add,
                        ),
                      )
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

  Widget _buildLoadingIndicator(bool isLoading) {
    return isLoading
        ? Padding(
            padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
            child: CircularProgressIndicator(),
          )
        : Container();
  }

  Widget _buildSearchTextField(ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Search book...',
          contentPadding: EdgeInsets.all(12.0),
          filled: true,
          prefixIcon: Icon(Icons.book),
        ),
        maxLines: 1,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildBookItem(Book book, BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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

    final authors = <Widget>[Text('Authors: ', style: caption)]..addAll(
        book.authors.map<Widget>(
          (author) => Text(
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
        elevation: 6.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
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

  Widget _buildResultText(String resultText) {
    return Text(
      resultText,
      maxLines: 1,
      textScaleFactor: 0.9,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildBookListView(
    AsyncSnapshot<HomePageState> snapshot,
    BuildContext context,
    void Function(void) loadNextPage,
  ) {
    final data = snapshot.data;

    if (data.loadFirstPageError != null) {
      final error = data.loadFirstPageError;

      return Center(
        child: Text(
          error is HttpException ? error.message : 'An error occurred $error',
          style: Theme.of(context).textTheme.body1.copyWith(fontSize: 18),
        ),
      );
    }

    final booksData = data.books;

    return ListView.builder(
      itemCount: booksData.length + 1,
      padding: EdgeInsets.all(0.0),
      itemBuilder: (context, index) {
        if (index < booksData.length) {
          return _buildBookItem(booksData[index], context);
        }

        if (data.loadNextPageError != null) {
          final error = data.loadNextPageError;

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                error is HttpException
                    ? error.message
                    : 'An error occurred $error',
                style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16),
              ),
            ),
          );
        }

        if (data.isNextPageLoading) {
          print('build data.isNextPageLoading');

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            ),
          );
        }

        if (booksData.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: RaisedButton(
              onPressed: () => loadNextPage(null),
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
