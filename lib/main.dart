import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'book_api.dart';
import 'book_bloc.dart';
import 'book_bloc_provider.dart';
import 'book_model.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return BookBlocProvider(
      bloc: BookBloc(BookApi()),
      child: MaterialApp(
        title: 'Demo bloc pattern',
        theme: new ThemeData(
          fontFamily: 'NunitoSans',
          brightness: Brightness.dark,
        ),
        home: new MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    final BookBloc bloc = BookBlocProvider.of(context);

    return new Scaffold(
      body: new Container(
        padding: new EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            bottom: 8.0,
            top: MediaQuery
                .of(context)
                .padding
                .top),
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: <Color>[
              Colors.blue.withOpacity(0.8),
              Colors.purple.withOpacity(0.6),
            ],
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            stops: <double>[0.2, 0.8],
          ),
        ),
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
              child: new TextField(
                decoration: InputDecoration(
                  labelText: 'Search book...',
                  contentPadding: EdgeInsets.all(8.0),
                  filled: true,
                  prefixIcon: Icon(Icons.book),
                ),
                maxLines: 1,
                onChanged: bloc.query.add,
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new StreamBuilder<String>(
                stream: bloc.searchText,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasError) {
                    return new Center(
                      child: new Text(
                        snapshot.error.toString(),
                        style: Theme
                            .of(context)
                            .textTheme
                            .body1,
                      ),
                    );
                  }
                  final s = snapshot.data ?? "";
                  return new Text(
                    s,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            ),
            new Expanded(
              child: new StreamBuilder<List<Book>>(
                stream: bloc.books,
                builder:
                    (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
                  if (snapshot.hasError) {
                    return new Center(
                      child: new Text(
                        snapshot.error.toString(),
                        style: Theme.of(context).textTheme.body1,
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return new Center(
                      child: new CircularProgressIndicator(),
                    );
                  }
                  snapshot.data.forEach((d) => debugPrint(d.toString()));
                  return _buildListBook(snapshot.data);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListBook(List<Book> data) {
    debugPrint(data.length.toString());
    return new ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) => _buildBookItem(data[index]),
    );
  }

  _buildBookItem(Book book) {
    return new Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: new Material(
        elevation: 3.0,
        color: Colors.transparent,
        borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Image.network(
              book.thumbnail,
              width: 64.0,
              height: 96.0,
              fit: BoxFit.cover,
            ),
            new Expanded(
              child: new ExpansionTile(
                title: new ListTile(
                  title: Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    book.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                children: [
                  Text(
                    'Authors: ',
                    style: new TextStyle(fontSize: 12.0),
                  ),
                  book.authors.map<Widget>(
                        (author) =>
                        Text(
                          author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(fontSize: 12.0),
                        ),
                  ),
                ].expand<Widget>((i) => i is Iterable ? i : [i]).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
